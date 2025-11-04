import os
from dotenv import load_dotenv
from openai import OpenAI

def test_openai():
    load_dotenv()
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        raise ValueError("❌ OPENAI_API_KEY が見つかりません。.env を確認してください。")

    client = OpenAI(api_key=api_key)

    prompt = "こんにちは！1行で自己紹介して。"

    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.2,
    )

    print("=== OpenAI OK ===")
    print(response.choices[0].message.content.strip())

if __name__ == "__main__":
    test_openai()
