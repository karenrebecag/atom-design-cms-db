import { Server } from '@modelcontextprotocol/sdk/server/index.js';
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
import {
  handleGetImagePrompt,
  getImagePromptSchema,
  handleListImagePrompts,
  listImagePromptsSchema,
} from './tools/get-image-prompt.js';
import { INSTRUCTIONS } from './instructions.js';

export function createServer(): Server {
  const server = new Server(
    { name: '@atomchat.io/mcp-docs', version: '1.0.0' },
    { capabilities: { tools: {} }, instructions: INSTRUCTIONS },
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
          'Get the full content of an ATOM Design Language document by slug. Returns the document converted to readable markdown including text, code blocks, images, color swatches, tables, and more. IMPORTANT: Always call this tool with slug "claude-context" FIRST before any other document — it contains critical override rules for logos (Cloudflare R2 URLs only, never Google Drive), contrast, positioning, and UI components.',
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
      {
        name: 'atom_image_prompt',
        description:
          'Generate a complete image prompt by filling a brand-consistent template with provided values. Use this BEFORE generating any marketing image. Returns a ready-to-use photorealistic prompt with Atom brand constraints baked in.',
        inputSchema: getImagePromptSchema,
      },
      {
        name: 'atom_image_prompt_list',
        description:
          'List all available image prompt templates with their variables, options, and defaults. Use this to discover what templates exist and what values they accept.',
        inputSchema: listImagePromptsSchema,
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
      case 'atom_image_prompt':
        return handleGetImagePrompt(args);
      case 'atom_image_prompt_list':
        return handleListImagePrompts(args);
      default:
        return {
          content: [{ type: 'text', text: `Unknown tool: ${name}` }],
          isError: true,
        };
    }
  });

  return server;
}
