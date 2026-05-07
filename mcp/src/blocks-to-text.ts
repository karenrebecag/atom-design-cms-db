import type { Block } from './client.js';

/**
 * Converts Payload CMS blocks into readable markdown for LLM consumption.
 */
export function blocksToMarkdown(blocks: Block[]): string {
  return blocks.map(blockToMarkdown).filter(Boolean).join('\n\n');
}

function blockToMarkdown(block: Block): string {
  switch (block.blockType) {
    case 'richText':
      return lexicalToMarkdown(block.content);
    case 'codeBlock':
      return codeBlockToMarkdown(block);
    case 'imageBlock':
      return imageToMarkdown(block);
    case 'callout':
      return calloutToMarkdown(block);
    case 'steps':
      return stepsToMarkdown(block);
    case 'cardGrid':
      return cardGridToMarkdown(block);
    case 'table':
      return tableToMarkdown(block);
    case 'divider':
      return '---';
    case 'colorSwatch':
      return colorSwatchToMarkdown(block);
    case 'dosDonts':
      return dosDontsToMarkdown(block);
    case 'downloadButton':
      return downloadToMarkdown(block);
    case 'contactCard':
      return contactCardToMarkdown(block);
    default:
      return '';
  }
}

// --- Lexical rich text ---

function lexicalToMarkdown(content: unknown): string {
  if (!content || typeof content !== 'object') return '';
  const root = (content as { root?: { children?: unknown[] } }).root;
  if (!root?.children) return '';
  return root.children.map((node) => lexicalNodeToMd(node)).join('\n');
}

function lexicalNodeToMd(node: unknown, depth = 0): string {
  if (!node || typeof node !== 'object') return '';
  const n = node as Record<string, unknown>;

  // Text node
  if (n.type === 'text') {
    let text = String(n.text ?? '');
    const format = (n.format as number) ?? 0;
    if (format & 1) text = `**${text}**`; // bold
    if (format & 2) text = `*${text}*`; // italic
    if (format & 8) text = `~~${text}~~`; // strikethrough
    if (format & 16) text = `\`${text}\``; // inline code
    return text;
  }

  // Link node
  if (n.type === 'link') {
    const children = ((n.children as unknown[]) ?? [])
      .map((c) => lexicalNodeToMd(c, depth))
      .join('');
    const url = ((n.fields as Record<string, unknown>)?.url as string) ?? '';
    return `[${children}](${url})`;
  }

  // Container nodes
  const children = ((n.children as unknown[]) ?? [])
    .map((c) => lexicalNodeToMd(c, depth))
    .join('');

  switch (n.type) {
    case 'heading': {
      const level = Number(String(n.tag ?? 'h2').replace('h', ''));
      return `${'#'.repeat(level)} ${children}`;
    }
    case 'paragraph':
      return children;
    case 'quote':
      return `> ${children}`;
    case 'list': {
      const items = (n.children as unknown[]) ?? [];
      return items
        .map((item, i) => {
          const text = lexicalNodeToMd(item, depth + 1);
          const prefix = n.listType === 'number' ? `${i + 1}.` : '-';
          return `${prefix} ${text}`;
        })
        .join('\n');
    }
    case 'listitem':
      return children;
    default:
      return children;
  }
}

// --- Block converters ---

function codeBlockToMarkdown(block: Block): string {
  const lang = (block.language as string) ?? '';
  const code = (block.code as string) ?? '';
  const title = block.title ? `**${block.title}**\n\n` : '';
  return `${title}\`\`\`${lang}\n${code}\n\`\`\``;
}

function imageToMarkdown(block: Block): string {
  const url = (block.image_url as string) ?? '';
  const alt = (block.image_alt as string) ?? (block.caption as string) ?? '';
  const caption = block.caption ? `\n*${block.caption}*` : '';
  return url ? `![${alt}](${url})${caption}` : '';
}

function calloutToMarkdown(block: Block): string {
  const type = ((block.type as string) ?? 'info').toUpperCase();
  const text = lexicalToMarkdown(block.content);
  return `> **${type}:** ${text}`;
}

function stepsToMarkdown(block: Block): string {
  const steps = (block.steps as { title?: string; content?: unknown }[]) ?? [];
  return steps
    .map((step, i) => {
      const title = step.title ?? `Step ${i + 1}`;
      const content = step.content ? lexicalToMarkdown(step.content) : '';
      return `**${i + 1}. ${title}**\n${content}`;
    })
    .join('\n\n');
}

function cardGridToMarkdown(block: Block): string {
  const cards =
    (block.cards as { title?: string; description?: string }[]) ?? [];
  return cards
    .map((card) => `- **${card.title ?? ''}** — ${card.description ?? ''}`)
    .join('\n');
}

function tableToMarkdown(block: Block): string {
  const headers = (block.headers as { label?: string }[]) ?? [];
  const rows =
    (block.rows as { cells?: { value?: string }[] }[]) ?? [];

  if (headers.length === 0) return '';

  const headerRow = `| ${headers.map((h) => h.label ?? '').join(' | ')} |`;
  const separator = `| ${headers.map(() => '---').join(' | ')} |`;
  const dataRows = rows
    .map(
      (row) =>
        `| ${(row.cells ?? []).map((c) => c.value ?? '').join(' | ')} |`,
    )
    .join('\n');

  return `${headerRow}\n${separator}\n${dataRows}`;
}

function colorSwatchToMarkdown(block: Block): string {
  const parts = [`**${block.label ?? 'Color'}**`];
  if (block.hex) parts.push(`HEX: ${block.hex}`);
  if (block.rgb) parts.push(`RGB: ${block.rgb}`);
  if (block.cmyk) parts.push(`CMYK: ${block.cmyk}`);
  if (block.pantone) parts.push(`Pantone: ${block.pantone}`);
  if (block.usage) parts.push(`Uso: ${block.usage}`);
  if (block.gradient) parts.push(`Gradiente: ${block.gradient}`);
  return parts.join(' · ');
}

function dosDontsToMarkdown(block: Block): string {
  const dos = (block.dos as { text?: string }[]) ?? [];
  const donts = (block.donts as { text?: string }[]) ?? [];

  const doLines = dos.map((d) => `- ✓ ${d.text ?? ''}`).join('\n');
  const dontLines = donts.map((d) => `- ✗ ${d.text ?? ''}`).join('\n');

  return `**Do:**\n${doLines}\n\n**Don't:**\n${dontLines}`;
}

function downloadToMarkdown(block: Block): string {
  const label = (block.label as string) ?? 'Download';
  const url = (block.url as string) ?? '';
  const desc = block.description ? ` — ${block.description}` : '';
  const type = block.file_type ? ` (${block.file_type})` : '';
  return `📎 [${label}](${url})${type}${desc}`;
}

function contactCardToMarkdown(block: Block): string {
  const parts = [`**${block.name ?? ''}**`];
  if (block.role) parts.push(block.role as string);
  if (block.email) parts.push(block.email as string);
  if (block.note) parts.push(`_${block.note}_`);
  return parts.join(' · ');
}
