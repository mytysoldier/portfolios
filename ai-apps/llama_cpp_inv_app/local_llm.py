import requests

URL = "http://localhost:8080/v1/chat/completions"

payload = {
    "model": "local-llm",
    "messages": [
        {"role": "user", "content": "Hello, how are you?"}
    ],
}

if __name__ == "__main__":
    response = requests.post(URL, json=payload)
    print(response.json())