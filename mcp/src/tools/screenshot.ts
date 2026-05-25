import { z } from 'zod';
import satori from 'satori';
import { Resvg } from '@resvg/resvg-js';
import { getSatoriTemplate, type TemplateAssets } from '../satori-templates.js';
import { TEMPLATE_SCHEMAS, TEMPLATE_NAMES, type TemplateName } from '../template-schemas.js';

const LOGO_LIGHT =
  'https://cdn.jsdelivr.net/npm/@atomchat.io/mcp-docs@latest/assets/ATOM-horizontal-light.svg';
const LOGO_DARK =
  'https://cdn.jsdelivr.net/npm/@atomchat.io/mcp-docs@latest/assets/ATOM-horizontal-dark.svg';

const ScreenshotInput = z.object({
  template: z.enum(TEMPLATE_NAMES as [string, ...string[]]),
  values: z.record(z.string()),
});

export const screenshotSchema = {
  type: 'object' as const,
  properties: {
    template: {
      type: 'string',
      enum: TEMPLATE_NAMES,
      description:
        'Template to render as PNG. Each template has specific fields — use atom_layout_list to see them.',
    },
    values: {
      type: 'object',
      description:
        'Template values. Fields depend on template. case-study: client_name, headline, image_url, kicker?, subheadline?, cta_text?. photo-overlay-dark: headline, image_url, subtitle?, cta_text?, hashtags?. stat-card: number, context?, headline?, bg?. quote-card: author_name, quote, author_role?.',
      additionalProperties: { type: 'string' },
    },
  },
  required: ['template', 'values'],
};

// Font cache
const fontCache = new Map<number, ArrayBuffer>();
const FONT_BASE = 'https://cdn.jsdelivr.net/npm/@fontsource/inter/files';

async function fetchFont(weight: number): Promise<ArrayBuffer> {
  const cached = fontCache.get(weight);
  if (cached) return cached;
  const res = await fetch(`${FONT_BASE}/inter-latin-${weight}-normal.woff`);
  if (!res.ok) throw new Error(`Failed to fetch Inter ${weight}: ${res.status}`);
  const buf = await res.arrayBuffer();
  fontCache.set(weight, buf);
  return buf;
}

async function getInterFonts() {
  const [w500, w700, w800] = await Promise.all([fetchFont(500), fetchFont(700), fetchFont(800)]);
  return [
    { name: 'Inter', data: w500, weight: 400 as const, style: 'normal' as const },
    { name: 'Inter', data: w500, weight: 500 as const, style: 'normal' as const },
    { name: 'Inter', data: w700, weight: 600 as const, style: 'normal' as const },
    { name: 'Inter', data: w700, weight: 700 as const, style: 'normal' as const },
    { name: 'Inter', data: w800, weight: 800 as const, style: 'normal' as const },
  ];
}

async function fetchAsDataUri(url: string): Promise<string> {
  try {
    const res = await fetch(url);
    if (!res.ok) return url;
    const buf = await res.arrayBuffer();
    const contentType = res.headers.get('content-type') || 'image/png';
    const base64 = Buffer.from(buf).toString('base64');
    return `data:${contentType};base64,${base64}`;
  } catch {
    return url;
  }
}

async function loadAssets(imageUrl?: string): Promise<TemplateAssets> {
  const [logoLight, logoDark, photo] = await Promise.all([
    fetchAsDataUri(LOGO_LIGHT),
    fetchAsDataUri(LOGO_DARK),
    imageUrl ? fetchAsDataUri(imageUrl) : Promise.resolve(undefined),
  ]);
  return { logoLight, logoDark, photo };
}

export async function handleScreenshot(args: unknown) {
  // Step 1: validate top-level shape
  const inputParsed = ScreenshotInput.safeParse(args);
  if (!inputParsed.success) {
    return {
      content: [{ type: 'text' as const, text: `Invalid input: ${inputParsed.error.message}` }],
      isError: true,
    };
  }

  const { template, values: rawValues } = inputParsed.data;
  const templateName = template as TemplateName;

  // Step 2: validate values against template-specific schema
  const schema = TEMPLATE_SCHEMAS[templateName];
  if (!schema) {
    return {
      content: [
        {
          type: 'text' as const,
          text: `Template "${template}" not found. Available: ${TEMPLATE_NAMES.join(', ')}`,
        },
      ],
      isError: true,
    };
  }

  const valuesParsed = schema.safeParse(rawValues);
  if (!valuesParsed.success) {
    const errors = valuesParsed.error.issues
      .map((i) => `${i.path.join('.')}: ${i.message}`)
      .join('; ');
    return {
      content: [
        {
          type: 'text' as const,
          text: `Invalid values for "${template}": ${errors}`,
        },
      ],
      isError: true,
    };
  }

  const values = valuesParsed.data as Record<string, string | undefined>;

  // Step 3: get Satori template
  const tmpl = getSatoriTemplate(templateName);
  if (!tmpl) {
    return {
      content: [{ type: 'text' as const, text: `Satori template "${template}" not implemented.` }],
      isError: true,
    };
  }

  try {
    // Step 4: load assets with explicit mapping
    const [fonts, assets] = await Promise.all([getInterFonts(), loadAssets(values.image_url)]);

    // Step 5: build + render
    const jsxNode = tmpl.build(values, assets);

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const svg = await satori(jsxNode as any, {
      width: tmpl.width,
      height: tmpl.height,
      fonts,
    });

    const resvg = new Resvg(svg, {
      fitTo: { mode: 'width' as const, value: tmpl.width * 2 },
    });
    const png = resvg.render().asPng();
    const base64 = Buffer.from(png).toString('base64');

    return {
      content: [
        { type: 'image' as const, data: base64, mimeType: 'image/png' },
        {
          type: 'text' as const,
          text: `Screenshot: ${tmpl.width}x${tmpl.height} @2x (${tmpl.name}). ${Math.round(png.length / 1024)}KB.`,
        },
      ],
    };
  } catch (err) {
    return {
      content: [
        {
          type: 'text' as const,
          text: `Screenshot failed: ${err instanceof Error ? err.message : String(err)}`,
        },
      ],
      isError: true,
    };
  }
}
