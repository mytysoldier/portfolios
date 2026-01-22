import os
from openai import OpenAI


def call_openai_sdk(prompt: str, model_name: str = "gpt-5.2") -> str:
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        raise ValueError("OPENAI_API_KEY が .env に設定されていません。")

    client = OpenAI(api_key=api_key)

    try:
        response = client.responses.create(
            model=model_name,
            input=prompt,
        )
        if hasattr(response, "output_text") and response.output_text:
            return response.output_text
        return str(response)
    except Exception:
        response = client.chat.completions.create(
            model=model_name,
            messages=[{"role": "user", "content": prompt}],
        )
        return response.choices[0].message.content
