# gmail-auto-clean-ts

Gmail の**未読メール**を OpenAI で JUNK / KEEP に分類し、JUNK に **`AUTO_JUNK` ラベル**を付ける CLI ツールです。オプションで**ゴミ箱へ移動**（`TRASH` ラベル一括付与）や **Slack DM へのレポート**も行えます。

## 前提

- Node.js（推奨: 18 以降）
- Google Cloud で OAuth クライアントを作成し、Gmail API（`gmail.modify`）の同意が取れること
- OpenAI API キー（判定に使用）

## セットアップ

```bash
cd tools/gmail-auto-clean/gmail-auto-clean-ts
npm install
```

プロジェクト直下に `.env` を置く（`.gitignore` 済み）。

### 必須の環境変数

| 変数名 | 説明 |
|--------|------|
| `GOOGLE_CLIENT_ID` | OAuth クライアント ID |
| `GOOGLE_CLIENT_SECRET` | OAuth クライアント シークレット |
| `GOOGLE_REDIRECT_URI` | 同意フロー用リダイレクト URI（`temp.ts` と Google コンソールで一致させる） |
| `GOOGLE_REFRESH_TOKEN` | リフレッシュトークン |
| `OPENAI_API_KEY` | OpenAI API キー |

### 任意の環境変数

| 変数名 | 説明 |
|--------|------|
| `OPENAI_MODEL` | 既定は `gpt-4o-mini` |
| `CLASSIFY_PROMPT` | JUNK/KEEP の判断基準を**システム指示として**直接書く（最優先） |
| `CLASSIFY_PROMPT_PATH` | 上記の代わりに、プロンプトファイルのパスを指定 |
| `RULES_DIR` | `classify-prompt.txt` の既定ディレクトリ（未指定は `cwd/config`） |
| `GMAIL_TRASH_ON_JUNK` | `true` / `1` / `yes` / `on` で、JUNK を**ゴミ箱へ**（`batchModify` で `TRASH` 付与） |
| `SLACK_BOT_TOKEN` | Slack Bot の `xoxb-...` |
| `SLACK_DM_USER_ID` または `SLACK_USER_ID` | DM 先のメンバー ID |
| `SLACK_NOTIFY_EMAIL` | メールでユーザー解決する場合（Bot に `users:read.email` が必要） |

`CLASSIFY_PROMPT` もファイルも無い場合、システム指示は**空**になり、JSON 形式の追記のみコード側で付きます（判断基準はモデル任せに近くなります）。

### リフレッシュトークンの取得

OAuth クライアントのリダイレクト URI に `http://localhost` 等を登録したうえで:

```bash
npm run get-token
```

表示された URL を開き、リダイレクト URL の `code=` の値を貼り付けて、表示された `refresh_token` を `.env` の `GOOGLE_REFRESH_TOKEN` に設定します。

## 実行

開発時（TypeScript をそのまま実行）:

```bash
npm run dev
```

本番相当（ビルド後に実行）:

```bash
npm run build
npm run start
```

`node src/index.ts` は使わず、上記の npm スクリプトを使ってください。

### GitHub Actions（4 時間ごと）

リポジトリ直下の [`.github/workflows/gmail_auto_clean.yml`](../../../.github/workflows/gmail_auto_clean.yml) で、**UTC の 0 / 4 / 8 / 12 / 16 / 20 時**（4 時間ごと）に実行されます。日本時間（JST）では **9 / 13 / 17 / 21 / 1 / 5 時**です。

リポジトリの **Settings → Secrets and variables → Actions** に、上記の必須環境変数（および任意の Slack 等）を Secret として登録してください。手動実行は Actions タブの **Run workflow** から可能です。

## 動作の概要

1. **受信トレイの未読**（最大 30 件）を取得し、件名・From を読む。
2. **OpenAI に 1 回だけ**バッチで送り、各メールに `junk: true/false` を付ける（`response_format: json_object`）。
3. JUNK について **`AUTO_JUNK` ラベルを一括付与**（`users.messages.batchModify`）。
4. `GMAIL_TRASH_ON_JUNK` が有効なとき、同じく **`TRASH` ラベルを一括付与**してゴミ箱へ移動（完全削除ではない）。
5. Slack の環境変数が揃っていれば、**処理結果のレポートを DM** で送る。

## ディレクトリ構成（抜粋）

```
src/
  index.ts       # エントリ（dotenv + main）
  main.ts        # メイン処理
  auth/google.ts
  gmail/client.ts
  openai/classify.ts
  slack/report.ts
  rules/load.ts
  temp.ts        # トークン取得用
```

## ライセンス

ISC
