# TCA 1時間短縮版

この教材では、TCAの基本概念を1時間で学びます。

## 学習目標

- TCAの基本的な概念を理解する
- State、Action、Reducerの役割を理解する
- 簡単なカウンターアプリをTCAで実装できるようになる

## Phase構成

### [Phase 1: TCAの基本概念](./phase1-basics.md)
- TCAとは何か
- なぜTCAを使うのか
- 基本的なアーキテクチャの理解

**所要時間**: 15分

### [Phase 2: 実践 - カウンターアプリ](./phase2-practice.md)
- プロジェクトのセットアップ
- State、Action、Reducerの実装
- Viewとの統合

**所要時間**: 45分

## 学習の進め方

1. [Phase 1: TCAの基本概念](./phase1-basics.md)を読んで理論を理解する
2. [Phase 2: 実践 - カウンターアプリ](./phase2-practice.md)の実践例を実際にコードを書きながら進める
3. 練習問題に取り組む

## 前提知識

- Swiftの基本的な構文
- SwiftUIの基礎知識（View、State、Bindingなど）
- Combineフレームワークの基本的な理解（推奨）

## 必要な環境

- Xcode 14.0以上
- iOS 15.0以上 / macOS 12.0以上
- Swift Package ManagerでTCAを追加

### TCAのインストール方法

1. Xcodeでプロジェクトを開く
2. File → Add Packages...
3. 以下のURLを入力: `https://github.com/pointfreeco/swift-composable-architecture`
4. Version: 最新の安定版を選択
5. Add to Target: 対象のターゲットを選択

または、`Package.swift`に以下を追加：

```swift
dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.0.0")
]
```

## 総所要時間

約1時間（理解度により変動）

## 次のステップ

1時間版を完了したら、より詳細な学習のために[3時間版](../3hours/README.md)に進むことをお勧めします。

---

## 教材情報

- **作成日**: 2026年1月
- **参考情報**:
  - [TCA公式ドキュメント](https://github.com/pointfreeco/swift-composable-architecture)
  - [Point-FreeのTCAシリーズ](https://www.pointfree.co/collections/composable-architecture)
  - [Swift公式ドキュメント](https://www.swift.org/documentation/)
  - [SwiftUI公式ドキュメント](https://developer.apple.com/xcode/swiftui/)
