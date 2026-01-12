# 動作確認用curlコマンド

## 必要な情報
以下の情報をSupabase Dashboardから取得してください：
- **プロジェクトURL**: `https://<project-ref>.supabase.co`
- **Anon Key**: Supabase Dashboard > Settings > API > anon/public key

---

## 1. テキストから感情分析のみ（簡単なテスト）

```bash
curl -i --location --request POST 'https://<project-ref>.supabase.co/functions/v1/oneMinVoiceJournal' \
  --header 'Authorization: Bearer YOUR_ANON_KEY' \
  --header 'apikey: YOUR_ANON_KEY' \
  --header 'Content-Type: application/json' \
  --data '{"transcript":"今日はとても良い一日でした。新しいプロジェクトが成功して、とても嬉しい気持ちです。"}'
```

### 期待されるレスポンス
```json
{
  "analysis": {
    "emotion": "Happy",
    "title": "プロジェクト成功の喜び",
    "summary": "新しいプロジェクトが成功し、喜びを感じている",
    "advice": "成功を祝い、次の目標に向けて進みましょう"
  }
}
```

---

## 2. 音声ファイルからテキスト変換 + 感情分析

```bash
curl -i --location --request POST 'https://<project-ref>.supabase.co/functions/v1/oneMinVoiceJournal' \
  --header 'Authorization: Bearer YOUR_ANON_KEY' \
  --header 'apikey: YOUR_ANON_KEY' \
  --form 'file=@/path/to/your/audio.m4a'
```

**注意**: 
- 音声ファイルのパスを実際のファイルパスに置き換えてください
- 対応フォーマット: m4a, mp3, wav, webm など（Whisper APIがサポートする形式）

### 期待されるレスポンス
```json
{
  "transcript": "音声から変換されたテキスト",
  "analysis": {
    "emotion": "Happy",
    "title": "タイトル",
    "summary": "要約",
    "advice": "アドバイス"
  }
}
```

---

## 3. エラーチェック用（APIキー未設定の場合）

```bash
curl -i --location --request POST 'https://<project-ref>.supabase.co/functions/v1/oneMinVoiceJournal' \
  --header 'Authorization: Bearer YOUR_ANON_KEY' \
  --header 'apikey: YOUR_ANON_KEY' \
  --header 'Content-Type: application/json' \
  --data '{"transcript":"テスト"}'
```

---

## トラブルシューティング

### 401 Unauthorized エラー
- `YOUR_ANON_KEY`が正しく設定されているか確認
- `Authorization`と`apikey`ヘッダーの両方を設定してください

### 500 Internal Server Error
- Supabase Dashboardで`OPENAI_API_KEY`が設定されているか確認
- 設定方法: `supabase secrets set OPENAI_API_KEY=your-openai-api-key`

### 400 Bad Request
- リクエストボディの形式を確認
- 音声ファイルの場合は`multipart/form-data`形式で送信されているか確認
