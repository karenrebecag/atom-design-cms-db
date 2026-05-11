const SUPABASE_URL = process.env.SUPABASE_URL;
const SERVICE_KEY = process.env.RESTRICTED_CONTENT_SECRET;

export const getImagePromptSchema = {
  type: 'object' as const,
  properties: {
    prompt_name: {
      type: 'string',
      description:
        'Name of the image prompt template (e.g. "b2b-saas-marketing"). Use atom_image_prompt_list to see available prompts.',
    },
    values: {
      type: 'object',
      description:
        'Key-value pairs to fill template variables. Required: subject, setting, composition, emotional_tone. Optional: character_outfit, props, subject_position, negative_space_side.',
      additionalProperties: { type: 'string' },
    },
  },
  required: ['prompt_name', 'values'],
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

async function fetchImagePromptAPI(
  path: string,
  method: 'GET' | 'POST' = 'GET',
  body?: unknown,
) {
  if (!SUPABASE_URL || !SERVICE_KEY) {
    throw new Error('Missing SUPABASE_URL or RESTRICTED_CONTENT_SECRET');
  }

  const res = await fetch(
    `${SUPABASE_URL}/functions/v1/get-image-prompt${path}`,
    {
      method,
      headers: {
        Authorization: `Bearer ${process.env.SUPABASE_ANON_KEY}`,
        'Content-Type': 'application/json',
        'x-service-key': SERVICE_KEY,
      },
      ...(body ? { body: JSON.stringify(body) } : {}),
    },
  );

  if (!res.ok) {
    throw new Error(`Image prompt API error: ${res.status}`);
  }

  return res.json();
}

export async function handleGetImagePrompt(args: unknown) {
  const { prompt_name, values } = args as {
    prompt_name: string;
    values: Record<string, string>;
  };

  const data = await fetchImagePromptAPI('', 'POST', {
    prompt_name,
    values,
  });

  return {
    content: [
      {
        type: 'text' as const,
        text: `# Generated Image Prompt\n\nTemplate: ${prompt_name}\n\n---\n\n${data.prompt}`,
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
    variables: Record<string, { description: string; options?: string[]; required?: boolean; default?: string }>;
  }[];

  const lines = prompts.map((p) => {
    const vars = Object.entries(p.variables)
      .map(([k, v]) => `  - \`${k}\`${v.required ? ' (required)' : ''}: ${v.description}${v.options ? ` [${v.options.join(', ')}]` : ''}${v.default ? ` (default: ${v.default})` : ''}`)
      .join('\n');
    return `### ${p.name}\nCategory: ${p.category}\n\nVariables:\n${vars}`;
  });

  return {
    content: [
      {
        type: 'text' as const,
        text: `# Available Image Prompts\n\n${lines.join('\n\n---\n\n')}`,
      },
    ],
  };
}
