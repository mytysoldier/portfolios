# TCA 3時間みっちり版

この教材では、TCAを深く理解し、実践的なアプリケーションを構築できるようになることを目指します。

## 学習目標

- TCAの理論的背景を深く理解する
- State、Action、Reducerを完全に理解する
- Effect（副作用）の扱い方を学ぶ
- 複雑な状態管理を実装できるようになる
- TCAを使ったテストを書けるようになる
- 実践的なアプリケーションを構築できるようになる

## Phase構成

### [Phase 1: TCAの理論と基本概念](./phase1-theory.md)
- TCAの設計思想
- 関数型プログラミングの基礎
- State、Action、Reducerの詳細

**所要時間**: 30分

### [Phase 2: 基本的な実践 - Todoアプリ](./phase2-todo-app.md)
- プロジェクトのセットアップ
- リスト表示と追加機能
- 削除と編集機能

**所要時間**: 45分

### [Phase 3: 複雑な状態管理](./phase3-complex-state.md)
- ネストしたState
- Reducerの合成
- 親子関係の管理

**所要時間**: 40分

### [Phase 4: Effect（副作用）の扱い](./phase4-effects.md)
- Effectとは何か
- 非同期処理
- API呼び出し
- タイマーとスケジューラー

**所要時間**: 50分

### [Phase 5: テスト](./phase5-testing.md)
- Reducerのテスト
- Effectのテスト
- 統合テスト

**所要時間**: 30分

### [Phase 6: 実践的なアプリケーション構築](./phase6-practical-app.md)
- 複数の機能を組み合わせる
- ナビゲーション
- エラーハンドリング
- パフォーマンス最適化

**所要時間**: 45分

## 学習の進め方

1. 各Phaseを順番に進める
2. 理論を読んだら、すぐに実践例を試す
3. 練習問題に必ず取り組む
4. 理解が不十分な場合は、前のPhaseに戻る

## 前提知識

- Swiftの基本的な構文
- SwiftUIの基礎知識（View、State、Bindingなど）
- Combineフレームワークの基本的な理解（推奨）
- 非同期処理（async/await）の基本的な理解（Phase 4以降）

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

約3.5-4時間（理解度により変動）

## 次のステップ

3時間版を完了したら、実際のプロジェクトでTCAを活用してみましょう。さらに学びたい場合は、以下のリソースを参照してください：

- [TCA公式ドキュメント](https://github.com/pointfreeco/swift-composable-architecture)
- [Point-FreeのTCAシリーズ](https://www.pointfree.co/collections/composable-architecture)
- [TCAのサンプルプロジェクト](https://github.com/pointfreeco/swift-composable-architecture/tree/main/Examples)

---

## 教材情報

- **作成日**: 2026年1月
- **参考情報**:
  - [TCA公式ドキュメント](https://github.com/pointfreeco/swift-composable-architecture)
  - [Point-FreeのTCAシリーズ](https://www.pointfree.co/collections/composable-architecture)
  - [Swift公式ドキュメント](https://www.swift.org/documentation/)
  - [SwiftUI公式ドキュメント](https://developer.apple.com/xcode/swiftui/)
