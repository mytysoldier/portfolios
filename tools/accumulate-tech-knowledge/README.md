# AIニュース選別API

TechFeed などの RSS から技術記事を取得し、OpenAI API で読む価値がある記事を選んで返す最小構成の FastAPI アプリです。FastAPI Cloud へのデプロイを前提にしています。

## 機能

| エンドポイント | 説明 |
| --- | --- |
| `GET /health` | 認証なし（公開）。`{"status": "ok"}` |
| `GET /news` | **要 `X-API-Key` ヘッダ**（環境変数 `API_KEY` と一致）。RSS 取得 → AI で選別 → JSON 返却。任意で Slack DM 通知 |

`OPENAI_API_KEY` が未設定のとき、または OpenAI 呼び出しに失敗したときは、AI 選別をスキップして取得した RSS 記事をそのまま返します（`selection_method: "fallback"`）。AI 利用時は「読む価値がある」記事を件数上限なく返します（0件のこともあります）。

## 前提

- Python 3.12+
- [uv](https://docs.astral.sh/uv/)（`.venv` の作成・依存関係のインストールに使用）
- （任意）OpenAI API キー

## uv のインストール

`zsh: command not found: uv` と出る場合は、uv が PATH に入っていません。macOS（zsh）では次のいずれかで入れます。

**公式インストーラ（推奨）**

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

インストール後、シェルを読み直すか PATH を足します:

```bash
export PATH="$HOME/.local/bin:$PATH"
uv --version
```

恒久化（zsh）:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**Homebrew を使う場合**

```bash
brew install uv
uv --version
```

**uv なしで venv だけ作る場合**（`uv sync` の代わり）

```bash
cd tools/accumulate-tech-knowledge
python3 -m venv .venv
source .venv/bin/activate
pip install "fastapi[standard]" feedparser httpx openai python-dotenv
```

## ローカル起動（venv）

ローカルではプロジェクト直下の **`.venv`** を有効化してからコマンドを実行します（`uv run` は使わない想定）。

**venv の有効化**（プロジェクトルートで実行。プロンプト先頭に `(.venv)` が付けば OK）:

```bash
cd tools/accumulate-tech-knowledge
source .venv/bin/activate          # macOS / Linux (bash / zsh)
# .venv\Scripts\Activate.ps1       # Windows (PowerShell)
```

**初回セットアップ〜起動**（上記のあと、同じシェルで続けて実行）:

```bash
# 1. .venv を作成し依存関係をインストール（有効化前でも可）
uv sync
source .venv/bin/activate          # まだの場合

# 2. 環境変数（.env は .gitignore 済み）
cp .env.example .env
# .env を編集して OPENAI_API_KEY などを設定

# 3. 開発サーバー
fastapi dev
```

別ターミナルで確認:

```bash
curl http://127.0.0.1:8000/health
curl -H "X-API-Key: $API_KEY" http://127.0.0.1:8000/news
```

（`API_KEY` は `.env` の値。または直接文字列を指定）

`fastapi dev` の代わりに uvicorn だけ使う場合（venv 有効化後）:

```bash
uvicorn main:app --reload --host 127.0.0.1 --port 8000
```

作業終了時は `deactivate` で venv を抜けます。

**エディタ（Cursor / VS Code）**: コマンドパレットの「Python: Select Interpreter」で  
`accumulate-tech-knowledge/.venv/bin/python` を選ぶと、型チェックや定義ジャンプが `.venv` のパッケージを参照します。

## 環境変数

ローカルと FastAPI Cloud で **同じ変数名** を使います。読み取りは `news/config.py` などから `os.getenv(...)` で行います。

| 環境 | 設定場所 |
| --- | --- |
| ローカル | プロジェクト直下の `.env`（`main.py` 起動時に `python-dotenv` で読み込み） |
| FastAPI Cloud | ダッシュボードの Environment Variables または `fastapi cloud env set`（`.env` はデプロイに含まれない） |

### 一覧

| 変数名 | 必須 | 既定値 | 概要 |
| --- | --- | --- | --- |
| `API_KEY` | **はい** | なし | `/news` 用。リクエストヘッダ `X-API-Key` と一致必須 |
| `RSS_FEED_URLS` | **はい** | なし | 取得する RSS/Atom フィード URL（カンマ区切り） |
| `RSS_MAX_PER_FEED` | いいえ | `15` | 各フィードから取る記事の最大件数 |
| `NEWS_CANDIDATE_MAX` | いいえ | `30` | OpenAI に渡す候補の最大件数 |
| `OPENAI_API_KEY` | いいえ | なし | 設定時のみ AI 選別。未設定時は RSS 取得分をそのまま返す |
| `OPENAI_MODEL` | いいえ | `gpt-4o-mini` | OpenAI のモデル名 |
| `SLACK_BOT_TOKEN` | いいえ | なし | 設定時、`GET /news` 成功後に Slack DM でレポート送信 |
| `SLACK_DM_USER_ID` | いいえ* | なし | DM 先のメンバー ID（*Bot トークン設定時は必須） |

### 各変数の説明

#### `API_KEY`（必須）

`GET /news` を呼ぶときの共有秘密。リクエストに次のヘッダを付けます。

```http
X-API-Key: <API_KEY と同じ値>
```

```env
API_KEY=your-secret-key-here
```

- ヘッダなし・不一致・サーバー側未設定 → いずれも **`401`** と `{"detail":"認証に失敗しました。"}` のみ（`API_KEY` の有無は返さない）
- `GET /health` には不要（公開のまま）
- 本番では FastAPI Cloud で `--secret` 推奨
- 読み取り: `news/config.py` の `get_api_key()` / `news/auth.py`

ローカル・本番の確認例:

```bash
curl -H "X-API-Key: your-secret-key-here" http://127.0.0.1:8000/news
```

#### `RSS_FEED_URLS`（必須）

記事を取得する **フィード URL** をカンマ区切りで指定します。記事ページの URL ではなく、RSS 2.0 / Atom のフィード URL を指定してください。

```env
RSS_FEED_URLS=https://techfeed.io/feeds/categories/all,https://hnrss.org/frontpage
```

- 未設定・空文字 → `/news` 実行時に `ValueError`
- 読み取り: `news/config.py` の `get_feed_urls()`

#### `RSS_MAX_PER_FEED`（任意）

**1 つのフィードあたり** 何件まで記事を取るか。新しい順に並べたうえで先頭 N 件を使います。

```env
RSS_MAX_PER_FEED=15
```

- 正の整数のみ（`1` 未満や非数値は `ValueError`）
- フィードが 2 本なら、最大でおおよそ `RSS_MAX_PER_FEED × 2` 件が `fetched_count` の上限になる
- 読み取り: `news/rss.py` の `fetch_articles()`

#### `NEWS_CANDIDATE_MAX`（任意）

RSS で集めた記事のうち、**OpenAI に渡す候補**の最大件数。公開日時で並べたあと、先頭 N 件だけを AI に送ります。

```env
NEWS_CANDIDATE_MAX=30
```

- 正の整数のみ
- `candidate_count = min(fetched_count, NEWS_CANDIDATE_MAX)`（レスポンスの `candidate_count`）
- `OPENAI_API_KEY` 未設定の fallback 時は AI を使わないため、この値は候補数には使われない（`candidate_count` は `fetched_count` と同じ）
- 読み取り: `news/selector.py` / `news/service.py`

#### `OPENAI_API_KEY`（任意）

OpenAI API キー。設定されているときだけ `GET /news` で AI 選別を行います。

```env
OPENAI_API_KEY=sk-...
```

- 未設定 → `selection_method: "fallback"`（RSS 取得分をすべて返す）
- API エラー時も `fallback` に落ちる
- 本番では FastAPI Cloud で `--secret` 推奨

#### `OPENAI_MODEL`（任意）

Chat Completions で使うモデル名。

```env
OPENAI_MODEL=gpt-4o-mini
```

- 未設定時はコード側の既定 `gpt-4o-mini`
- コストや精度のバランスで変更可能

#### Slack 通知（任意）

[`gmail-auto-clean-ts`](../gmail-auto-clean/gmail-auto-clean-ts) と **同じ Bot トークン・同じ DM 宛先** を使えます。`GET /news` で記事を選別したあと、結果を Slack DM に送ります。未設定の変数だけある場合は通知をスキップし、API レスポンスは通常どおり返します（`slack_notified: false`）。

```env
SLACK_BOT_TOKEN=xoxb-...
SLACK_DM_USER_ID=U0123456789
```

- 送信失敗時も `/news` は **200** のまま（ログにエラー、`slack_notified: false`）
- 読み取り: `news/slack.py`

### 件数の流れ（`GET /news`）

```
RSS_FEED_URLS の各 URL
  └─ 各フィード最大 RSS_MAX_PER_FEED 件 → fetched_count（合計）
       └─ 先頭 NEWS_CANDIDATE_MAX 件 → candidate_count（AI 候補）
            └─ OpenAI が選別 → count（返却記事数）
```

例: フィード 2 本、`RSS_MAX_PER_FEED=15`、`NEWS_CANDIDATE_MAX=30` のとき

- RSS で最大 30 件取得 → `fetched_count: 30`
- 候補 30 件を AI に送信 → `candidate_count: 30`
- AI が 6 件を選択 → `count: 6`（「30 件中 6 件」）

### `.env` の雛形

リポジトリ直下の [`.env.example`](.env.example) をコピーして使います。全変数の記入例は次のとおりです。

```env
API_KEY=your-secret-key-here
OPENAI_API_KEY=sk-...
OPENAI_MODEL=gpt-4o-mini
RSS_FEED_URLS=https://techfeed.io/feeds/categories/all,https://hnrss.org/frontpage
RSS_MAX_PER_FEED=15
NEWS_CANDIDATE_MAX=30
# Slack（任意・gmail-auto-clean-ts と同じ値をコピー可）
# SLACK_BOT_TOKEN=xoxb-...
# SLACK_DM_USER_ID=U0123456789
```

```bash
cp .env.example .env
```

### ローカルでの設定手順

1. 上記 **`.env` の雛形** と [各変数の説明](#各変数の説明) を参考に `.env` を編集する（`.env` は git に含めない）
2. venv を有効化して開発サーバーを起動する

   ```bash
   cd tools/accumulate-tech-knowledge
   source .venv/bin/activate
   fastapi dev
   ```

Cloud 上に `.env` がなくても `load_dotenv()` はエラーになりません（ファイルが無ければ何もしない）。

### FastAPI Cloud: 環境変数の手順

`.env` はアップロードされないため、**FastAPI Cloud 側に同じ変数名で登録**します。実行時に OS の環境変数として注入され、ローカルと同じコードが動きます。

公式: [Environment Variables（既存プロジェクト移行ガイド内）](https://fastapicloud.com/docs/getting-started/existing-project/#6-set-up-environment-variables)

#### CLI で設定する（推奨）

`fastapi cloud env set` は、ローカルに **`.fastapicloud/` がある（= 少なくとも1回 `fastapi deploy` 済み）** と使えます。初回だけ App が無い状態で `env set` すると `No app found in the folder` になります。

1. ログイン（未実施なら）

   ```bash
   source .venv/bin/activate
   fastapi login
   fastapi cloud whoami
   ```

2. **初回デプロイ**（App 作成と `.fastapicloud/` の生成）

   ```bash
   fastapi deploy
   ```

   詳細は [デプロイ手順](#3-デプロイ) を参照。

3. 変数を登録する（API キーは `--secret`）

   ```bash
   fastapi cloud env set --secret API_KEY "your-secret-key-here"
   fastapi cloud env set RSS_FEED_URLS "https://techfeed.io/feeds/categories/all,https://hnrss.org/frontpage"
   fastapi cloud env set --secret OPENAI_API_KEY "sk-..."
   # 任意
   fastapi cloud env set OPENAI_MODEL "gpt-4o-mini"
   fastapi cloud env set RSS_MAX_PER_FEED "15"
   fastapi cloud env set NEWS_CANDIDATE_MAX "30"
   ```

   変数の意味は [各変数の説明](#各変数の説明) を参照。CLI で env を変えても **自動では再デプロイされない** ため、反映のため次のステップ 4 を実行する。

4. 再デプロイ（環境変数を反映）

   ```bash
   fastapi deploy
   ```

5. 本番 URL で確認する

   ```bash
   curl https://<your-app>.fastapicloud.dev/health
   curl -H "X-API-Key: your-secret-key-here" https://<your-app>.fastapicloud.dev/news
   ```

   ヘッダなしで `/news` を叩くと `401`。`selection_method` が `openai` なら `OPENAI_API_KEY` も有効。`fallback` なら OpenAI 未設定・失敗の可能性があります。

#### ダッシュボードで設定する

1. [FastAPI Cloud](https://fastapicloud.com/) にログインする
2. **初回 `fastapi deploy` 後**にできた対象 App を開く（App が無いときは先にデプロイ）
3. **Environment Variables** で上記と同じ名前を追加する
4. `API_KEY` と `OPENAI_API_KEY` はシークレット扱いで登録する（CLI の `--secret` 相当）
5. 必要なら **Deploy** を再度実行する

ローカルの `.env` と Cloud の環境変数は **名前を揃えるだけ** で同じ動作になります（[一覧](#一覧) 参照）。

## レスポンス例（`GET /news`）

```json
{
  "selection_method": "openai",
  "fetched_count": 25,
  "candidate_count": 25,
  "count": 6,
  "slack_notified": true,
  "articles": [
    {
      "title": "記事タイトル",
      "url": "https://example.com/article",
      "published": "Mon, 31 May 2026 10:00:00 GMT",
      "source": "TechFeed"
    }
  ]
}
```

| フィールド | 意味 |
| --- | --- |
| `fetched_count` | RSS から取得した記事数（各フィード最大 `RSS_MAX_PER_FEED` 件の合計） |
| `candidate_count` | AI に渡した候補数（`min(fetched_count, NEWS_CANDIDATE_MAX)`。OpenAI 未使用時は `fetched_count` と同じ） |
| `count` | 返却する選別後の記事数（例: 候補25件のうち6件） |

## FastAPI Cloud へのデプロイ

公式ドキュメント: [Migrate an Existing Project](https://fastapicloud.com/docs/getting-started/existing-project/) / [Deploy コマンド](https://fastapicloud.com/docs/fastapi-cloud-cli/deploy/)

### FastAPI Cloud のイメージ

ダッシュボード上の **App（アプリ）1つ = API 用の「箱」1つ** と考えると分かりやすいです。

| 概念 | 説明 |
| --- | --- |
| **App** | 専用 URL・環境変数・ログ・デプロイ履歴を持つ単位。今回のニュース API 用に **1 App** を作る |
| **別の API** | 別フォルダ（別 FastAPI プロジェクト）なら **別 App**（別 URL・別環境変数） |
| **デプロイ単位** | **ディレクトリごと**。`fastapi deploy` はカレント（または `[PATH]`）のフォルダをアップロードする |

```
accumulate-tech-knowledge/   ← このディレクトリをデプロイ
├── main.py                  ← ここにある app がエントリポイント
├── news/
├── pyproject.toml
└── .fastapicloud/           ← 初回 deploy 成功後にできる（ローカル ↔ Cloud App の紐づけ、git 管理外）
```

**初回** `fastapi deploy` では、CLI がログイン後に次を聞きます（[公式: First Time Deploying](https://fastapicloud.com/docs/fastapi-cloud-cli/deploy/#first-time-deploying)）。

- チームの選択
- **新規 App を作る** か、既存 App に **リンク** するか

**2 回目以降**、同じディレクトリで `fastapi deploy` すると、`.fastapicloud/` の設定に従い **同じ App のコード更新** になります（箱が増えるわけではない）。

**アップロードされるもの**

- プロジェクトのソース（`main.py`、`news/`、`pyproject.toml` など）
- `.gitignore` に載っているものは送られない（`.env`、`.venv` も含む）
- 本番の秘密情報は Cloud の **Environment Variables** に設定する（[環境変数 › FastAPI Cloud](#fastapi-cloud-環境変数の手順)）

**別プロジェクトをデプロイするとき**

| ローカル | FastAPI Cloud |
| --- | --- |
| `tools/accumulate-tech-knowledge/` | App A（例: ニュース選別 API） |
| 別ディレクトリ `another-api/` | App B（別 URL・別 `RSS_FEED_URLS` など） |

### 1. デプロイ前チェック

- `pyproject.toml` に `fastapi[standard]` が含まれている
- `requires-python` または `.python-version` で Python 版を指定している
- ルートの `main.py` に `app` がある（自動検出対象）

ローカルで次がパスを渡さずに動けば、Cloud でも同じエントリポイントが使われます（venv 有効化後）:

```bash
source .venv/bin/activate
fastapi dev
```

### 2. ログイン

プロジェクト直下で（venv 有効化後）:

```bash
cd tools/accumulate-tech-knowledge
source .venv/bin/activate
fastapi login
```

ブラウザで認証します。ログインできたか確認する場合:

```bash
fastapi cloud whoami
```

表示されたアカウント・Team が意図どおりか見てからデプロイに進みます。

### 3. デプロイ

```bash
fastapi deploy
```

初回は [FastAPI Cloud のイメージ](#fastapi-cloud-のイメージ) のとおり、Team の選択 → 新規 App 作成または既存 App へのリンクを行います。

### 4. 本番の環境変数

初回は **先に `fastapi deploy`（ステップ 3）→ その後 `fastapi cloud env set`（本節）→ もう一度 `fastapi deploy`** の順が安全です。

[環境変数 › FastAPI Cloud](#fastapi-cloud-環境変数の手順) を参照。`RSS_FEED_URLS` が無いと本番の `/news` はエラーになります。

#### トラブル: `No app found in the folder`

`fastapi cloud env set` の前に **`fastapi deploy` を1回以上** 実行してください。`.fastapicloud/` ができれば解消します。App 作成前は、ダッシュボードの Environment Variables も使えません。

## プロジェクト構成

```
accumulate-tech-knowledge/
├── .venv/               # uv sync で作成（git 管理外）
├── .fastapicloud/       # fastapi deploy 後の Cloud 紐づけ（git 管理外）
├── main.py              # FastAPI アプリ・ルート
├── news/
│   ├── __init__.py      # 公開 API
│   ├── models.py        # Article など
│   ├── config.py        # 環境変数（RSS URL・件数上限）
│   ├── auth.py          # /news の API キー検証
│   ├── rss.py           # フィード取得
│   ├── selector.py      # OpenAI 選別
│   ├── slack.py         # Slack DM レポート
│   └── service.py       # pick_top_articles
├── pyproject.toml
├── .python-version
└── README.md
```

DB やバックグラウンドジョブは入れていません。Slack は `GET /news` 実行時に任意で DM 送信します。

## GitHub Actions（毎日 7:00 / 19:00 JST）

リポジトリ直下の [`.github/workflows/accumulate_tech_knowledge_news.yml`](../../.github/workflows/accumulate_tech_knowledge_news.yml) で、本番の `GET /news` を **curl** します（RSS 取得・AI 選別・Slack 通知は FastAPI Cloud 側で実行）。

| 実行時刻（JST） | cron（UTC） |
| --- | --- |
| 7:00 | `0 22 * * *` |
| 19:00 | `0 10 * * *` |

手動実行は Actions タブの **Run workflow** から可能です。

### 登録する GitHub Secrets

**Settings → Secrets and variables → Actions** に次を追加します（値は FastAPI Cloud の `API_KEY` と本番 URL に合わせる）。

| Secret 名 | 内容の例 |
| --- | --- |
| `ACCUMULATE_TECH_KNOWLEDGE_API_KEY` | Cloud の `API_KEY` と同じ文字列 |
| `ACCUMULATE_TECH_KNOWLEDGE_NEWS_URL` | `https://<your-app>.fastapicloud.dev/news`（`/news` まで含める） |

Slack や OpenAI のキーは **Cloud にだけ** 置けばよく、Actions には不要です（Workflow が `/news` を叩くだけ）。

## 新規プロジェクトから作る場合

空ディレクトリなら FastAPI 公式の雛形も使えます:

```bash
uvx fastapi new ai-news-api --template minimal
cd ai-news-api
uv add feedparser httpx openai
# 本リポジトリの main.py / news/ を参考に実装
```
