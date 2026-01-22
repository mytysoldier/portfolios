import os
import google.generativeai as genai


def call_gemini_sdk(prompt: str, model_name: str = "gemini-2.5-flash") -> str:
    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        raise ValueError("GEMINI_API_KEY が .env に設定されていません。")

    genai.configure(api_key=api_key)
    model = genai.GenerativeModel(model_name)
    response = model.generate_content(prompt)

    if hasattr(response, "text") and response.text:
        return response.text

    try:
        parts = response.candidates[0].content.parts
        texts = [p.text for p in parts if hasattr(p, "text")]
        if texts:
            return "".join(texts)
    except Exception:
        pass

    return str(response)
