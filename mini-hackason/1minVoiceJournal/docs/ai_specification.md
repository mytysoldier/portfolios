## 🤖 AI Specification

### 🔤 Whisper（音声 → テキスト）
- モデル: `whisper-1`
- 文字起こし後のテキストを GPT に渡す

### 🧠 GPT 感情分析プロンプト例
```text
あなたは感情分析AIです。
以下のユーザーの音声テキストを読み、
感情カテゴリー・タイトル・要約・アドバイスを JSON 形式で出力してください。

感情カテゴリーは次のいずれかです：
Happy, Calm, Neutral, Sad, Angry, Hurt, Overwhelmed

### 🧾 JSON 出力形式

```json
{
  "emotion": "Sad",
  "title": "気持ちが沈んだ日",
  "summary": "今日は仕事でうまくいかず、落ち込んでいる様子です。",
  "advice": "今日は早めに休んで、自分のがんばりを認めてあげてください。"
}