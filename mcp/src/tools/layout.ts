import { z } from 'zod';
import { getTemplate, listTemplates, renderTemplate } from '../templates.js';

const LayoutInput = z.object({
  template: z.string().min(1),
  values: z.record(z.string()),
});

export const layoutSchema = {
  type: 'object' as const,
  properties: {
    template: {
      type: 'string',
      enum: [
        'case-study',
        'photo-overlay-dark',
        'event-hero',
        'split-layout',
        'editorial-light',
        'story-reel',
        'youtube-thumbnail',
        'carousel-cover',
        'carousel-slide',
        'carousel-cta',
      ],
      description:
        'Template name. Use atom_layout_list to see all available templates with their placeholders.',
    },
    values: {
      type: 'object',
      description:
        'Key-value pairs for template placeholders. Use {{hl}}text{{/hl}} for orange highlight, {{wa}}text{{/wa}} for green WhatsApp, {{b}}text{{/b}} for bold.',
      additionalProperties: { type: 'string' },
    },
  },
  required: ['template', 'values'],
};

export const layoutListSchema = {
  type: 'object' as const,
  properties: {},
};

export async function handleLayout(args: unknown) {
  const parsed = LayoutInput.safeParse(args);
  if (!parsed.success) {
    return {
      content: [{ type: 'text' as const, text: `Invalid input: ${parsed.error.message}` }],
      isError: true,
    };
  }
  const { template, values } = parsed.data;

  const tmpl = getTemplate(template);
  if (!tmpl) {
    const available = listTemplates()
      .map((t) => t.name)
      .join(', ');
    return {
      content: [
        {
          type: 'text' as const,
          text: `Template "${template}" not found. Available: ${available}`,
        },
      ],
      isError: true,
    };
  }

  // Check required placeholders
  const missing: string[] = [];
  for (const [key, meta] of Object.entries(tmpl.placeholders)) {
    if (meta.required && !values[key]) {
      missing.push(key);
    }
  }

  if (missing.length > 0) {
    return {
      content: [
        {
          type: 'text' as const,
          text: `Missing required values: ${missing.join(', ')}.\n\nTemplate "${template}" placeholders:\n${Object.entries(
            tmpl.placeholders,
          )
            .map(([k, v]) => `- ${k}${v.required ? ' (required)' : ''}: ${v.description}`)
            .join('\n')}`,
        },
      ],
      isError: true,
    };
  }

  const html = renderTemplate(template, values);
  if (!html) {
    return {
      content: [{ type: 'text' as const, text: 'Failed to render template.' }],
      isError: true,
    };
  }

  return {
    content: [
      {
        type: 'text' as const,
        text: `# Layout: ${tmpl.name}\n\nRendered HTML artifact (1080x1350, 4:5 portrait). Copy the HTML below:\n\n\`\`\`html\n${html}\n\`\`\``,
      },
    ],
  };
}

export async function handleLayoutList(_args: unknown) {
  const templates = listTemplates();

  const lines = ['# Layout Templates', '', `${templates.length} templates available:`, ''];

  for (const t of templates) {
    const tmpl = getTemplate(t.name)!;
    lines.push(`## ${t.name}`);
    lines.push(`> ${t.description}`);
    lines.push('');
    lines.push('**Placeholders:**');
    for (const [key, meta] of Object.entries(tmpl.placeholders)) {
      lines.push(
        `- \`${key}\`${meta.required ? ' (required)' : ''}: ${meta.description}${meta.default ? ` (default: ${meta.default})` : ''}`,
      );
    }
    lines.push('');
  }

  lines.push(
    '**Highlight syntax:** `{{hl}}orange text{{/hl}}`, `{{wa}}green text{{/wa}}`, `{{b}}bold{{/b}}`',
  );

  return {
    content: [{ type: 'text' as const, text: lines.join('\n') }],
  };
}
