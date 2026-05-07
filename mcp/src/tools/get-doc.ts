import { fetchDocBySlug } from '../client.js';
import { blocksToMarkdown } from '../blocks-to-text.js';

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
  const { slug } = args as { slug: string };

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

  return {
    content: [{ type: 'text' as const, text: lines.join('\n') }],
  };
}
