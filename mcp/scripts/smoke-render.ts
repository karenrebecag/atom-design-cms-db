/**
 * Puerta de comportamiento: renderiza los cinco templates de `atom_layout_screenshot` con
 * valores mínimos y exige un PNG. El baseline de U0 solo compara nombres de tools, y los
 * nombres siguieron verdes mientras esta tool llevaba meses devolviendo error.
 *
 * Escribe los PNG en `out/` para revisión visual. Sale con 1 si cualquier template falla.
 */
import { mkdirSync, writeFileSync } from 'node:fs';
import { handleScreenshot } from '../src/tools/screenshot.js';
import { TEMPLATE_NAMES } from '../src/template-schemas.js';

const PHOTO = 'https://pub-c8d801a0ff204d758910633021fa302b.r2.dev/ATOM-horizontal-light.svg';

const VALUES: Record<string, Record<string, string>> = {
  'case-study': {
    client_name: 'Mi Dinerito',
    headline: '{{hl}}3x{{/hl}} mas ventas',
    image_url: PHOTO,
  },
  'photo-overlay-dark': { headline: 'Atiende por {{wa}}WhatsApp{{/wa}}', image_url: PHOTO },
  'stat-card': { number: '87%', context: 'de las respuestas', headline: 'Sin esperas' },
  'quote-card': { author_name: 'Ana', author_role: 'CMO', quote: 'Funciona' },
  'stat-card-gradient': { number: '4s', context: 'tiempo de respuesta' },
};

mkdirSync('out', { recursive: true });
let failed = 0;
for (const template of TEMPLATE_NAMES) {
  const res = await handleScreenshot({ template, values: VALUES[template] });
  const img = res.content.find((c) => c.type === 'image') as { data: string } | undefined;
  if (res.isError || !img) {
    failed++;
    const txt = res.content.find((c) => c.type === 'text') as { text: string } | undefined;
    console.error(`FAIL ${template}: ${txt?.text ?? 'sin imagen'}`);
    continue;
  }
  const png = Buffer.from(img.data, 'base64');
  writeFileSync(`out/${template}.png`, png);
  console.log(`ok   ${template} ${Math.round(png.length / 1024)}KB`);
}
process.exit(failed ? 1 : 0);
