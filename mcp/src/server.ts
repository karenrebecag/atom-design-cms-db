import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import { handleListDocs, listDocsSchema } from './tools/list-docs.js';
import { handleGetDoc, getDocSchema } from './tools/get-doc.js';
import { handleSearchDocs, searchDocsSchema } from './tools/search-docs.js';
import {
  handleGetNavigation,
  getNavigationSchema,
} from './tools/get-navigation.js';

export function createServer() {
  const server = new Server(
    { name: '@atomchat.io/mcp-docs', version: '1.0.0' },
    { capabilities: { tools: {} } },
  );

  server.setRequestHandler(ListToolsRequestSchema, async () => ({
    tools: [
      {
        name: 'atom_docs_list',
        description:
          'List all published ATOM Design Language documents. Optionally filter by category slug. Returns title, slug, category, and description.',
        inputSchema: listDocsSchema,
      },
      {
        name: 'atom_docs_get',
        description:
          'Get the full content of an ATOM Design Language document by slug. Returns the document converted to readable markdown including text, code blocks, images, color swatches, tables, and more.',
        inputSchema: getDocSchema,
      },
      {
        name: 'atom_docs_search',
        description:
          'Search ATOM Design Language documents by keyword. Searches across titles, slugs, and descriptions. Returns ranked results.',
        inputSchema: searchDocsSchema,
      },
      {
        name: 'atom_docs_navigation',
        description:
          'Get the full navigation tree of the ATOM Design Language documentation site. Shows all categories and documents organized hierarchically.',
        inputSchema: getNavigationSchema,
      },
    ],
  }));

  server.setRequestHandler(CallToolRequestSchema, async (request) => {
    const { name, arguments: args } = request.params;

    switch (name) {
      case 'atom_docs_list':
        return handleListDocs(args);
      case 'atom_docs_get':
        return handleGetDoc(args);
      case 'atom_docs_search':
        return handleSearchDocs(args);
      case 'atom_docs_navigation':
        return handleGetNavigation();
      default:
        return {
          content: [{ type: 'text', text: `Unknown tool: ${name}` }],
          isError: true,
        };
    }
  });

  return {
    async start() {
      const transport = new StdioServerTransport();
      await server.connect(transport);
    },
  };
}
