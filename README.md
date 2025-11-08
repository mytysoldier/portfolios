# portfolios

このリポジトリは、様々な個人プロジェクトとブログ記事のサンプルコードをまとめたポートフォリオです。

This repository is a portfolio containing various personal projects and sample code from blog articles.

## 📁 ディレクトリ構成 / Directory Structure

### 🤖 ai-apps
AI・機械学習関連のアプリケーションプロジェクト

AI and Machine Learning application projects

- **multi_ai_cooperation** - 複数AIエージェントの協調オーケストレーションシステム（Python, Gemini, Claude, Copilot, WarpCode）
  - 異なるAIエージェントが専門性を活かして協調し、プログラムを自動生成
  - 要件分析、設計、実装、検証、レポート生成の5フェーズで構成
  - 詳細は [multi_ai_cooperation/README.md](ai-apps/multi_ai_cooperation/README.md) を参照

### 📱 mobile-apps
モバイルアプリケーションプロジェクト（主にFlutter）

Mobile application projects (mainly Flutter)

- **calendar-app** - カレンダーアプリ（Flutter + Dart, table_calendar使用）
  - frontend: Flutterフロントエンド
  - backend: バックエンドAPI
- **convenience_store_food_record_app** - コンビニ飯記録アプリ（Flutter, Riverpod, Supabase, Cloudflare R2）
  - コンビニで購入した商品を写真・メモ・金額とともに記録
  - 履歴表示、統計グラフ機能付き
- **national_diet_library_search** - 国会図書館検索アプリ（Flutter）
  - frontend: Flutterアプリ
  - backend: バックエンドAPI
- **ring_fit_record** - リングフィット記録アプリ（Flutter）
  - frontend: Flutterフロントエンド
  - backend: バックエンドAPI
- **volunteer_search** - ボランティア検索アプリ（Flutter）

### 🌐 web-apps
Webアプリケーションプロジェクト

Web application projects

- **habbit_tracker** - 習慣トラッカー（Next.js, React, PostgreSQL, Prisma, react-big-calendar）
  - 日々の習慣を記録・管理するWebアプリ
- **sale_notification** - セール通知アプリ（Next.js, React Native, Hono, Drizzle, PostgreSQL）
  - frontend: Webフロントエンド
  - mobile: モバイルアプリ（React Native + Expo）
  - backend: バックエンドAPI（Hono）
  - 3層構成のフルスタックアプリケーション

### 📝 blog
ブログ記事で紹介したサンプルコードや技術調査

Sample code and technical investigations featured in blog articles

#### database
データベース関連

- **trigger_delete_insert** - トリガーに関するデータベーススクリプト

#### library
ライブラリ関連のサンプル

- **drizzle/db_migration** - Drizzleを使用したDBマイグレーションサンプル

#### operation
運用関連

- **vulnerability_detection** - 脆弱性検出に関するサンプル

#### react
React関連のサンプル

- **gam-sample** - GAM（Google Ad Manager）を使用したReactサンプル
- **plain/error-boundary** - エラーバウンダリーのサンプル

## 🛠️ 主な使用技術 / Main Technologies

- **AI/ML**: Gemini API, OpenAI API, Claude, GitHub Copilot, WarpCode
- **Mobile**: Flutter, Dart, React Native, Expo
- **Frontend**: React, Next.js, TypeScript
- **Backend**: Hono, Node.js, Python
- **Database**: PostgreSQL, Supabase
- **ORM**: Prisma, Drizzle
- **State Management**: Riverpod
- **Storage**: Cloudflare R2, MinIO

## 📄 ライセンス / License

各プロジェクトのライセンスについては、それぞれのディレクトリ内のREADME.mdを参照してください。

Please refer to the README.md in each directory for project-specific licenses.