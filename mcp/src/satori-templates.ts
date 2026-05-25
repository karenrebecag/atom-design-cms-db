/**
 * Satori-compatible templates for PNG rendering.
 * Every node with children array MUST have display: 'flex'.
 */

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type SatoriNode = any;

const COLORS = {
  orange: '#FF6600',
  whatsapp: '#25D366',
  heading: '#222020',
  body: '#27272A',
  muted: '#52525C',
  dark: '#18181B',
  white: '#FFFFFF',
  successBg: '#ECFEF6',
  successFg: '#007A56',
  brandBg: '#FFF4ED',
  brandFg: '#A44200',
};

export interface SatoriTemplateInput {
  [key: string]: string | undefined;
}

export interface TemplateAssets {
  logoLight: string;
  logoDark: string;
  photo?: string;
}

export interface SatoriTemplate {
  name: string;
  width: number;
  height: number;
  build: (values: SatoriTemplateInput, assets: TemplateAssets) => SatoriNode;
}

// Process {{hl}}text{{/hl}} and {{wa}}text{{/wa}} markers
function hl(text: string): SatoriNode {
  const regex = /\{\{(hl|wa)\}\}(.*?)\{\{\/\1\}\}/g;
  const parts: SatoriNode[] = [];
  let last = 0;
  let m;

  while ((m = regex.exec(text)) !== null) {
    if (m.index > last) parts.push(text.slice(last, m.index));
    parts.push({
      type: 'span',
      props: {
        style: { color: m[1] === 'hl' ? COLORS.orange : COLORS.whatsapp },
        children: m[2],
      },
    });
    last = m.index + m[0].length;
  }
  if (last < text.length) parts.push(text.slice(last));
  if (parts.length === 1) return parts[0];
  return {
    type: 'div',
    props: { style: { display: 'flex', flexWrap: 'wrap' }, children: parts },
  };
}

function pill(text: string, intent: string) {
  const bg = intent === 'success' ? COLORS.successBg : COLORS.brandBg;
  const fg = intent === 'success' ? COLORS.successFg : COLORS.brandFg;
  return {
    type: 'div',
    props: {
      style: {
        display: 'flex',
        alignItems: 'center',
        gap: 6,
        padding: '6px 14px',
        borderRadius: 1000,
        fontSize: 12,
        fontWeight: 500,
        backgroundColor: bg,
        color: fg,
      },
      children: [
        {
          type: 'div',
          props: {
            style: { width: 6, height: 6, borderRadius: '50%', backgroundColor: fg },
          },
        },
        text,
      ],
    },
  };
}

export const SATORI_TEMPLATES: Record<string, SatoriTemplate> = {
  'case-study': {
    name: 'Case Study',
    width: 1080,
    height: 1350,
    build: (v, a) => ({
      type: 'div',
      props: {
        style: {
          display: 'flex',
          flexDirection: 'column',
          width: 1080,
          height: 1350,
          backgroundColor: COLORS.white,
          fontFamily: 'Inter',
        },
        children: [
          // Photo
          a.photo
            ? {
                type: 'img',
                props: {
                  src: a.photo,
                  width: 1080,
                  height: 742,
                  style: { objectFit: 'cover' },
                },
              }
            : {
                type: 'div',
                props: {
                  style: {
                    display: 'flex',
                    width: 1080,
                    height: 742,
                    backgroundColor: '#E4E4E7',
                    alignItems: 'center',
                    justifyContent: 'center',
                    color: COLORS.muted,
                    fontSize: 24,
                  },
                  children: 'No image',
                },
              },
          // Content
          {
            type: 'div',
            props: {
              style: {
                display: 'flex',
                flexDirection: 'column',
                padding: '40px 56px 36px',
                flex: 1,
              },
              children: [
                // Tag pill
                pill(v.tag_text || 'Caso de exito', v.tag_intent || 'success'),
                // Client name
                {
                  type: 'div',
                  props: {
                    style: {
                      display: 'flex',
                      fontSize: 16,
                      fontWeight: 600,
                      color: COLORS.body,
                      marginTop: 16,
                      marginBottom: 8,
                    },
                    children: v.client_name || '',
                  },
                },
                // Headline
                {
                  type: 'div',
                  props: {
                    style: {
                      display: 'flex',
                      flexWrap: 'wrap',
                      fontSize: 38,
                      fontWeight: 800,
                      lineHeight: 1.15,
                      color: COLORS.heading,
                      letterSpacing: '-0.025em',
                    },
                    children: hl(v.headline || ''),
                  },
                },
                // Logo bar
                {
                  type: 'div',
                  props: {
                    style: {
                      display: 'flex',
                      alignItems: 'center',
                      gap: 16,
                      marginTop: 'auto',
                      paddingTop: 24,
                    },
                    children: [
                      { type: 'img', props: { src: a.logoLight, height: 28 } },
                      {
                        type: 'div',
                        props: {
                          style: { width: 1.5, height: 22, backgroundColor: '#D4D4D8' },
                        },
                      },
                      {
                        type: 'div',
                        props: {
                          style: {
                            display: 'flex',
                            fontSize: 13,
                            fontWeight: 600,
                            color: COLORS.muted,
                          },
                          children: v.client_name || '',
                        },
                      },
                    ],
                  },
                },
              ],
            },
          },
        ],
      },
    }),
  },

  'photo-overlay-dark': {
    name: 'Photo Overlay Dark',
    width: 1080,
    height: 1350,
    build: (v, a) => ({
      type: 'div',
      props: {
        style: {
          display: 'flex',
          flexDirection: 'column',
          justifyContent: 'flex-end',
          width: 1080,
          height: 1350,
          padding: '56px 60px',
          fontFamily: 'Inter',
          color: COLORS.white,
          backgroundColor: COLORS.dark,
          backgroundImage: a.photo ? `url(${a.photo})` : undefined,
          backgroundSize: 'cover',
          backgroundPosition: 'center',
        },
        children: [
          // Tag
          v.tag_text ? pill(v.tag_text, v.tag_intent || 'brand') : null,
          // Headline
          {
            type: 'div',
            props: {
              style: {
                display: 'flex',
                flexWrap: 'wrap',
                fontSize: 46,
                fontWeight: 700,
                lineHeight: 1.14,
                letterSpacing: '-0.025em',
                marginTop: 20,
              },
              children: hl(v.headline || ''),
            },
          },
          // Subtitle
          v.subtitle
            ? {
                type: 'div',
                props: {
                  style: {
                    display: 'flex',
                    fontSize: 20,
                    color: 'rgba(255,255,255,0.75)',
                    marginTop: 14,
                    lineHeight: 1.5,
                  },
                  children: v.subtitle,
                },
              }
            : null,
          // Footer
          {
            type: 'div',
            props: {
              style: {
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                marginTop: 40,
              },
              children: [
                { type: 'img', props: { src: a.logoDark, height: 28 } },
                {
                  type: 'div',
                  props: {
                    style: {
                      display: 'flex',
                      fontSize: 13,
                      fontWeight: 500,
                      color: 'rgba(255,255,255,0.4)',
                    },
                    children: '#AtomChat #AIAgents',
                  },
                },
              ],
            },
          },
        ].filter(Boolean),
      },
    }),
  },
};

export function getSatoriTemplate(name: string): SatoriTemplate | undefined {
  return SATORI_TEMPLATES[name];
}
