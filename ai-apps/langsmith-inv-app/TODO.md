# TODO

## Phase1: 先にやるプロジェクト整備
- [x] 1. `requirements.txt` に `streamlit` と各プロバイダのSDKを追加する。
- [x] 1. `requirements.txt` に `langchain` を追加する。
- [x] 2. `.env.example` と README の実行手順（`streamlit run app.py`）を追加する。

## Phase2: Streamlitアプリ
- [x] 1. `app.py` を作成し、StreamlitのUI（プロンプト入力、モデルプルダウン、実行ボタン、出力欄）を実装する。
- [ ] 2. `main.py` をプロバイダ別の再利用可能な関数に分割する（Gemini / OpenAI / Claude）。
- [ ] 3. プルダウンの選択に応じてルーティングする `call_llm()` を追加する。
- [ ] 4. 各呼び出しで LangSmith の run 作成・更新・エラー処理を実装する。

## Phase3: プロバイダ対応
- [ ] 1. OpenAI SDK を追加し、`OPENAI_API_KEY` を扱う。
- [ ] 2. Anthropic SDK を追加し、`ANTHROPIC_API_KEY` を扱う。
- [ ] 3. Gemini は `GEMINI_API_KEY` で継続対応する。
- [ ] 4. 追加候補のAPIを評価し、必要なら対応する:
  - Groq（高速な Llama 系）
  - Mistral
  - Cohere
  - Together
  - AWS Bedrock（複数モデルのゲートウェイ）

## Phase4: UXと設定
- [ ] 1. プロバイダ別のデフォルトモデル一覧を定義する（例: `gemini-1.5-flash`, `gpt-4o-mini`, `claude-3.5-sonnet`）。
- [ ] 2. 必要なら基本パラメータ（temperature, max tokens）を追加する。
- [ ] 3. 必須APIキーが無い場合のUIエラー表示を明確にする。

## Phase5: プロジェクト整備
- [ ] 1. プロバイダごとの簡易テスト手順を作る。
