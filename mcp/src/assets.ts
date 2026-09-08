/**
 * Assets de runtime del servidor.
 *
 * WHY aquí y no en un CDN: hasta 2026-05 los logos y este contexto se publicaban a npm
 * (`@atomchat.io/mcp-docs`) y se leían de vuelta por jsDelivr. El paquete se despublicó y
 * el servidor se quedó sirviendo 404 en silencio: `atom_layout_screenshot` dejó de renderizar
 * y `atom_docs_list` anexaba un bloque vacío. Nada de Atom se distribuye por npm.
 *
 * Los logos viven en R2, que es la única fuente que el doc `claude-context` del CMS autoriza.
 * Los SVG de `assets/` son copias de referencia idénticas byte a byte a los de R2.
 */

const R2_BASE = 'https://pub-c8d801a0ff204d758910633021fa302b.r2.dev';

/** Logo blanco, para fondos oscuros. */
export const LOGO_DARK_URL = `${R2_BASE}/ATOM-horizontal-dark.svg`;
/** Logo oscuro, para fondos claros. */
export const LOGO_LIGHT_URL = `${R2_BASE}/ATOM-horizontal-light.svg`;

/** Antes `assets/brand-context.md`. Se anexa a `atom_docs_list` y `atom_docs_get`. */
export const BRAND_CONTEXT = `## CRITICAL BRAND CONTEXT (always apply)

### Logo — ONLY authorized source
- Dark bg (white logo): ${LOGO_DARK_URL}
- Light bg (dark logo): ${LOGO_LIGHT_URL}
- Position: ONLY top-left or bottom-right corner
- NEVER use Google Drive, Logo Pack, or brand-admin.atomchat.io/api/media
- NEVER reconstruct the logo typographically
- Min size: 32px digital. Clear zone: symbol height on all 4 sides

### Contrast (mandatory)
- Dark bg #18181B → foregrounds MUST be light (white, orange, /50 colors)
- NEVER use Violet #8023FF as foreground on dark — fails WCAG AA
- Light bg → foregrounds must be dark (#222020 titles, #27272A body)
- NEVER use pure black #000000. Verify contrast >= 4.5:1 (WCAG AA)

### Colors
- Orange #FF6600: accent ONLY (highlights, word "Atom"). NEVER on large bg or CTA buttons
- Violet #8023FF: AI/tech support color
- Gradient #8023FF → #FF6600: hero element
- Text: #222020 (headings), #27272A (body)
- Backgrounds: #18181B (dark), #FAFAFA (light)
- Tinted: Orange/50 #FFF4ED | Green/50 #F1FDF4 | Violet/50 #F5F3FF | Blue/50 #EFF6FF | Rose/50 #FFF2F2

### Typography
- Inter is the ONLY authorized font. Weights: 400, 500, 600, 700
- H1 Bold 700 | H2 SemiBold 600 | H3 Medium 500 | Body Regular 400
- "Atom" always capitalized (not ATOM in text). Product name: "Atomchat" (one word)
- Highlights: max 2 colors per title, max 3 highlighted words. "Atom" always orange, "WhatsApp" always #25D366

### Hashtags (mandatory)
- #AtomChat on EVERY post
- #AIAgents for product/educational content
- #WhatsAppBusiness for WA-related content
- Limits: X 1-3, Facebook 2-3, LinkedIn 3-5, Instagram 5-10

### Tags/Pills (atom-tag component)
- Variants: Filled, Ghost, Outlined
- Sizes: xs (8px), s (10px), m (12px). border-radius: 1000px. Inter Medium 500
- Success: bg #ECFEF6 text #007A56 | Warning: bg #FEFCE8 text #A76000
- Danger: bg #FEF3F3 text #C10008 | Info: bg #EFF6FF text #1447E6
- Neutral: bg #F4F4F5 text #3F3F46 | Brand: bg #FFF4ED text #A44200
- AI: bg gradient(136deg, #EDE9FF, #FDE7F4) text #8200DA
- Disabled: bg #F4F4F5 text #A1A1AA
`;
