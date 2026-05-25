/**
 * Layout templates for Atom marketing pieces.
 * Each template is complete HTML with {{placeholders}}.
 * Production-quality: matches real Atom social media posts.
 */

export interface LayoutTemplate {
  name: string;
  description: string;
  width: number;
  height: number;
  placeholders: Record<string, { description: string; required: boolean; default?: string }>;
  html: string;
}

const LOGO_DARK =
  'https://cdn.jsdelivr.net/npm/@atomchat.io/mcp-docs@latest/assets/ATOM-horizontal-dark.svg';
const LOGO_LIGHT =
  'https://cdn.jsdelivr.net/npm/@atomchat.io/mcp-docs@latest/assets/ATOM-horizontal-light.svg';

// Shared CSS foundation for all templates
// Preview scaling: body is fixed-size (1080x1350 etc) but html wrapper scales it to fit the viewport
const BASE_CSS = `*{margin:0;padding:0;box-sizing:border-box}
html{background:#e4e4e7}
body{font-family:'Inter',system-ui,-apple-system,sans-serif;-webkit-font-smoothing:antialiased;overflow:hidden;transform-origin:top left;transform:scale(var(--preview-scale,1))}
@media(max-width:1200px){body{--preview-scale:0.5}}
@media(max-width:600px){body{--preview-scale:0.33}}
.hl{color:#FF6600}
.wa{color:#25D366}
b,.bold{font-weight:700}
.tag{display:inline-flex;align-items:center;gap:6px;padding:6px 14px;border-radius:1000px;font-size:12px;font-weight:500;line-height:1}
.tag--brand{background:#FFF4ED;color:#A44200}
.tag--ai{background:linear-gradient(136deg,#EDE9FF,#FDE7F4);color:#8200DA}
.tag--success{background:#ECFEF6;color:#007A56}
.tag--neutral{background:#F4F4F5;color:#3F3F46}
.tag__dot{width:6px;height:6px;border-radius:50%;background:currentColor}
.hashtags{font-size:13px;font-weight:500;color:#8023FF;letter-spacing:0.01em}
.hashtags--light{color:rgba(255,255,255,0.5)}`;

