import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { CallToolRequestSchema, ListToolsRequestSchema } from '@modelcontextprotocol/sdk/types.js';
import { handleListDocs, listDocsSchema } from './tools/list-docs.js';
import { handleGetDoc, getDocSchema } from './tools/get-doc.js';
import { handleSearchDocs, searchDocsSchema } from './tools/search-docs.js';
import { handleGetNavigation, getNavigationSchema } from './tools/get-navigation.js';
import {
  handleGetImagePrompt,
  getImagePromptSchema,
  handleListImagePrompts,
  listImagePromptsSchema,
} from './tools/get-image-prompt.js';
import { handleGenerateImage, generateImageSchema } from './tools/generate-image.js';
import { handleLayout, layoutSchema, handleLayoutList, layoutListSchema } from './tools/layout.js';
import { handleScreenshot, screenshotSchema } from './tools/screenshot.js';
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
      {
        name: 'atom_generate_image',
        description:
          'Generate a photorealistic image using Flux AI. Pass the prompt from atom_image_prompt. Returns an image URL to use as background-image in HTML/CSS. The image contains NO text and NO logos — those are added in the HTML layer.',
        inputSchema: generateImageSchema,
      },
      {
        name: 'atom_layout',
        description:
          'Render a brand-consistent HTML layout from a template. Returns complete HTML artifact (1080x1350, 4:5). Use after generating an image with atom_generate_image. Templates: case-study, photo-overlay-dark, event-hero, split-layout, editorial-light.',
        inputSchema: layoutSchema,
      },
      {
        name: 'atom_layout_screenshot',
        description:
          'Render a layout template directly to a PNG image. Returns the image inline — no HTML, no browser needed. Use this instead of atom_layout when the user needs a final image (social media post, banner). Flow: atom_generate_image (photo) → atom_layout_screenshot (template + photo → PNG).',
        inputSchema: screenshotSchema,
      },
      {
        name: 'atom_layout_list',
        description:
          'List all available layout templates with their placeholders and descriptions. Call this to see what templates exist before using atom_layout.',
        inputSchema: layoutListSchema,
      },
    ],
  }));

  server.setRequestHandler(CallToolRequestSchema, async (request) => {
    const { name, arguments: args } = request.params;

    try {
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
        case 'atom_generate_image':
          return handleGenerateImage(args);
        case 'atom_layout':
          return handleLayout(args);
        case 'atom_layout_screenshot':
          return handleScreenshot(args);
        case 'atom_layout_list':
          return handleLayoutList(args);
        default:
          return {
            content: [{ type: 'text', text: `Unknown tool: ${name}` }],
            isError: true,
          };
      }
    } catch (err: unknown) {
      const message = err instanceof Error ? err.message : String(err);
      return {
        content: [{ type: 'text', text: `Tool "${name}" failed: ${message}` }],
        isError: true,
      };
    }
  });

  return server;
}
