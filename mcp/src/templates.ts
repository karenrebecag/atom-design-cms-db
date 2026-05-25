/**
 * Layout templates for Atom marketing pieces.
 * Each template is a complete HTML string with {{placeholders}}.
 * The AI fills in content — never builds layout from scratch.
 */

export interface LayoutTemplate {
  name: string;
  description: string;
  placeholders: Record<string, { description: string; required: boolean; default?: string }>;
  html: string;
}

const ATOM_LOGO_DARK =
  'https://cdn.jsdelivr.net/npm/@atomchat.io/mcp-docs@latest/assets/ATOM-horizontal-dark.svg';
const ATOM_LOGO_LIGHT =
  'https://cdn.jsdelivr.net/npm/@atomchat.io/mcp-docs@latest/assets/ATOM-horizontal-light.svg';

export const TEMPLATES: Record<string, LayoutTemplate> = {
  'case-study': {
    name: 'Case Study',
    description:
      'Client success story. Photo top 60%, white band bottom with metrics headline + dual logo bar. 1080x1350 (4:5).',
    placeholders: {
      image_url: { description: 'Client photo URL (from atom_generate_image)', required: true },
      headline: {
        description: 'Result headline. Use {{hl}} for orange highlight, {{wa}} for green WhatsApp.',
        required: true,
      },
      client_logo_url: { description: 'Client logo URL (SVG or PNG)', required: false },
      client_name: { description: 'Client name for alt text', required: false, default: 'Cliente' },
    },
    html: `<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:'Inter',system-ui,sans-serif;width:1080px;height:1350px;overflow:hidden;background:#fff}
.photo{width:100%;height:60%;object-fit:cover}
.content{padding:48px 64px;display:flex;flex-direction:column;justify-content:center;height:40%}
.headline{font-size:42px;font-weight:700;line-height:1.15;color:#222020;letter-spacing:-0.02em}
.headline .hl{color:#FF6600}
.headline .wa{color:#25D366}
.logo-bar{display:flex;align-items:center;gap:20px;margin-top:auto;padding-top:32px}
.logo-bar img{height:32px}
.logo-bar .pipe{width:1.5px;height:28px;background:#D4D4D8}
</style>
</head>
<body>
<img class="photo" src="{{image_url}}" alt="{{client_name}}">
<div class="content">
  <h1 class="headline">{{headline}}</h1>
  <div class="logo-bar">
    <img src="${ATOM_LOGO_LIGHT}" alt="Atom">
    <div class="pipe"></div>
    <img src="{{client_logo_url}}" alt="{{client_name}}">
  </div>
</div>
</body>
</html>`,
  },

  'photo-overlay-dark': {
    name: 'Photo Overlay Dark',
    description:
      'Fullbleed photo with dark gradient overlay + white text. For product, pain-point, and feature posts. 1080x1350 (4:5).',
    placeholders: {
      image_url: { description: 'Background photo URL (from atom_generate_image)', required: true },
      headline: {
        description: 'Main headline (white). Use {{b}} for bold emphasis.',
        required: true,
      },
      subtitle: {
        description: 'Optional subtitle below headline',
        required: false,
      },
      cta_text: { description: 'Optional CTA pill text', required: false },
      cta_color: {
        description: 'CTA pill color: "orange" or "green"',
        required: false,
        default: 'orange',
      },
    },
    html: `<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:'Inter',system-ui,sans-serif;width:1080px;height:1350px;overflow:hidden;position:relative;color:#fff}
.bg{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;z-index:0}
.overlay{position:absolute;inset:0;z-index:1;background:linear-gradient(180deg,rgba(24,24,27,0.15) 0%,rgba(24,24,27,0.5) 50%,rgba(24,24,27,0.88) 100%)}
.content{position:relative;z-index:2;height:100%;display:flex;flex-direction:column;justify-content:flex-end;padding:64px}
.headline{font-size:48px;font-weight:700;line-height:1.15;letter-spacing:-0.02em;max-width:22ch}
.headline .hl{color:#FF6600}
.headline .wa{color:#25D366}
.headline b{font-weight:700}
.subtitle{font-size:22px;font-weight:400;color:rgba(255,255,255,0.8);margin-top:16px;max-width:32ch}
.cta{display:inline-flex;align-items:center;gap:8px;margin-top:28px;padding:14px 28px;border-radius:9999px;font-size:18px;font-weight:600;text-decoration:none;color:#fff;width:fit-content}
.cta--orange{background:#FF6600}
.cta--green{background:#25D366;color:#06311A}
.cta__arrow{width:20px;height:20px}
.logo{margin-top:auto;padding-top:48px}
.logo img{height:32px}
</style>
</head>
<body>
<img class="bg" src="{{image_url}}" alt="">
<div class="overlay"></div>
<div class="content">
  <h1 class="headline">{{headline}}</h1>
  <p class="subtitle">{{subtitle}}</p>
  <a class="cta cta--{{cta_color}}" href="#">{{cta_text}} <svg class="cta__arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="m12 16 4-4-4-4M8 12h8"/></svg></a>
  <div class="logo"><img src="${ATOM_LOGO_DARK}" alt="Atom"></div>
</div>
</body>
</html>`,
  },

  'event-hero': {
    name: 'Event Hero',
    description:
      'Dramatic fullbleed photo + giant centered headline + gradient overlay + multi-logo bottom. For events and announcements. 1080x1350 (4:5).',
    placeholders: {
      image_url: { description: 'Dramatic/aerial photo URL', required: true },
      tag_text: { description: 'Top tag (e.g. "Spark AI Summit Bogota")', required: false },
      headline: {
        description: 'Giant centered headline. Use {{hl}} for orange, {{wa}} for green.',
        required: true,
      },
      partner_logo_url: { description: 'Partner logo URL for bottom-right', required: false },
    },
    html: `<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:'Inter',system-ui,sans-serif;width:1080px;height:1350px;overflow:hidden;position:relative;color:#fff}
.bg{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;z-index:0}
.overlay{position:absolute;inset:0;z-index:1;background:linear-gradient(180deg,rgba(180,30,30,0.4) 0%,rgba(24,24,27,0.3) 40%,rgba(24,24,27,0.85) 100%)}
.content{position:relative;z-index:2;height:100%;display:flex;flex-direction:column;padding:48px 64px}
.tag{font-size:16px;font-weight:500;color:rgba(255,255,255,0.85)}
.headline{margin:auto 0;font-size:72px;font-weight:700;line-height:1.08;letter-spacing:-0.03em;text-align:center;padding:0 24px}
.headline .hl{color:#FF6600}
.headline .wa{color:#25D366}
.logo-bar{display:flex;align-items:center;justify-content:space-between;padding-top:24px}
.logo-bar img{height:36px}
</style>
</head>
<body>
<img class="bg" src="{{image_url}}" alt="">
<div class="overlay"></div>
<div class="content">
  <span class="tag">{{tag_text}}</span>
  <h1 class="headline">{{headline}}</h1>
  <div class="logo-bar">
    <img src="${ATOM_LOGO_DARK}" alt="Atom">
    <img src="{{partner_logo_url}}" alt="Partner">
  </div>
</div>
</body>
</html>`,
  },

  'split-layout': {
    name: 'Split Layout',
    description:
      'Photo left + white panel right with copy and CTA. For product explainers and pain-point posts. 1080x1350 (4:5).',
    placeholders: {
      image_url: { description: 'Photo URL for left side', required: true },
      headline: {
        description:
          'Headline on right panel. Use {{hl}} for orange, {{wa}} for green, {{b}} for bold.',
        required: true,
      },
      subtitle: {
        description: 'Body text below headline',
        required: false,
      },
      cta_text: { description: 'CTA button text', required: false },
    },
    html: `<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:'Inter',system-ui,sans-serif;width:1080px;height:1350px;overflow:hidden;display:flex;flex-direction:row}
.photo-side{width:50%;height:100%;object-fit:cover}
.copy-side{width:50%;height:100%;background:#FAFAFA;display:flex;flex-direction:column;justify-content:center;padding:48px 40px}
.headline{font-size:34px;font-weight:700;line-height:1.2;color:#222020;letter-spacing:-0.02em}
.headline .hl{color:#FF6600}
.headline .wa{color:#25D366}
.headline b{font-weight:700}
.subtitle{font-size:18px;font-weight:400;color:#27272A;margin-top:16px;line-height:1.5}
.cta{display:inline-flex;align-items:center;gap:8px;margin-top:28px;padding:14px 24px;border-radius:9999px;font-size:16px;font-weight:600;background:#25D366;color:#06311A;text-decoration:none;width:fit-content}
.logo{margin-top:auto}
.logo img{height:32px}
</style>
</head>
<body>
<img class="photo-side" src="{{image_url}}" alt="">
<div class="copy-side">
  <h1 class="headline">{{headline}}</h1>
  <p class="subtitle">{{subtitle}}</p>
  <a class="cta" href="#">{{cta_text}}</a>
  <div class="logo"><img src="${ATOM_LOGO_LIGHT}" alt="Atom"></div>
</div>
</body>
</html>`,
  },

  'editorial-light': {
    name: 'Editorial Light',
    description:
      'Clean light background + person photo to one side + decorative swoosh. For thought leadership and editorial content. 1080x1350 (4:5).',
    placeholders: {
      image_url: { description: 'Person photo URL', required: true },
      headline: {
        description: 'Editorial headline. Use {{hl}} for orange highlight.',
        required: true,
      },
      image_position: {
        description: '"left" or "right"',
        required: false,
        default: 'right',
      },
    },
    html: `<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:'Inter',system-ui,sans-serif;width:1080px;height:1350px;overflow:hidden;background:#FAFAFA;position:relative}
.swoosh{position:absolute;top:80px;left:-40px;width:280px;height:280px;border-radius:50%;background:linear-gradient(135deg,rgba(128,35,255,0.08),rgba(255,102,0,0.06));z-index:0}
.swoosh-line{position:absolute;top:160px;left:20px;width:200px;height:3px;background:linear-gradient(90deg,#8023FF,#FF6600);border-radius:2px;opacity:0.3;transform:rotate(-12deg);z-index:0}
.content{position:relative;z-index:1;height:100%;display:flex;flex-direction:column}
.text-area{padding:80px 64px 40px;flex:none}
.headline{font-size:44px;font-weight:700;line-height:1.18;color:#222020;letter-spacing:-0.02em;max-width:16ch}
.headline .hl{color:#FF6600}
.photo{flex:1;width:100%;object-fit:cover;object-position:center top}
.photo--right{object-position:right center}
.logo{position:absolute;bottom:48px;left:0;right:0;text-align:center;z-index:2}
.logo img{height:32px}
</style>
</head>
<body>
<div class="swoosh"></div>
<div class="swoosh-line"></div>
<div class="content">
  <div class="text-area">
    <h1 class="headline">{{headline}}</h1>
  </div>
  <img class="photo photo--{{image_position}}" src="{{image_url}}" alt="">
</div>
<div class="logo"><img src="${ATOM_LOGO_LIGHT}" alt="Atom"></div>
</body>
</html>`,
  },
};

export function getTemplate(name: string): LayoutTemplate | undefined {
  return TEMPLATES[name];
}

export function listTemplates(): { name: string; description: string; placeholders: string[] }[] {
  return Object.entries(TEMPLATES).map(([key, t]) => ({
    name: key,
    description: t.description,
    placeholders: Object.keys(t.placeholders),
  }));
}

export function renderTemplate(name: string, values: Record<string, string>): string | null {
  const template = TEMPLATES[name];
  if (!template) return null;

  let html = template.html;

  for (const [key, meta] of Object.entries(template.placeholders)) {
    const value = values[key] ?? meta.default ?? '';
    html = html.replaceAll(`{{${key}}}`, value);
  }

  // Process highlight markers
  html = html.replace(/\{\{hl\}\}(.*?)\{\{\/hl\}\}/g, '<span class="hl">$1</span>');
  html = html.replace(/\{\{wa\}\}(.*?)\{\{\/wa\}\}/g, '<span class="wa">$1</span>');
  html = html.replace(/\{\{b\}\}(.*?)\{\{\/b\}\}/g, '<b>$1</b>');

  return html;
}
