#!/usr/bin/env node
/**
 * @atomchat.io/mcp-docs — stdio transport (Claude Code / Claude Desktop)
 */

import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { createServer } from './server.js';

const server = createServer();
const transport = new StdioServerTransport();
await server.connect(transport);
