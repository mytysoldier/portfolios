# TODO

## Phase1: 先にやるプロジェクト整備
- [x] 1. `requirements.txt` に `streamlit` と各プロバイダのSDKを追加する。
- [x] 1. `requirements.txt` に `langchain` を追加する。
- [x] 2. `.env.example` と README の実行手順（`streamlit run app.py`）を追加する。

## Phase2: Streamlitアプリ
- [x] 1. `app.py` を作成し、StreamlitのUI（プロンプト入力、モデルプルダウン、実行ボタン、出力欄）を実装する。
- [x] 2. LangChain 統一クライアント `call_llm()` を作成し、LLM 呼び出しを一本化する。
- [x] 3. LLM API のプルダウンを追加し、モデル候補を API ごとに切り替える。
- [x] 4. Streamlit から LangSmith の自動トレース（LangChain Tracing V2）を有効化する。

## Phase3: プロバイダ対応
- [x] 1. LangChain の各プロバイダ統合（OpenAI / Anthropic / Gemini）を追加する。
- [x] 2. 環境変数で API キーを読み込み、LangChain 経由で呼び出す。
- [ ] 3. 追加候補のAPIを評価し、必要なら対応する:
  - Groq（高速な Llama 系）
  - Mistral
  - Cohere
  - Together
  - AWS Bedrock（複数モデルのゲートウェイ）

## Phase4: UXと設定
- [x] 1. プロバイダ別のモデル一覧を UI で選択できるようにする。
- [ ] 2. 必要なら基本パラメータ（temperature, max tokens）を追加する。
- [ ] 3. 必須APIキーが無い場合の UI エラー表示を明確にする。

## Phase5: プロジェクト整備
- [ ] 1. プロバイダごとの簡易テスト手順を作る。
