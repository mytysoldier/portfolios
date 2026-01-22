import os
from anthropic import Anthropic


def call_anthropic_sdk(prompt: str, model_name: str = "claude-sonnet-4-5") -> str:
    api_key = os.getenv("ANTHROPIC_API_KEY")
    if not api_key:
        raise ValueError("ANTHROPIC_API_KEY が .env に設定されていません。")

    client = Anthropic(api_key=api_key)
    response = client.messages.create(
        model=model_name,
        max_tokens=1024,
        messages=[{"role": "user", "content": prompt}],
    )
    return "".join(block.text for block in response.content if hasattr(block, "text"))
