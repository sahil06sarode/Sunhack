import {config, requireGeminiApiKey} from '../config';

interface GeminiPart {
  text: string;
}

interface GeminiResponse {
  candidates?: Array<{
    content?: {
      parts?: GeminiPart[];
    };
  }>;
}

export async function generateWithGemini(prompt: string): Promise<string> {
  if (!config.geminiApiKey) {
    return '';
  }

  const apiKey = requireGeminiApiKey();
  const endpoint = `https://generativelanguage.googleapis.com/v1beta/${config.geminiTextModel}:generateContent?key=${apiKey}`;

  const response = await fetch(endpoint, {
    method: 'POST',
    headers: {'content-type': 'application/json'},
    body: JSON.stringify({
      contents: [
        {
          role: 'user',
          parts: [{text: prompt}],
        },
      ],
      generationConfig: {
        responseMimeType: 'text/plain',
      },
    }),
  });

  if (!response.ok) {
    return '';
  }

  const payload = (await response.json()) as GeminiResponse;
  return (
    payload.candidates?.[0]?.content?.parts
      ?.map((part) => part.text)
      .join('')
      .trim() ?? ''
  );
}
