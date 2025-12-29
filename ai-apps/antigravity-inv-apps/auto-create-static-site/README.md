# AI Vision Static Site Generator

OpenAIのGPT-4o (Vision) を活用し、**画像とテキスト指示**からWebサイトを自動生成するツールです。

## 特徴 (Features)
- **📷 画像からのサイト生成**: 指定した画像フォルダの素材を使って、その雰囲気に合わせたデザインやコンテンツを作成します。
- **📑 マルチページ生成**: 複数のページ（Home, Menu, Aboutなど）を一度に生成し、ページ間のリンクも自動で繋ぎます。
- **📝 日本語テキスト**: サイト内の文章はAIが自然な日本語で作成します。
- **⚡️ 静的HTML出力**: HTMLファイルとTailwindCSSで構成された、シンプルで軽量なサイトを出力します。

## 必要条件 (Prerequisites)
- Python 3.8+
- OpenAI API Key

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
- `docs/architecture.md`: システム構成図 (Mermaid)
