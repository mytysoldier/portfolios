# AI Vision Static Site Generator (Multi-Page)

OpenAIのGPT-4o (Vision) を活用し、**画像とテキスト指示**から「見たまま」かつ「要望通り」のマルチページWebサイトを自動生成するツールです。

## 特徴 (Features)
- **📷 ビジュアル駆動開発**: デザインカンプや素材画像のディレクトリを読み込ませることで、その雰囲気（色味、レイアウト、トーン）を忠実に再現したサイトを生成します。
- **📑 マルチページ自動生成**: Home, About, Contactなど、一般的なサイト構成をAIが企画し、一括でコーディングします。ページ間のリンクも自動で繋がります。
- **📝 日本語コンテンツ**: キャッチコピーから本文まで、自然な日本語でライティングを行います。
- **🧠 アダプティブな複雑性**: 簡単な指示ならシンプルに（1-3ページ）、詳細な指示なら複雑に（5ページ以上）と、AIが規模感を自動調整します。
- **⚡️ 高速＆軽量**: 生成されたサイトは静的なHTML/TailwindCSSのみ。Reactなどの重いフレームワークを使わず、そのままサーバーに置いて即公開できます。

## 必要条件 (Prerequisites)
- Python 3.8+
- OpenAI API Key (`gpt-4o` へのアクセス権限が必要)

## セットアップ (Setup)

1. **環境変数の設定**
   プロジェクトルートに `.env` ファイルを作成し、APIキーを設定してください。
   ```bash
   OPENAI_API_KEY=sk-proj-...
   ```

2. **依存ライブラリのインストール**
   仮想環境の使用を推奨します。
   ```bash
   python -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   ```

## 使い方 (Usage)

### 1. 画像を使って生成する場合 (推奨)
素材画像が入ったディレクトリを指定して実行します。
```bash
python main.py --image path/to/images_dir/
```
実行後、プロンプト入力待ちになります。「カフェのサイトを作って」「ポートフォリオを作って」などの要望を入力してください（複数行貼り付けOK、空行で確定）。

### 2. 画像なしで生成する場合
画像引数なしで実行します。AIがプレースホルダー画像を使用してレイアウトを作成します。
```bash
python main.py
```

## 生成物 (Output)
`generated/outputX/` ディレクトリに生成されます。
- `index.html`, `about.html` などのHTMLファイル
- `assets/` (使用した画像のコピー)

## ドキュメント (Docs)
より高品質なサイトを作るためのヒントを `docs/` ディレクトリにまとめています。
- `docs/samplePrompt.md`: サイト作成指示のプロンプト例（日本語）
- `docs/sampleImagePrompt.md`: 素材画像を生成するためのプロンプト例（nanobanana用）
