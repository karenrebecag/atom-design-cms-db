/**
 * Zod schemas per template — contract between LLM and renderer.
 * The LLM sees field names, types, and defaults. No guessing.
 */
import { z } from 'zod';

export const TEMPLATE_SCHEMAS = {
  'case-study': z.object({
    image_url: z.string().optional(),
    tag_text: z.string().default('Caso de exito'),
    tag_intent: z.enum(['brand', 'ai', 'success', 'neutral']).default('success'),
    client_name: z.string(),
    kicker: z.string().optional(),
    headline: z.string(),
    subheadline: z.string().optional(),
    cta_text: z.string().optional(),
  }),

  'photo-overlay-dark': z.object({
    image_url: z.string().optional(),
    tag_text: z.string().optional(),
    tag_intent: z.enum(['brand', 'ai', 'success', 'neutral']).default('brand'),
    headline: z.string(),
    subtitle: z.string().optional(),
    cta_text: z.string().optional(),
    hashtags: z.string().default('#AtomChat #AIAgents'),
  }),

  'stat-card': z.object({
    number: z.string(),
    context: z.string().optional(),
    headline: z.string().optional(),
    bg: z.enum(['dark', 'light']).default('dark'),
  }),

  'quote-card': z.object({
    author_name: z.string(),
    author_role: z.string().optional(),
    quote: z.string(),
  }),

  'stat-card-gradient': z.object({
    number: z.string(),
    context: z.string().optional(),
    headline: z.string().optional(),
  }),
} as const;

export type TemplateName = keyof typeof TEMPLATE_SCHEMAS;
export const TEMPLATE_NAMES = Object.keys(TEMPLATE_SCHEMAS) as TemplateName[];
