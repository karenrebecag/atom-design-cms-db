import { z } from 'zod';
import satori from 'satori';
import { Resvg } from '@resvg/resvg-js';
import { getSatoriTemplate, type TemplateAssets } from '../satori-templates.js';

const ScreenshotInput = z.object({
  template: z.string().min(1),
  values: z.record(z.string()),
});

export const screenshotSchema = {
  type: 'object' as const,
  properties: {
    template: {
      type: 'string',
      enum: ['case-study', 'photo-overlay-dark'],
      description: 'Template to render as PNG image.',
    },
    values: {
      type: 'object',
      description: 'Template values (same as atom_layout_render). Include image_url for photos.',
      additionalProperties: { type: 'string' },
    },
  },
  required: ['template', 'values'],
};

// Font cache — loaded once
let fontCache: ArrayBuffer | null = null;

async function getInterFont(): Promise<ArrayBuffer> {
  if (fontCache) return fontCache;
  const res = await fetch(
    'https://cdn.jsdelivr.net/npm/@fontsource/inter/files/inter-latin-700-normal.woff',
  );
  if (!res.ok) throw new Error(`Failed to fetch Inter font: ${res.status}`);
  fontCache = await res.arrayBuffer();
  return fontCache;
}

// Pre-fetch an image URL as data URI
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
    fetchAsDataUri(
      'https://cdn.jsdelivr.net/npm/@atomchat.io/mcp-docs@latest/assets/ATOM-horizontal-light.svg',
    ),
    fetchAsDataUri(
      'https://cdn.jsdelivr.net/npm/@atomchat.io/mcp-docs@latest/assets/ATOM-horizontal-dark.svg',
    ),
    imageUrl ? fetchAsDataUri(imageUrl) : Promise.resolve(undefined),
  ]);

  return { logoLight, logoDark, photo };
}

export async function handleScreenshot(args: unknown) {
  const parsed = ScreenshotInput.safeParse(args);
  if (!parsed.success) {
    return {
      content: [{ type: 'text' as const, text: `Invalid input: ${parsed.error.message}` }],
      isError: true,
    };
  }

  const { template, values } = parsed.data;

  const tmpl = getSatoriTemplate(template);
  if (!tmpl) {
    return {
      content: [
        {
          type: 'text' as const,
          text: `Template "${template}" not available for screenshot. Available: case-study, photo-overlay-dark`,
        },
      ],
      isError: true,
    };
  }

  try {
    const [font, assets] = await Promise.all([getInterFont(), loadAssets(values.image_url)]);

    const jsxNode = tmpl.build(values, assets);

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const svg = await satori(jsxNode as any, {
      width: tmpl.width,
      height: tmpl.height,
      fonts: [
        { name: 'Inter', data: font, weight: 400, style: 'normal' as const },
        { name: 'Inter', data: font, weight: 600, style: 'normal' as const },
        { name: 'Inter', data: font, weight: 700, style: 'normal' as const },
        { name: 'Inter', data: font, weight: 800, style: 'normal' as const },
      ],
    });

    const resvg = new Resvg(svg, {
      fitTo: { mode: 'width' as const, value: tmpl.width * 2 }, // @2x
    });
    const png = resvg.render().asPng();

    // Return as base64 data URI — Claude can display this directly
    const base64 = Buffer.from(png).toString('base64');
    const dataUri = `data:image/png;base64,${base64}`;

    return {
      content: [
        {
          type: 'image' as const,
          data: base64,
          mimeType: 'image/png',
        },
        {
          type: 'text' as const,
          text: `Screenshot rendered: ${tmpl.width}x${tmpl.height} @2x (${tmpl.name}). ${Math.round(png.length / 1024)}KB PNG.`,
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
