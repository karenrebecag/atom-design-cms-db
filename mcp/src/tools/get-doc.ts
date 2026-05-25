import { z } from 'zod';
import { fetchDocBySlug } from '../client.js';
import { blocksToMarkdown } from '../blocks-to-text.js';
import { fetchBrandContext } from './list-docs.js';

const GetDocInput = z.object({ slug: z.string().min(1) });

export const getDocSchema = {
  type: 'object' as const,
  properties: {
    slug: {
      type: 'string',
      description:
        'Document slug (e.g. "versiones-del-logo", "paleta-primaria"). Use atom_docs_list to see available slugs.',
    },
  },
  required: ['slug'],
};

export async function handleGetDoc(args: unknown) {
  const parsed = GetDocInput.safeParse(args);
  if (!parsed.success) {
    return {
      content: [{ type: 'text' as const, text: `Invalid input: ${parsed.error.message}` }],
      isError: true,
    };
  }
  const { slug } = parsed.data;

  const result = await fetchDocBySlug(slug);

  if (!result) {
    return {
      content: [
        {
          type: 'text' as const,
          text: `Document "${slug}" not found. Use atom_docs_list to see available documents.`,
        },
      ],
      isError: true,
    };
  }

  const { doc, blocks } = result;
  const content = blocksToMarkdown(blocks);

  const lines = [
    `# ${doc.title}`,
    '',
    doc.description ? `> ${doc.description}` : '',
    '',
    content,
  ].filter(Boolean);

  const brandCtx = await fetchBrandContext();

  return {
    content: [{ type: 'text' as const, text: lines.join('\n') + '\n\n---\n' + brandCtx }],
  };
}
