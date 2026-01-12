# One Minute Voice Journal Backend

音声ジャーナルの感情分析を行うSupabase Edge Functionsです。

## 機能

- **音声テキスト変換**: 音声ファイルをテキストに変換（Whisper API）
- **感情分析**: テキストから感情を分析（GPT-4o-mini）

## セットアップ

### 1. Supabase CLIのインストール

```bash
npm install -g supabase
```

### 2. プロジェクトへのログインとリンク

```bash
supabase login
supabase link --project-ref your-project-ref
```

### 3. 環境変数の設定

```bash
supabase secrets set OPENAI_API_KEY=your-openai-api-key
supabase secrets set ONE_MIN_VOICE_JOURNAL_APP_KEY=your-app-key
```

**必要な環境変数:**
- `OPENAI_API_KEY`: OpenAI APIキー
- `ONE_MIN_VOICE_JOURNAL_APP_KEY`: アプリケーション認証キー（X-App-Keyヘッダーで検証）

## デプロイ

```bash
# 音声テキスト変換エンドポイント
supabase functions deploy oneMinVoiceJournalTranscribe

# 感情分析エンドポイント
supabase functions deploy oneMinVoiceJournalAnalyze
```

## ローカル開発

### 環境変数の設定

プロジェクトルートに`.env`ファイルを作成：

```bash
OPENAI_API_KEY=your-openai-api-key
ONE_MIN_VOICE_JOURNAL_APP_KEY=your-app-key
```

### ローカルで関数を起動

```bash
# 音声テキスト変換エンドポイント
supabase functions serve oneMinVoiceJournalTranscribe --env-file .env

# 感情分析エンドポイント（別のターミナルで）
supabase functions serve oneMinVoiceJournalAnalyze --env-file .env
```

## API エンドポイント

### 1. 音声テキスト変換

**エンドポイント:** `POST /functions/v1/oneMinVoiceJournalTranscribe`

**リクエスト:**
```bash
curl -i --location --request POST 'https://your-project.supabase.co/functions/v1/oneMinVoiceJournalTranscribe' \
  --header 'Authorization: Bearer YOUR_ANON_KEY' \
  --header 'apikey: YOUR_ANON_KEY' \
  --header 'X-App-Key: YOUR_APP_KEY' \
  --form 'file=@/path/to/audio.m4a'
```

**レスポンス:**
```json
{
  "transcript": "変換されたテキスト"
}
```

### 2. 感情分析

**エンドポイント:** `POST /functions/v1/oneMinVoiceJournalAnalyze`

**リクエスト:**
```bash
curl -i --location --request POST 'https://your-project.supabase.co/functions/v1/oneMinVoiceJournalAnalyze' \
  --header 'Authorization: Bearer YOUR_ANON_KEY' \
  --header 'apikey: YOUR_ANON_KEY' \
  --header 'X-App-Key: YOUR_APP_KEY' \
  --header 'Content-Type: application/json' \
  --data '{"transcript":"今日はとても良い一日でした"}'
```

**レスポンス:**
```json
{
  "analysis": {
    "emotion": "Happy",
    "title": "タイトル",
    "summary": "要約",
    "advice": "アドバイス"
  }
}
```

**感情カテゴリー:**
- Happy
- Calm
- Neutral
- Sad
- Angry
- Hurt
- Overwhelmed

## 認証

すべてのエンドポイントで以下の認証が必要です：

- `Authorization: Bearer YOUR_ANON_KEY` - SupabaseのAnon Key
- `apikey: YOUR_ANON_KEY` - SupabaseのAnon Key
- `X-App-Key: YOUR_APP_KEY` - アプリケーション認証キー（環境変数`ONE_MIN_VOICE_JOURNAL_APP_KEY`と一致する必要があります）

## エラーレスポンス

```json
{
  "error": "エラーメッセージ"
}
```

**ステータスコード:**
- `400` - バリデーションエラー
- `401` - 認証エラー（アプリキー不一致など）
- `405` - メソッドが許可されていない
- `500` - サーバーエラー

## API仕様書

OpenAPI 3.0形式の仕様書が`openapi.yaml`に含まれています。

[Swagger Editor](https://editor.swagger.io/)で`openapi.yaml`を開いて確認できます。
