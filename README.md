# portfolios

このリポジトリは、様々な個人プロジェクトとブログ記事のサンプルコードをまとめたポートフォリオです。

This repository is a portfolio containing various personal projects and sample code from blog articles.

## 📁 ディレクトリ構成 / Directory Structure

### 📱 mobile-apps
モバイルアプリケーションプロジェクト（主にFlutter）

Mobile application projects (mainly Flutter)

- **calendar-app** - カレンダーアプリ（Flutter + Dart, table_calendar使用）
- **convenience_store_food_record_app** - コンビニ飯記録アプリ（Flutter, Riverpod, Supabase, Cloudflare R2）
  - コンビニで購入した商品を写真・メモ・金額とともに記録
  - 履歴表示、統計グラフ機能付き
- **national_diet_library_search** - 国会図書館検索アプリ（Flutter）
- **ring_fit_record** - リングフィット記録アプリ（Flutter）
- **volunteer_search** - ボランティア検索アプリ（Flutter）

### 🌐 web-apps
Webアプリケーションプロジェクト

Web application projects

- **habbit_tracker** - 習慣トラッカー（Next.js, React, PostgreSQL, Prisma, react-big-calendar）
  - 日々の習慣を記録・管理するWebアプリ
- **sale_notification** - セール通知アプリ（Next.js, React Native, Hono, Drizzle, PostgreSQL）
  - フロントエンド（Web）、モバイル、バックエンドの3層構成

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

- **Mobile**: Flutter, Dart, React Native, Expo
- **Frontend**: React, Next.js, TypeScript
- **Backend**: Hono, Node.js
- **Database**: PostgreSQL, Supabase
- **ORM**: Prisma, Drizzle
- **State Management**: Riverpod
- **Storage**: Cloudflare R2, MinIO

## 📄 ライセンス / License

各プロジェクトのライセンスについては、それぞれのディレクトリ内のREADME.mdを参照してください。

Please refer to the README.md in each directory for project-specific licenses.