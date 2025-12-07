# Firebase App Distribution 配布ガイド

Flutter 製コンビニ飯記録アプリを Firebase App Distribution（以下 FAD）経由で配布するための手順です。  
Android/iOS の両方をサポートする想定でまとめています。

---

## 1. 事前準備

| 項目 | 内容 |
| --- | --- |
| Firebase プロジェクト | 任意の GCP プロジェクトで OK。例: `convenience-store-food-record` |
| CLI | `npm install -g firebase-tools` でインストール |
| Flutter | 安定版（3.x 以上）をローカル・CI ともにインストール |
| Apple Developer Program | iOS の署名用に必須 |

### このリポジトリで登録すべきアプリ ID

| Platform | Identifier | ファイル出典 |
| --- | --- | --- |
| Android | `com.mytysoldier.convenience_store_food_record_app` | `android/app/build.gradle.kts` |
| iOS | `com.mytysoldier.convenienceStoreFoodRecordApp` | `ios/Runner.xcodeproj/project.pbxproj` |

Firebase コンソール > [プロジェクト設定] で上記 ID を持つアプリを作成し、それぞれのアプリ ID（例: `1:1234567890:android:abcd1234` / `1:1234567890:ios:efgh5678`）をメモしておきます。

---

## 2. Firebase CLI のセットアップ

```bash
npm install -g firebase-tools
firebase login
firebase use <PROJECT_ID>
```

- CI から配布する場合は `firebase login:ci` でトークンを発行し、`FIREBASE_TOKEN` として保管します。
- ルートに `.firebaserc` を置いておくと `firebase use` の結果を共有できます（例: `{ "projects": { "default": "convenience-store-food-record" } }`）。

---

## 3. Android 版の配布

### 3-1. リリース署名の設定
1. `keytool` でリリース keystore を生成し、`android/app/release.keystore` などに配置。
2. `android/key.properties` を追加。
   ```properties
   storeFile=../app/release.keystore
   storePassword=*****
   keyAlias=upload
   keyPassword=*****
   ```
3. `android/app/build.gradle.kts` の `buildTypes.release` で上記 keystore を読むように修正。

### 3-2. ビルド
```bash
flutter build appbundle --release
# 成果物: build/app/outputs/bundle/release/app-release.aab
```

### 3-3. Firebase App Distribution へアップロード
```bash
firebase appdistribution:distribute \
  build/app/outputs/bundle/release/app-release.aab \
  --app 1:XXXXXXXXXXXX:android:YYYYYYYY \
  --groups internal-testers \
  --release-notes "支出グラフの表示を修正"
```

- `--groups` は事前に FAD のテスターグループを作成しておきます。
- 単発でメールを指定したい場合は `--testers foo@example.com,bar@example.com`。
- `firebase appdistribution:testers:add --project <PROJECT_ID> foo@example.com` で新規テスターを登録できます。

---

## 4. iOS 版の配布

### 4-1. 署名 & ビルド
```bash
flutter build ipa --release \
  --export-options-plist=ios/Runner/ExportOptions.plist
# 成果物: build/ios/ipa/Runner.ipa
```

- Xcode で `Runner.xcworkspace` を開き、`Signing & Capabilities` に Apple ID / プロビジョニングプロファイルを設定しておくこと。
- CI では `xcodebuild -exportOptionsPlist` 用の plist（Ad Hoc など）を `ios/Runner/ExportOptions.plist` として管理すると再現性が高いです。

### 4-2. アップロード
```bash
firebase appdistribution:distribute \
  build/ios/ipa/Runner.ipa \
  --app 1:XXXXXXXXXXXX:ios:ZZZZZZZZ \
  --groups internal-testers \
  --release-notes "iOS 17 でのレイアウト崩れを修正"
```

---

## 5. `firebase.json` でよく使う設定例

```json
{
  "appdistribution": {
    "apkFilePath": "build/app/outputs/bundle/release/app-release.aab",
    "ipaFilePath": "build/ios/ipa/Runner.ipa",
    "releaseNotesFile": "docs/release-notes/latest.txt",
    "groups": ["internal-testers"]
  }
}
```

この設定を置くと `firebase appdistribution:distribute` だけで直近の成果物が配信されます。ビルドごとに `release-notes/latest.txt` を更新すると履歴管理もしやすくなります。

---

## 6. GitHub Actions 例

`.github/workflows/distribute.yml`

```yaml
name: Distribute (Firebase)

on:
  workflow_dispatch:
    inputs:
      platform:
        type: choice
        options: [android, ios]

jobs:
  build:
    runs-on: macos-14
    env:
      FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: "stable"
      - run: flutter pub get
      - if: inputs.platform == 'android'
        run: |
          flutter build appbundle --release
          firebase appdistribution:distribute \
            build/app/outputs/bundle/release/app-release.aab \
            --app ${{ secrets.FAD_ANDROID_APP_ID }} \
            --groups internal-testers
      - if: inputs.platform == 'ios'
        run: |
          flutter build ipa --release --export-options-plist=ios/Runner/ExportOptions.plist
          firebase appdistribution:distribute \
            build/ios/ipa/Runner.ipa \
            --app ${{ secrets.FAD_IOS_APP_ID }} \
            --groups internal-testers
```

Secrets には以下を登録します。
- `FIREBASE_TOKEN`: `firebase login:ci` で取得したトークン
- `FAD_ANDROID_APP_ID` / `FAD_IOS_APP_ID`: Firebase コンソールで表示されるアプリ ID
- 署名関連（`ANDROID_KEYSTORE_BASE64`, `MATCH_PASSWORD` など）はプロジェクトの運用ルールに合わせて追加

---

## 7. トラブルシューティング

- **アプリ ID が一致しない**: Firebase 側のアプリ ID（`com...`）と Flutter プロジェクトでビルドされる ID が一致しているかを `android/app/build.gradle.kts` / `ios/Runner.xcodeproj/project.pbxproj` で確認。
- **`Missing release notes`**: `--release-notes` or `--release-notes-file` のどちらかを必ず指定。
- **`Permission denied`**: Firebase CLI の `FIREBASE_TOKEN` が App Distribution へアクセスできるロール（`Firebase App Distribution Admin` など）を持っているか確認。
- **iOS でビルドが失敗**: CocoaPods 依存がずれている可能性があるため `cd ios && pod repo update && pod install --repo-update` を実行。

---

これでローカル／CI のどちらからでも Firebase App Distribution にリリースできるようになります。テスターへの通知内容は Firebase コンソールからも編集できるので、最初はコンソールで動作確認し、慣れてきたら CLI / CI による自動化へ移行すると安全です。