export const TEMPLATES: Record<string, LayoutTemplate> = {
  'case-study': {
    name: 'Case Study',
    description:
      'Client success story. Photo top ~55%, white band bottom with tag pill, client name, punchy metric headline (short, impactful), and dual logo bar. Based on Moto City / Colombo Americano real posts. IMPORTANT: headline should be SHORT and metric-driven (e.g. "triplico sus ventas digitales en WhatsApp con Atom"). Client name goes in client_name field, not in the headline.',
    width: 1080,
    height: 1350,
    placeholders: {
      image_url: { description: 'Client photo URL (from atom_generate_image)', required: true },
      tag_text: {
        description: 'Tag pill text (e.g. "Caso de exito", "Resultados")',
        required: false,
        default: 'Caso de exito',
      },
      tag_intent: {
        description: 'Tag color: "brand", "ai", "success", "neutral"',
        required: false,
        default: 'success',
      },
      client_name: {
        description:
          'Client name displayed prominently above headline (e.g. "Centro Cultural Colombo Americano")',
        required: true,
      },
      headline: {
        description:
          'SHORT metric-driven headline. Use {{hl}}text{{/hl}} for orange metrics, {{wa}}text{{/wa}} for green WhatsApp. Example: "{{hl}}triplico{{/hl}} sus {{hl}}ventas{{/hl}} digitales en {{wa}}WhatsApp{{/wa}} con Atom"',
        required: true,
      },
      client_logo_url: {
        description: 'Client logo URL (SVG or PNG). Omit if unavailable.',
        required: false,
      },
    },
    html: `<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
${BASE_CSS}
body{width:1080px;height:1350px;background:#fff;display:flex;flex-direction:column}
.photo{width:100%;height:55%;object-fit:cover}
.content{flex:1;padding:40px 56px 36px;display:flex;flex-direction:column}
.eyebrow{margin-bottom:16px}
.client-name{font-size:16px;font-weight:600;color:#27272A;margin-bottom:8px;letter-spacing:0.01em}
.headline{font-size:38px;font-weight:800;line-height:1.15;color:#222020;letter-spacing:-0.025em}
.logo-bar{display:flex;align-items:center;gap:16px;margin-top:auto;padding-top:24px}
.logo-bar img{height:28px}
.logo-bar .pipe{width:1.5px;height:22px;background:#D4D4D8;flex-shrink:0}
.logo-bar .client-logo{height:24px}
.logo-bar .client-text{font-size:13px;font-weight:600;color:#52525C}
</style>
</head>
<body>
<img class="photo" src="{{image_url}}" alt="{{client_name}}">
<div class="content">
  <div class="eyebrow"><span class="tag tag--{{tag_intent}}"><span class="tag__dot"></span>{{tag_text}}</span></div>
  <p class="client-name">{{client_name}}</p>
  <h1 class="headline">{{headline}}</h1>
  <div class="logo-bar">
    <img src="${LOGO_LIGHT}" alt="Atom">
    <div class="pipe"></div>
    <img class="client-logo" src="{{client_logo_url}}" alt="{{client_name}}">
  </div>
</div>
</body>
</html>`,
  },

  'photo-overlay-dark': {
    name: 'Photo Overlay Dark',
    description:
      'Fullbleed photo with dark gradient overlay, white headline, optional CTA pill, tag, and hashtags. For product, pain-point, and feature posts.',
    width: 1080,
    height: 1350,
    placeholders: {
      image_url: { description: 'Background photo URL', required: true },
      tag_text: {
        description: 'Tag pill text (e.g. "AI Agents", "WhatsApp Business")',
        required: false,
      },
      tag_intent: {
        description: 'Tag color: "ai", "brand", "success", "neutral"',
        required: false,
        default: 'ai',
      },
      headline: {
        description:
          'Main headline (white). Use {{hl}} for orange, {{wa}} for green, {{b}} for bold.',
        required: true,
      },
      subtitle: { description: 'Subtitle text below headline', required: false },
      cta_text: { description: 'CTA pill text', required: false },
      cta_color: {
        description: '"green" for WhatsApp CTA, "dark" for neutral',
        required: false,
        default: 'dark',
      },
    },
    html: `<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
${BASE_CSS}
body{width:1080px;height:1350px;position:relative;color:#fff}
.bg{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;z-index:0}
.overlay{position:absolute;inset:0;z-index:1;background:linear-gradient(180deg,rgba(24,24,27,0.1) 0%,rgba(24,24,27,0.45) 45%,rgba(24,24,27,0.88) 100%)}
.content{position:relative;z-index:2;height:100%;display:flex;flex-direction:column;justify-content:flex-end;padding:56px 60px}
.eyebrow{margin-bottom:20px}
.headline{font-size:46px;font-weight:700;line-height:1.14;letter-spacing:-0.025em;max-width:20ch}
.subtitle{font-size:20px;font-weight:400;color:rgba(255,255,255,0.75);margin-top:14px;max-width:30ch;line-height:1.5}
.cta{display:inline-flex;align-items:center;gap:8px;margin-top:24px;padding:14px 28px;border-radius:9999px;font-size:16px;font-weight:600;text-decoration:none;width:fit-content}
.cta--dark{background:#18181B;color:#FAFAFA}
.cta--green{background:#25D366;color:#06311A}
.cta__arrow{display:flex;width:18px;height:18px}
.footer{display:flex;align-items:center;justify-content:space-between;margin-top:auto;padding-top:40px}
.footer img{height:28px}
.hashtags--light{color:rgba(255,255,255,0.4)}
</style>
</head>
<body>
<img class="bg" src="{{image_url}}" alt="">
<div class="overlay"></div>
<div class="content">
  <div class="eyebrow"><span class="tag tag--{{tag_intent}}"><span class="tag__dot"></span>{{tag_text}}</span></div>
  <h1 class="headline">{{headline}}</h1>
  <p class="subtitle">{{subtitle}}</p>
  <a class="cta cta--{{cta_color}}" href="#">{{cta_text}} <span class="cta__arrow"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="m12 16 4-4-4-4M8 12h8"/></svg></span></a>
  <div class="footer">
    <img src="${LOGO_DARK}" alt="Atom">
    <span class="hashtags hashtags--light">#AtomChat #AIAgents</span>
  </div>
</div>
</body>
</html>`,
  },

  'event-hero': {
    name: 'Event Hero',
    description:
      'Dramatic fullbleed photo + red/dark gradient overlay + giant centered headline + multi-logo bottom bar. For events and announcements (Spark AI Summit style).',
    width: 1080,
    height: 1350,
    placeholders: {
      image_url: { description: 'Dramatic/aerial photo URL', required: true },
      tag_text: { description: 'Event name tag (e.g. "Spark AI Summit Bogota")', required: false },
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
${BASE_CSS}
body{width:1080px;height:1350px;position:relative;color:#fff}
.bg{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;z-index:0}
.overlay{position:absolute;inset:0;z-index:1;background:linear-gradient(180deg,rgba(180,30,30,0.35) 0%,rgba(24,24,27,0.25) 35%,rgba(24,24,27,0.85) 100%)}
.content{position:relative;z-index:2;height:100%;display:flex;flex-direction:column;padding:48px 56px}
.event-tag{font-size:15px;font-weight:500;color:rgba(255,255,255,0.8);letter-spacing:0.01em}
.headline{margin:auto 0;font-size:68px;font-weight:700;line-height:1.06;letter-spacing:-0.035em;text-align:center;padding:0 20px}
.logo-bar{display:flex;align-items:center;justify-content:space-between}
.logo-bar img{height:34px}
</style>
</head>
<body>
<img class="bg" src="{{image_url}}" alt="">
<div class="overlay"></div>
<div class="content">
  <span class="event-tag">{{tag_text}}</span>
  <h1 class="headline">{{headline}}</h1>
  <div class="logo-bar">
    <img src="${LOGO_DARK}" alt="Atom">
    <img src="{{partner_logo_url}}" alt="Partner">
  </div>
</div>
</body>
</html>`,
  },

  'split-layout': {
    name: 'Split Layout',
    description:
      'Photo left 50% + white panel right with tag, headline, subtitle, CTA button, and logo. For product explainers and pain-point posts (+200 conversaciones style).',
    width: 1080,
    height: 1350,
    placeholders: {
      image_url: { description: 'Photo URL for left side', required: true },
      tag_text: { description: 'Tag pill text', required: false },
      tag_intent: { description: 'Tag color', required: false, default: 'brand' },
      headline: { description: 'Headline. Use {{hl}}, {{wa}}, {{b}}.', required: true },
      subtitle: { description: 'Body text below headline', required: false },
      cta_text: { description: 'CTA button text', required: false },
    },
    html: `<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
${BASE_CSS}
body{width:1080px;height:1350px;display:flex;flex-direction:row}
.photo-side{width:50%;height:100%;object-fit:cover}
.copy-side{width:50%;height:100%;background:#FAFAFA;display:flex;flex-direction:column;padding:56px 44px}
.eyebrow{margin-bottom:20px}
.headline{font-size:32px;font-weight:700;line-height:1.2;color:#222020;letter-spacing:-0.02em}
.subtitle{font-size:17px;font-weight:400;color:#27272A;margin-top:16px;line-height:1.55}
.cta{display:inline-flex;align-items:center;gap:8px;margin-top:28px;padding:14px 24px;border-radius:9999px;font-size:15px;font-weight:600;background:#25D366;color:#06311A;text-decoration:none;width:fit-content}
.footer{margin-top:auto;display:flex;flex-direction:column;gap:12px}
.footer img{height:28px}
</style>
</head>
<body>
<img class="photo-side" src="{{image_url}}" alt="">
<div class="copy-side">
  <div class="eyebrow"><span class="tag tag--{{tag_intent}}"><span class="tag__dot"></span>{{tag_text}}</span></div>
  <h1 class="headline">{{headline}}</h1>
  <p class="subtitle">{{subtitle}}</p>
  <a class="cta" href="#">{{cta_text}}</a>
  <div class="footer">
    <img src="${LOGO_LIGHT}" alt="Atom">
    <span class="hashtags">#AtomChat #WhatsAppBusiness</span>
  </div>
</div>
</body>
</html>`,
  },

  'editorial-light': {
    name: 'Editorial Light',
    description:
      'Clean light background + person photo bottom + decorative gradient swoosh + editorial headline. For thought leadership (equipos comerciales style).',
    width: 1080,
    height: 1350,
    placeholders: {
      image_url: { description: 'Person photo URL', required: true },
      headline: { description: 'Editorial headline. Use {{hl}} for orange.', required: true },
    },
    html: `<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
${BASE_CSS}
body{width:1080px;height:1350px;background:#FAFAFA;position:relative;display:flex;flex-direction:column}
.swoosh{position:absolute;top:60px;left:-60px;width:320px;height:320px;border-radius:50%;background:linear-gradient(135deg,rgba(128,35,255,0.07),rgba(255,102,0,0.05));z-index:0}
.swoosh-line{position:absolute;top:180px;left:30px;width:180px;height:3px;background:linear-gradient(90deg,#8023FF,#FF6600);border-radius:2px;opacity:0.25;transform:rotate(-12deg);z-index:0}
.text-area{position:relative;z-index:1;padding:72px 64px 0}
.headline{font-size:44px;font-weight:700;line-height:1.16;color:#222020;letter-spacing:-0.025em;max-width:16ch}
.photo{flex:1;width:100%;object-fit:cover;object-position:center top;z-index:1}
.logo-footer{position:absolute;bottom:44px;left:0;right:0;text-align:center;z-index:2}
.logo-footer img{height:30px}
</style>
</head>
<body>
<div class="swoosh"></div>
<div class="swoosh-line"></div>
<div class="text-area">
  <h1 class="headline">{{headline}}</h1>
</div>
<img class="photo" src="{{image_url}}" alt="">
<div class="logo-footer"><img src="${LOGO_LIGHT}" alt="Atom"></div>
</body>
</html>`,
  },

  'story-reel': {
    name: 'Story / Reel',
    description:
      'Full-screen 9:16 for Instagram Stories, TikTok, Reels. Photo fullbleed + dark gradient bottom + headline + CTA + logo. Safe zone: center 1080x1420.',
    width: 1080,
    height: 1920,
    placeholders: {
      image_url: { description: 'Full-screen photo URL (portrait)', required: true },
      headline: { description: 'Short headline. Use {{hl}}, {{wa}}.', required: true },
      subtitle: { description: 'Short subtitle', required: false },
      cta_text: { description: 'CTA text (e.g. "Desliza para mas")', required: false },
    },
    html: `<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
${BASE_CSS}
body{width:1080px;height:1920px;position:relative;color:#fff}
.bg{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;z-index:0}
.overlay{position:absolute;inset:0;z-index:1;background:linear-gradient(180deg,transparent 0%,transparent 40%,rgba(24,24,27,0.7) 70%,rgba(24,24,27,0.92) 100%)}
.content{position:relative;z-index:2;height:100%;display:flex;flex-direction:column;justify-content:flex-end;padding:0 56px 260px}
.headline{font-size:52px;font-weight:700;line-height:1.1;letter-spacing:-0.03em}
.subtitle{font-size:20px;color:rgba(255,255,255,0.7);margin-top:12px;line-height:1.4}
.cta{display:inline-flex;align-items:center;gap:8px;margin-top:24px;padding:14px 28px;border-radius:9999px;font-size:16px;font-weight:600;background:#fff;color:#18181B;text-decoration:none;width:fit-content}
.logo-bottom{position:absolute;bottom:80px;left:56px;z-index:2}
.logo-bottom img{height:28px}
</style>
</head>
<body>
<img class="bg" src="{{image_url}}" alt="">
<div class="overlay"></div>
<div class="content">
  <h1 class="headline">{{headline}}</h1>
  <p class="subtitle">{{subtitle}}</p>
  <a class="cta" href="#">{{cta_text}}</a>
</div>
<div class="logo-bottom"><img src="${LOGO_DARK}" alt="Atom"></div>
</body>
</html>`,
  },

  'youtube-thumbnail': {
    name: 'YouTube Thumbnail',
    description:
      'High-contrast 16:9 thumbnail. Photo background + strong overlay + large bold headline. Max readability at small sizes.',
    width: 1280,
    height: 720,
    placeholders: {
      image_url: { description: 'Background photo URL', required: true },
      headline: {
        description: 'Short, punchy headline (max 8 words). Use {{hl}} for orange.',
        required: true,
      },
    },
    html: `<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
${BASE_CSS}
body{width:1280px;height:720px;position:relative;color:#fff}
.bg{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;z-index:0}
.overlay{position:absolute;inset:0;z-index:1;background:linear-gradient(90deg,rgba(24,24,27,0.85) 0%,rgba(24,24,27,0.5) 55%,rgba(24,24,27,0.2) 100%)}
.content{position:relative;z-index:2;height:100%;display:flex;align-items:center;padding:48px 56px}
.headline{font-size:64px;font-weight:900;line-height:1.05;letter-spacing:-0.03em;max-width:12ch;text-shadow:0 2px 20px rgba(0,0,0,0.3)}
.logo-corner{position:absolute;bottom:28px;right:32px;z-index:2}
.logo-corner img{height:24px}
</style>
</head>
<body>
<img class="bg" src="{{image_url}}" alt="">
<div class="overlay"></div>
<div class="content">
  <h1 class="headline">{{headline}}</h1>
</div>
<div class="logo-corner"><img src="${LOGO_DARK}" alt="Atom"></div>
</body>
</html>`,
  },

  'carousel-cover': {
    name: 'Carousel Cover (Slide 1)',
    description:
      'Hook slide for carousels. Dark gradient background + large title + "Swipe" indicator + Atom brand.',
    width: 1080,
    height: 1350,
    placeholders: {
      headline: {
        description: 'Hook headline (bold claim, question, or number + promise)',
        required: true,
      },
      subtitle: { description: 'Short teaser line', required: false },
      bg_style: {
        description: '"gradient" (violet→orange) or "dark" (solid dark)',
        required: false,
        default: 'gradient',
      },
    },
    html: `<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
${BASE_CSS}
body{width:1080px;height:1350px;color:#fff;display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:80px}
body.bg--gradient{background:linear-gradient(160deg,#18181B 0%,#1e1b4b 40%,#312e81 100%)}
body.bg--dark{background:#18181B}
.accent-line{width:60px;height:4px;background:linear-gradient(90deg,#8023FF,#FF6600);border-radius:2px;margin-bottom:32px}
.headline{font-size:60px;font-weight:800;line-height:1.08;letter-spacing:-0.03em;max-width:16ch}
.subtitle{font-size:22px;font-weight:400;color:rgba(255,255,255,0.6);margin-top:20px;max-width:24ch}
.swipe{margin-top:48px;font-size:18px;font-weight:500;color:rgba(255,255,255,0.4);display:flex;align-items:center;gap:8px}
.swipe svg{width:20px;height:20px}
.logo-bottom{position:absolute;bottom:48px;left:0;right:0;text-align:center}
.logo-bottom img{height:28px}
</style>
</head>
<body class="bg--{{bg_style}}">
<div class="accent-line"></div>
<h1 class="headline">{{headline}}</h1>
<p class="subtitle">{{subtitle}}</p>
<div class="swipe">Desliza <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14M12 5l7 7-7 7"/></svg></div>
<div class="logo-bottom"><img src="${LOGO_DARK}" alt="Atom"></div>
</body>
</html>`,
  },

  'carousel-slide': {
    name: 'Carousel Content Slide',
    description:
      'Numbered content slide for carousels. One point per slide with large number + heading + body.',
    width: 1080,
    height: 1350,
    placeholders: {
      number: { description: 'Slide number (e.g. "01", "02")', required: true },
      heading: { description: 'Point heading (one idea)', required: true },
      body: { description: 'Supporting text (max 40 words)', required: true },
      total: { description: 'Total slides for progress indicator', required: false, default: '5' },
    },
    html: `<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
${BASE_CSS}
body{width:1080px;height:1350px;background:#18181B;color:#fff;display:flex;flex-direction:column;justify-content:center;padding:80px}
.progress{font-size:14px;font-weight:500;color:rgba(255,255,255,0.35);margin-bottom:48px}
.number{font-size:110px;font-weight:900;line-height:1;background:linear-gradient(135deg,#8023FF,#FF6600);-webkit-background-clip:text;background-clip:text;-webkit-text-fill-color:transparent}
.heading{font-size:44px;font-weight:700;line-height:1.15;letter-spacing:-0.02em;margin-top:20px}
.body{font-size:22px;font-weight:400;color:rgba(255,255,255,0.7);margin-top:16px;line-height:1.55;max-width:28ch}
.logo-bottom{position:absolute;bottom:48px;right:56px}
.logo-bottom img{height:24px;opacity:0.4}
</style>
</head>
<body>
<span class="progress">{{number}} / {{total}}</span>
<span class="number">{{number}}</span>
<h2 class="heading">{{heading}}</h2>
<p class="body">{{body}}</p>
<div class="logo-bottom"><img src="${LOGO_DARK}" alt="Atom"></div>
</body>
</html>`,
  },

  'carousel-cta': {
    name: 'Carousel CTA (Last Slide)',
    description: 'Final carousel slide with CTA. Save, follow, share prompt + gradient accent.',
    width: 1080,
    height: 1350,
    placeholders: {
      headline: { description: 'CTA headline (e.g. "Te fue util?")', required: true },
      body: { description: 'CTA body (e.g. "Guarda este post para despues")', required: true },
      cta_text: { description: 'Action text', required: false, default: 'Visita atomchat.io' },
    },
    html: `<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
${BASE_CSS}
body{width:1080px;height:1350px;background:#18181B;color:#fff;display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:80px}
.gradient-ring{width:120px;height:120px;border-radius:50%;background:linear-gradient(135deg,#8023FF,#FF6600);display:flex;align-items:center;justify-content:center;margin-bottom:40px}
.gradient-ring__inner{width:108px;height:108px;border-radius:50%;background:#18181B;display:flex;align-items:center;justify-content:center}
.gradient-ring svg{width:40px;height:40px;color:#FF6600}
.headline{font-size:52px;font-weight:800;line-height:1.1;letter-spacing:-0.03em}
.body{font-size:24px;font-weight:400;color:rgba(255,255,255,0.6);margin-top:16px;line-height:1.5;max-width:20ch}
.cta{margin-top:36px;padding:16px 32px;border-radius:9999px;font-size:18px;font-weight:600;background:#fff;color:#18181B;text-decoration:none}
.footer{position:absolute;bottom:48px;left:0;right:0;display:flex;flex-direction:column;align-items:center;gap:12px}
.footer img{height:28px}
</style>
</head>
<body>
<div class="gradient-ring"><div class="gradient-ring__inner"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m19 21-7-4-7 4V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"/></svg></div></div>
<h2 class="headline">{{headline}}</h2>
<p class="body">{{body}}</p>
<a class="cta" href="#">{{cta_text}}</a>
<div class="footer">
  <img src="${LOGO_DARK}" alt="Atom">
  <span class="hashtags hashtags--light">#AtomChat #AIAgents</span>
</div>
</body>
</html>`,
  },
};

export function getTemplate(name: string): LayoutTemplate | undefined {
  return TEMPLATES[name];
}

export function listTemplates(): {
  name: string;
  description: string;
  dimensions: string;
  placeholders: string[];
}[] {
  return Object.entries(TEMPLATES).map(([key, t]) => ({
    name: key,
    description: t.description,
    dimensions: `${t.width}x${t.height}`,
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
