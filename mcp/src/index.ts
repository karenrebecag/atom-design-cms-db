#!/usr/bin/env node
/**
 * @atomchat.io/mcp-docs — MCP Server for ATOM Design Language Documentation
 *
 * Provides AI with context about brand guidelines, visual language,
 * color palettes, typography, and editorial content from the ATOM CMS.
 *
 * Usage:
 *   SUPABASE_URL=... SUPABASE_ANON_KEY=... npx tsx src/index.ts
 */

import { createServer } from './server.js';

const server = createServer();
await server.start();
