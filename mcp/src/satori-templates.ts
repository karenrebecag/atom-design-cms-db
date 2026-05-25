/**
 * Satori-compatible templates for PNG rendering.
 * Every node with children array MUST have display: 'flex'.
 * Colors/spacing sourced from @atom-uikit/tokens — never hardcoded.
 */
import * as tokens from '@atom-uikit/tokens';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type SatoriNode = any;

// All colors from the DS token package — zero hardcoded values
const COLORS = {
  orange: tokens.brand,
  violet: tokens.colorViolet600,
  whatsapp: '#25D366', // WhatsApp brand, not in DS tokens
  heading: tokens.foreground,
  body: tokens.foreground,
  muted: tokens.mutedForeground,
  dark: tokens.primary,
  white: tokens.background,
  border: tokens.border,
  successBg: tokens.colorEmerald50 ?? '#ECFEF6',
  successFg: tokens.success,
  brandBg: tokens.colorOrange50 ?? '#FFF4ED',
  brandFg: tokens.brandForeground ?? '#A44200',
  primaryFg: tokens.primaryForeground,
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
                justifyContent: 'space-between',
                padding: '40px 48px 48px',
                flex: 1,
              },
              children: [
                // Top block: tag + client + kicker + headline + subheadline
                {
                  type: 'div',
                  props: {
                    style: { display: 'flex', flexDirection: 'column' },
                    children: [
                      // Tag pill
                      pill(v.tag_text || 'Caso de exito', v.tag_intent || 'success'),
                      // Client name
                      {
                        type: 'div',
                        props: {
                          style: {
                            display: 'flex',
                            fontSize: 22,
                            fontWeight: 600,
                            color: COLORS.body,
                            marginTop: 14,
                          },
                          children: v.client_name || '',
                        },
                      },
                      // Kicker (optional — the "how" in one line)
                      v.kicker
                        ? {
                            type: 'div',
                            props: {
                              style: {
                                display: 'flex',
                                fontSize: 16,
                                fontWeight: 500,
                                color: COLORS.muted,
                                marginTop: 4,
                                letterSpacing: '0.08em',
                                textTransform: 'uppercase' as const,
                              },
                              children: v.kicker,
                            },
                          }
                        : null,
                      // Headline
                      {
                        type: 'div',
                        props: {
                          style: {
                            display: 'flex',
                            flexWrap: 'wrap',
                            fontSize: 72,
                            fontWeight: 700,
                            lineHeight: 1.1,
                            color: COLORS.heading,
                            letterSpacing: '-0.03em',
                            marginTop: 16,
                          },
                          children: hl(v.headline || ''),
                        },
                      },
                      // Subheadline (optional — the proof/context)
                      v.subheadline
                        ? {
                            type: 'div',
                            props: {
                              style: {
                                display: 'flex',
                                fontSize: 28,
                                fontWeight: 400,
                                color: COLORS.muted,
                                marginTop: 16,
                                lineHeight: 1.5,
                              },
                              children: v.subheadline,
                            },
                          }
                        : null,
                    ].filter(Boolean),
                  },
                },
                // Logo bar (pushed to bottom by space-between)
                {
                  type: 'div',
                  props: {
                    style: {
                      display: 'flex',
                      alignItems: 'center',
                      gap: 16,
                    },
                    children: [
                      { type: 'img', props: { src: a.logoLight, height: 32 } },
                      {
                        type: 'div',
                        props: {
                          style: { width: 1.5, height: 26, backgroundColor: COLORS.border },
                        },
                      },
                      {
                        type: 'div',
                        props: {
                          style: {
                            display: 'flex',
                            fontSize: 18,
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
          position: 'relative',
          width: 1080,
          height: 1350,
          fontFamily: 'Inter',
          color: COLORS.white,
          backgroundColor: COLORS.dark,
        },
        children: [
          // Background photo (absolute)
          a.photo
            ? {
                type: 'img',
                props: {
                  src: a.photo,
                  width: 1080,
                  height: 1350,
                  style: { position: 'absolute', top: 0, left: 0, objectFit: 'cover' },
                },
              }
            : null,
          // Dark overlay (absolute)
          {
            type: 'div',
            props: {
              style: {
                position: 'absolute',
                top: 0,
                left: 0,
                width: 1080,
                height: 1350,
                background:
                  'linear-gradient(to bottom, rgba(0,0,0,0.15) 0%, rgba(0,0,0,0.5) 50%, rgba(0,0,0,0.88) 100%)',
              },
            },
          },
          // Content (relative, on top)
          {
            type: 'div',
            props: {
              style: {
                position: 'relative',
                display: 'flex',
                flexDirection: 'column',
                justifyContent: 'flex-end',
                width: 1080,
                height: 1350,
                padding: '56px 60px',
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
          },
        ].filter(Boolean),
      },
    }),
  },
  'stat-card': {
    name: 'Stat Card',
    width: 1080,
    height: 1080,
    build: (v, a) => ({
      type: 'div',
      props: {
        style: {
          display: 'flex',
          flexDirection: 'column',
          justifyContent: 'center',
          alignItems: 'center',
          width: 1080,
          height: 1080,
          backgroundColor: v.bg === 'light' ? COLORS.white : COLORS.dark,
          fontFamily: 'Inter',
          padding: '80px',
          textAlign: 'center',
        },
        children: [
          // Big number
          {
            type: 'div',
            props: {
              style: {
                display: 'flex',
                fontSize: 96,
                fontWeight: 800,
                color: COLORS.orange,
                lineHeight: 1,
                letterSpacing: '-0.04em',
              },
              children: v.number || '3x',
            },
          },
          // Context line
          {
            type: 'div',
            props: {
              style: {
                display: 'flex',
                fontSize: 24,
                fontWeight: 500,
                color: v.bg === 'light' ? COLORS.body : 'rgba(255,255,255,0.7)',
                marginTop: 16,
                lineHeight: 1.4,
              },
              children: v.context || '',
            },
          },
          // Divider
          {
            type: 'div',
            props: {
              style: {
                width: 60,
                height: 1.5,
                backgroundColor: v.bg === 'light' ? '#D4D4D8' : '#333333',
                marginTop: 32,
                marginBottom: 32,
              },
            },
          },
          // Headline
          {
            type: 'div',
            props: {
              style: {
                display: 'flex',
                flexWrap: 'wrap',
                justifyContent: 'center',
                fontSize: 32,
                fontWeight: 700,
                color: v.bg === 'light' ? COLORS.heading : COLORS.white,
                lineHeight: 1.3,
                letterSpacing: '-0.02em',
              },
              children: hl(v.headline || ''),
            },
          },
          // Logo bottom
          {
            type: 'div',
            props: {
              style: {
                display: 'flex',
                marginTop: 'auto',
              },
              children: [
                {
                  type: 'img',
                  props: {
                    src: v.bg === 'light' ? a.logoLight : a.logoDark,
                    height: 28,
                  },
                },
              ],
            },
          },
        ],
      },
    }),
  },

  'quote-card': {
    name: 'Quote Card',
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
          backgroundColor: '#FAFAFA',
          fontFamily: 'Inter',
          padding: '80px 64px',
          border: '1px solid #E4E4E7',
        },
        children: [
          // Avatar + name row
          {
            type: 'div',
            props: {
              style: {
                display: 'flex',
                alignItems: 'center',
                gap: 16,
                marginBottom: 40,
              },
              children: [
                // Avatar circle with initials
                {
                  type: 'div',
                  props: {
                    style: {
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      width: 80,
                      height: 80,
                      borderRadius: '50%',
                      backgroundColor: COLORS.orange,
                      color: COLORS.white,
                      fontSize: 28,
                      fontWeight: 800,
                    },
                    children: (v.author_name || 'A')[0].toUpperCase(),
                  },
                },
                // Name + role
                {
                  type: 'div',
                  props: {
                    style: { display: 'flex', flexDirection: 'column', gap: 4 },
                    children: [
                      {
                        type: 'div',
                        props: {
                          style: {
                            display: 'flex',
                            fontSize: 18,
                            fontWeight: 700,
                            color: COLORS.heading,
                          },
                          children: v.author_name || '',
                        },
                      },
                      {
                        type: 'div',
                        props: {
                          style: { display: 'flex', fontSize: 14, color: COLORS.muted },
                          children: v.author_role || '',
                        },
                      },
                    ],
                  },
                },
              ],
            },
          },
          // Quote with orange bar
          {
            type: 'div',
            props: {
              style: {
                display: 'flex',
                flexDirection: 'row',
                gap: 24,
                flex: 1,
              },
              children: [
                // Orange bar
                {
                  type: 'div',
                  props: {
                    style: {
                      width: 3,
                      backgroundColor: COLORS.orange,
                      borderRadius: 2,
                      flexShrink: 0,
                    },
                  },
                },
                // Quote text
                {
                  type: 'div',
                  props: {
                    style: {
                      display: 'flex',
                      fontSize: 28,
                      fontWeight: 600,
                      color: COLORS.heading,
                      lineHeight: 1.5,
                      letterSpacing: '-0.01em',
                    },
                    children: `"${v.quote || ''}"`,
                  },
                },
              ],
            },
          },
          // Logo bar
          {
            type: 'div',
            props: {
              style: {
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                marginTop: 'auto',
                paddingTop: 32,
              },
              children: [
                { type: 'img', props: { src: a.logoLight, height: 28 } },
                {
                  type: 'div',
                  props: {
                    style: { display: 'flex', fontSize: 13, fontWeight: 500, color: '#8023FF' },
                    children: '#AtomChat',
                  },
                },
              ],
            },
          },
        ],
      },
    }),
  },

  'stat-card-gradient': {
    name: 'Stat Card Gradient',
    width: 1080,
    height: 1080,
    build: (v, a) => ({
      type: 'div',
      props: {
        style: {
          display: 'flex',
          flexDirection: 'column',
          justifyContent: 'center',
          alignItems: 'center',
          width: 1080,
          height: 1080,
          background: 'linear-gradient(136deg, #8023FF 0%, #FF6600 100%)',
          fontFamily: 'Inter',
          padding: '80px',
          textAlign: 'center',
          color: COLORS.white,
        },
        children: [
          // Big number
          {
            type: 'div',
            props: {
              style: {
                display: 'flex',
                fontSize: 96,
                fontWeight: 800,
                lineHeight: 1,
                letterSpacing: '-0.04em',
              },
              children: v.number || '',
            },
          },
          // Context
          {
            type: 'div',
            props: {
              style: {
                display: 'flex',
                fontSize: 24,
                fontWeight: 500,
                color: 'rgba(255,255,255,0.85)',
                marginTop: 16,
                lineHeight: 1.4,
              },
              children: v.context || '',
            },
          },
          // Divider
          {
            type: 'div',
            props: {
              style: {
                width: 60,
                height: 2,
                backgroundColor: 'rgba(255,255,255,0.3)',
                marginTop: 32,
                marginBottom: 32,
              },
            },
          },
          // Headline
          {
            type: 'div',
            props: {
              style: {
                display: 'flex',
                fontSize: 32,
                fontWeight: 700,
                lineHeight: 1.3,
                letterSpacing: '-0.02em',
              },
              children: v.headline || '',
            },
          },
          // Logo
          {
            type: 'div',
            props: {
              style: { display: 'flex', marginTop: 'auto' },
              children: [{ type: 'img', props: { src: a.logoDark, height: 28 } }],
            },
          },
        ],
      },
    }),
  },
};

export function getSatoriTemplate(name: string): SatoriTemplate | undefined {
  return SATORI_TEMPLATES[name];
}
