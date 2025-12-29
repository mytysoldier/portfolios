## LLM Utility API

FastAPI ベースのシンプルな “LLM Utility API” です。  
**LangChain** を使用して OpenAI または Gemini（LLM_PROVIDER で切り替え）を呼び出し、
日本語テキストの **要約 / 文体書き換え / 要点抽出** を行います。

**主な機能:**
- LangChain による統一的な LLM 呼び出し（OpenAI / Gemini 両対応）
- LangSmith による自動トレース（オプション）
- IP/秒レート制限
- 統一的なエラーフォーマット

実装済みエンドポイント:

- **GET `/health`**: 死活監視用。`{"status": "ok"}` を返します。
- **POST `/summarize`**: LLM で日本語要約。`max_chars` 文字以内で返します。
- **POST `/rewrite`**: LLM で tone に応じた文体書き換え（polite/casual/business/friendly）。
- **POST `/extract`**: LLM で要点抽出。`items` 配列として `{text, confidence}` を返します。

---

### 1. セットアップ（venv 使用）

プロジェクトルートはこの README があるディレクトリ（`llm-utility-api`）です。

```bash
cd llm-utility-api

# venv 作成
python -m venv .venv

# venv 有効化 (macOS / Linux)
source .venv/bin/activate

# 依存関係インストール
pip install --upgrade pip
pip install -e .
```

※ `pip install -e .` がうまく動かない場合は以下でも構いません:

```bash
pip install fastapi uvicorn[standard] python-dotenv openai google-generativeai langchain-core langchain-openai langchain-google-genai langsmith
```

---

### 2. 環境変数の設定（.env）

プロジェクトルート（この README があるディレクトリ）に `.env` を作成し、
以下のように LLM プロバイダと API キー / モデルを設定します。

`.env` の例:

```env
# 使用する LLM プロバイダ: openai または gemini
LLM_PROVIDER=openai

# OpenAI を使う場合
OPENAI_API_KEY=sk-xxxxxxx
OPENAI_MODEL=gpt-4o-mini

# Gemini を使う場合
GEMINI_API_KEY=your-gemini-api-key
GEMINI_MODEL=gemini-1.5-flash

# レート制限（1秒あたりのリクエスト数、デフォルト: 2）
RATE_LIMIT_PER_SECOND=2

# LangSmith トレース（オプション）
# LANGCHAIN_TRACING_V2=true と LANGCHAIN_API_KEY を設定すると自動でトレースされる
# プロジェクト名は default でも OK（LangSmith に default プロジェクトが存在する場合）
LANGCHAIN_TRACING_V2=false
LANGCHAIN_API_KEY=
LANGCHAIN_PROJECT=default
```

`.env.example` にも同じキー名をコメント付きで記載しているので、
それをコピーして `.env` を作成しても構いません。

### 3. 開発サーバ起動（uvicorn）

```bash
cd llm-utility-api
source .venv/bin/activate

uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

起動後、ブラウザで `http://127.0.0.1:8000/docs` にアクセスすると Swagger UI が表示されます。

---

### 4. curl での動作確認例

#### 4-1. Health チェック

```bash
curl -X GET "http://127.0.0.1:8000/health"
```

想定レスポンス:

```json
{"status":"ok"}
```

#### 4-2. Summarize（日本語要約）

```bash
curl -X POST "http://127.0.0.1:8000/summarize" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "これはとても長いテキストです。LLM による要約エンドポイントでは、重要な情報を残しつつ短く分かりやすくまとめます。",
    "max_chars": 100,
    "style": "simple"
  }'
```

想定レスポンス例:

```json
{
  "summary": "LLM による要約エンドポイントでは、重要な情報を残しつつ短く分かりやすくまとめます。"
}
```

#### 4-3. Rewrite（文体書き換え）

```bash
curl -X POST "http://127.0.0.1:8000/rewrite" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "この文章を丁寧な表現に書き換えてください。",
    "tone": "polite",
    "max_chars": 100,
    "keep_meaning": true
  }'
```

想定レスポンス例:

```json
{
  "rewritten_text": "こちらの文章を、より丁寧で礼儀正しい表現に書き換えました。"
}
```

#### 4-4. Extract（要点抽出）

```bash
curl -X POST "http://127.0.0.1:8000/extract" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "今日は晴れです。洗濯をしました。\nそのあとは買い物に行きました。",
    "max_items": 3
  }'
```

想定レスポンス例:

```json
{
  "items": [
    { "text": "今日は晴れている", "confidence": 1.0 },
    { "text": "洗濯をした", "confidence": 1.0 },
    { "text": "その後に買い物に行った", "confidence": 1.0 }
  ]
}
```

---

### 5. レート制限

API には **IP/秒レート制限** が実装されています。

- デフォルト: **1秒あたり 2 リクエスト**（`RATE_LIMIT_PER_SECOND` で変更可能）
- 制限を超えた場合: **HTTP 429** を返します
- `/health` エンドポイントはレート制限の対象外です

#### レート制限の動作確認

```bash
# 連続で3回リクエストを送る（デフォルト制限は2/秒）
for i in {1..3}; do
  curl -X POST "http://127.0.0.1:8000/summarize" \
    -H "Content-Type: application/json" \
    -d '{"text": "テスト", "max_chars": 50}'
  echo ""
done
```

3回目のリクエストで 429 エラーが返ります:

```json
{
  "error": {
    "code": "rate_limited",
    "message": "レート制限を超過しました。",
    "details": {"limit_per_second": 2}
  }
}
```

---

### 6. LangSmith トレース（オプション）

この API は **LangChain** を使用して LLM を呼び出しているため、**LangSmith によるトレース**を有効化できます。

**OpenAI と Gemini の両方で LangSmith トレースが機能します。**

#### セットアップ手順

1. [LangSmith](https://smith.langchain.com/) にアカウントを作成
2. API キーを取得（Settings → API Keys）
3. `.env` に以下を設定:

```env
LANGCHAIN_TRACING_V2=true
LANGCHAIN_API_KEY=your-langsmith-api-key
LANGCHAIN_PROJECT=default
```

**プロジェクト名について:**
- `default` プロジェクトが LangSmith に存在する場合は、そのまま使用できます
- 新しいプロジェクトを作成したい場合は、任意の名前を指定してください（初回実行時に自動作成されます）

#### トレースの確認

1. サーバーを起動（起動時に `[LangSmith] トレースを有効化しました。プロジェクト: default` と表示されれば OK）
2. 任意のエンドポイント（`/summarize` など）にリクエストを送る
3. [LangSmith の Projects ページ](https://smith.langchain.com/o/projects) で指定したプロジェクトを開く
4. トレースが記録されていることを確認

**確認できる情報:**
- 送ったプロンプトの内容
- LLM からの回答
- トークン使用量
- レスポンス時間
- エラー情報（発生した場合）

**注意**: `LANGCHAIN_TRACING_V2=false` または `LANGCHAIN_API_KEY` が未設定の場合は、トレースは記録されません（通常通り動作します）。

---

### 7. 環境変数ファイル（.env / .env.example）

リポジトリには `.env.example` を配置しており、必要なキー名を列挙しています。

運用時は `.env` を作成し、`.env.example` と同じキー名で実際の値を設定してください。

