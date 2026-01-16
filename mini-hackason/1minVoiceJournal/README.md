# 1min Voice Journal

## 💡 概要 (Overview)
「1min Voice Journal」は、1分間の音声入力で日々の感情を手軽に記録・分析できるiOSアプリケーションです。日々の心の状態を把握し、自己理解を深めたい と考える方々を対象としています。録音された音声はOpenAI Whisperによってテキストに変換され、GPTを活用した感情分析により、その日の感情に基づいたタイトル、要約、そしてパーソナライズされたアドバイスが生成されます。全ての記録データはSwiftDataを用いてデバイス内に安全に保存され、ユーザーは自由に記録を閲覧、再生、管理できます。

## 📱 主な機能

- **音声録音機能**: 1分以内の音声を録音し、安全に保存します。
- **AIによる音声分析**: 録音された音声をAIが自動で文字起こしし、感情を分析します。
- **感情分析結果の生成**: 感情分析に基づき、タイトル、要約、アドバイスを生成します。
- **ジャーナル記録の管理**: 記録されたジャーナルは永続的に保存され、一覧表示、詳細確認、再生、削除が可能です。
- **音声プレビュー機能**: 記録された音声のプレビューと再生が可能です。

## 📋 機能仕様

詳細な機能仕様については、以下のドキュメントをご参照ください:

- [AI仕様](docs/ai_specification.md)
- [画面仕様](docs/screen_specification.md)
- [技術スタック](docs/technical_stack.md)
- [ファイル構成](docs/file_structure.md)

## 🔧 セットアップ（Secrets）

`xcconfig` 経由で API 設定を読み込みます。実値は Git 管理しません。

1. `oneMinVoiceJournal/Config/Secrets.example.xcconfig` を `oneMinVoiceJournal/Config/Secrets.xcconfig` にコピー
2. `Secrets.xcconfig` に実値を設定
   - `API_BASE_URL` は `https:$(SLASH)$(SLASH)...` の形式で設定
   - 例:
     ```xcconfig
     API_BASE_URL = https:$(SLASH)$(SLASH)example.supabase.co/functions/v1
     APP_CLIENT_KEY = YOUR_APP_CLIENT_KEY
     SUPABASE_ANON_KEY = YOUR_SUPABASE_ANON_KEY
     ```

`Secrets.xcconfig` は `.gitignore` で除外済みです。

## 🖼 スクリーンショット（App Store用）

App Store Connect が受け付ける iPhone スクリーンショットは以下のサイズです。

- 1242 × 2688（iPhone 11 Pro Max / XS Max）
- 1284 × 2778（iPhone 12/13/14 Pro Max）

手元のスクリーンショットが別サイズ（例: 1290 × 2796）の場合は、以下のコマンドで変換できます。

```bash
sips -z 2778 1284 /path/to/home.png --out /path/to/home-1284x2778.png
```

1242 × 2688 に変換する場合:

```bash
sips -z 2688 1242 /path/to/home.png --out /path/to/home-1242x2688.png
```
