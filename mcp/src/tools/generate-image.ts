const FAL_API_KEY = process.env.FAL_API_KEY;

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
      description: 'Image size: "square_hd" (1:1), "landscape_16_9", "portrait_9_16"',
      enum: ['square_hd', 'landscape_16_9', 'portrait_9_16'],
    },
  },
  required: ['prompt'],
};

export async function handleGenerateImage(args: unknown) {
  const { prompt, size = 'square_hd' } = args as {
    prompt: string;
    size?: string;
  };

  if (!FAL_API_KEY) {
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

  try {
    const res = await fetch('https://fal.run/fal-ai/flux/schnell', {
      method: 'POST',
      headers: {
        Authorization: `Key ${FAL_API_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        prompt,
        image_size: size,
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
