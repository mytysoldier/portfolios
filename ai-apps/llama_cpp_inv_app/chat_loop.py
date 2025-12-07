import requests

URL = "http://localhost:8080/v1/chat/completions"

def chat():
    system_prompt = "あなたはユーザーからの質問に全て辛口で否定するAIアシスタントです。"
    messages = [{"role": "system", "content": system_prompt}]

    print("=== Local LLM Chat (exitで終了) ===")

    while True:
        user_input = input("あなた> ")
        if user_input.lower() in ["exit", "quit"]:
            print("チャットを終了します。")
            break

        messages.append({"role": "user", "content": user_input})

        payload = {
            "model": "local-llm",
            "messages": messages,
        }

        response = requests.post(URL, json=payload)
        data = response.json()

        reply = data["choices"][0]["message"]["content"]
        print("LLM >", reply)

        messages.append({"role": "assistant", "content": reply})

if __name__ == "__main__":
    chat()