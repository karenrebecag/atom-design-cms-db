const SUPABASE_URL = process.env.SUPABASE_URL;
const SERVICE_KEY = process.env.RESTRICTED_CONTENT_SECRET;

export const getImagePromptSchema = {
  type: 'object' as const,
  properties: {
    use_case: {
      type: 'string',
      description:
        'What the image is for (e.g. "linkedin-post", "hero-image", "instagram-post", "banner-marketing"). The tool finds the best template automatically.',
    },
    values: {
      type: 'object',
      description:
        'Key-value pairs to fill template variables. Required: subject, setting, composition, emotional_tone. Optional: character_outfit, props, subject_position, negative_space_side.',
      additionalProperties: { type: 'string' },
    },
  },
  required: ['use_case', 'values'],
};

export const listImagePromptsSchema = {
  type: 'object' as const,
  properties: {
    category: {
      type: 'string',
      description: 'Filter by category (e.g. "marketing"). Omit for all prompts.',
    },
  },
};

async function fetchImagePromptAPI(path: string, method: 'GET' | 'POST' = 'GET', body?: unknown) {
  if (!SUPABASE_URL || !SERVICE_KEY) {
    throw new Error('Missing SUPABASE_URL or RESTRICTED_CONTENT_SECRET');
  }

  const res = await fetch(`${SUPABASE_URL}/functions/v1/get-image-prompt${path}`, {
    method,
    headers: {
      Authorization: `Bearer ${process.env.SUPABASE_ANON_KEY}`,
      'Content-Type': 'application/json',
      'x-service-key': SERVICE_KEY,
    },
    ...(body ? { body: JSON.stringify(body) } : {}),
  });

  if (!res.ok) {
    throw new Error(`Image prompt API error: ${res.status}`);
  }

  return res.json();
}

export async function handleGetImagePrompt(args: unknown) {
  const { use_case, values } = args as {
    use_case: string;
    values: Record<string, string>;
  };

  // Step 1: Find template by use case (lightweight, no full template loaded)
  const matchData = await fetchImagePromptAPI(`?use_case=${encodeURIComponent(use_case)}`);

  const matches = matchData.matches as { name: string }[];
  if (!matches || matches.length === 0) {
    return {
      content: [
        {
          type: 'text' as const,
          text: `No template found for use case "${use_case}". Use atom_image_prompt_list to see available use cases.`,
        },
      ],
      isError: true,
    };
  }

  const templateName = matches[0].name;

  // Step 2: Fill template with values (only now loads the full template)
  const data = await fetchImagePromptAPI('', 'POST', {
    prompt_name: templateName,
    values,
  });

  return {
    content: [
      {
        type: 'text' as const,
        text: `# Generated Image Prompt\n\nTemplate: ${templateName} (matched use case: ${use_case})\n\n---\n\n${data.prompt}`,
      },
    ],
  };
}

export async function handleListImagePrompts(args: unknown) {
  const { category } = (args ?? {}) as { category?: string };
  const query = category ? `?category=${encodeURIComponent(category)}` : '';
  const data = await fetchImagePromptAPI(query);

  const prompts = data.prompts as {
    name: string;
    category: string;
    use_cases: string[];
  }[];

  const lines = prompts.map((p) => `- **${p.name}** (${p.category}): ${p.use_cases.join(', ')}`);

  return {
    content: [
      {
        type: 'text' as const,
        text: `# Available Image Prompt Templates\n\n${lines.join('\n')}\n\nUse \`atom_image_prompt\` with any use case above to generate a prompt.`,
      },
    ],
  };
}
