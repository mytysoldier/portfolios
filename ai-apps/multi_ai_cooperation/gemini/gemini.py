import os
from dotenv import load_dotenv
import google.generativeai as genai

def test_gemini():
    load_dotenv()
    api_key = os.getenv("GOOGLE_API_KEY")
    if not api_key:
        raise ValueError("❌ GOOGLE_API_KEY が見つかりません。.env を確認してください。")

    genai.configure(api_key=api_key)
    model = genai.GenerativeModel("gemini-2.5-flash")

    prompt = "こんにちは！1行で自己紹介して。"
    response = model.generate_content(prompt)

    print("=== Gemini OK ===")
    print(response.text.strip())

if __name__ == "__main__":
    test_gemini()
