import { fetchNavigation, type NavNode } from '../client.js';

export const getNavigationSchema = {
  type: 'object' as const,
  properties: {},
};

function renderTree(nodes: NavNode[], indent = 0): string[] {
  const lines: string[] = [];
  const prefix = '  '.repeat(indent);

  for (const node of nodes) {
    if (node.type === 'folder') {
      lines.push(`${prefix}📁 **${node.name}**`);
      if (node.children) {
        lines.push(...renderTree(node.children, indent + 1));
      }
    } else {
      lines.push(`${prefix}- ${node.name} (\`${node.slug}\`)`);
    }
  }

  return lines;
}

export async function handleGetNavigation() {
  const nav = await fetchNavigation();

  const lines = [
    `# ${nav.siteConfig.site_name}`,
    '',
    nav.siteConfig.site_description ?? '',
    '',
    '## Navigation',
    '',
    ...renderTree(nav.tree),
  ].filter(Boolean);

  return {
    content: [{ type: 'text' as const, text: lines.join('\n') }],
  };
}
