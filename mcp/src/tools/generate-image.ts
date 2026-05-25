import { z } from 'zod';

function getFalKey() {
  return process.env.FAL_API_KEY;
}

const SIZE_MAP: Record<string, { width: number; height: number }> = {
  square_hd: { width: 1024, height: 1024 },
  landscape_16_9: { width: 1024, height: 576 },
  portrait_9_16: { width: 576, height: 1024 },
  portrait_4_5: { width: 1080, height: 1350 },
};

const VALID_SIZES = Object.keys(SIZE_MAP) as [string, ...string[]];

export const generateImageSchema = {
  type: 'object' as const,
  properties: {
    prompt: {
      type: 'string',
      description:
        'Photorealistic image prompt. Use atom_image_prompt first to build a brand-consistent prompt, then pass the result here.',
    },
    size: {
      type: 'string',
      description:
        'Image size: "square_hd" (1:1), "landscape_16_9" (16:9), "portrait_9_16" (9:16 stories), "portrait_4_5" (4:5 Instagram/LinkedIn feed)',
      enum: VALID_SIZES,
    },
  },
  required: ['prompt'],
};

const GenerateImageInput = z.object({
  prompt: z.string().min(1),
  size: z.enum(VALID_SIZES).default('square_hd'),
});

export async function handleGenerateImage(args: unknown) {
  const parsed = GenerateImageInput.safeParse(args);
  if (!parsed.success) {
    return {
      content: [{ type: 'text' as const, text: `Invalid input: ${parsed.error.message}` }],
      isError: true,
    };
  }
  const { prompt, size } = parsed.data;

  if (!getFalKey()) {
    return {
      content: [
        {
          type: 'text' as const,
          text: 'FAL_API_KEY not configured. Set it as an environment variable.',
        },
      ],
      isError: true,
    };
  }

  const dimensions = SIZE_MAP[size];

  try {
    const res = await fetch('https://fal.run/fal-ai/flux/dev', {
      method: 'POST',
      headers: {
        Authorization: `Key ${getFalKey()}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        prompt,
        image_size: dimensions,
        num_images: 1,
      }),
    });

    if (!res.ok) {
      const err = await res.text();
      return {
        content: [{ type: 'text' as const, text: `Flux API error: ${res.status} ${err}` }],
        isError: true,
      };
    }

    const data = (await res.json()) as {
      images: { url: string; width: number; height: number }[];
    };

    const img = data.images[0];

    return {
      content: [
        {
          type: 'text' as const,
          text: `# Image Generated\n\n![Generated image](${img.url})\n\n- **URL:** ${img.url}\n- **Size:** ${img.width}x${img.height}\n- **Use as:** \`background-image: url('${img.url}')\``,
        },
      ],
    };
  } catch (err) {
    return {
      content: [{ type: 'text' as const, text: `Generation failed: ${err}` }],
      isError: true,
    };
  }
}
