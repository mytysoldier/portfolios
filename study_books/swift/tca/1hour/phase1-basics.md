# Phase 1: TCAの基本概念

## 学習目標

- TCAの目的と利点を理解する
- TCAの基本的なアーキテクチャパターンを理解する
- State、Action、Reducerの役割を理解する

## TCAとは

**The Composable Architecture (TCA)** は、Point-Freeが開発したSwiftUIアプリケーションのためのアーキテクチャパターンです。

### なぜTCAを使うのか？

1. **予測可能な状態管理**: すべての状態変更が一方向のデータフローで管理される
2. **テスタビリティ**: ビジネスロジックをViewから分離し、簡単にテストできる
3. **再利用性**: Reducerを組み合わせて複雑な機能を構築できる
4. **デバッグの容易さ**: すべてのActionとStateの変更を追跡できる

## TCAの基本構造

TCAは3つの主要なコンポーネントで構成されます：

```
┌─────────┐
│  View   │ ← ユーザーインターフェース
└────┬────┘
     │ Action
     ↓
┌─────────┐
│ Reducer │ ← ビジネスロジック
└────┬────┘
     │ State
     ↓
┌─────────┐
│  State  │ ← アプリケーションの状態
└─────────┘
```

### 1. State（状態）

アプリケーションの現在の状態を表す構造体です。

```swift
struct CounterState: Equatable {
    var count: Int = 0
}
```

### 2. Action（アクション）

状態を変更するための意図を表す列挙型です。

```swift
enum CounterAction: Equatable {
    case increment
    case decrement
    case reset
}
```

### 3. Reducer（リデューサー）

Actionを受け取り、現在のStateを新しいStateに変換する純粋関数です。

```swift
let counterReducer = Reducer<CounterState, CounterAction, Void> { state, action, _ in
    switch action {
    case .increment:
        state.count += 1
        return .none
    case .decrement:
        state.count -= 1
        return .none
    case .reset:
        state.count = 0
        return .none
    }
}
```

## データフロー

1. **ユーザーがViewで操作** → Actionが発生
2. **ActionがReducerに送られる** → ReducerがStateを更新
3. **更新されたStateがViewに反映** → UIが更新される

この一方向のデータフローにより、状態管理が予測可能になります。

## 重要な原則

### 1. 単一の真実の源（Single Source of Truth）

すべての状態はStateに集約され、ViewはStateを読み取るだけです。

### 2. 純粋関数（Pure Functions）

Reducerは副作用を持たない純粋関数です。同じ入力に対して常に同じ出力を返します。

### 3. コンポーザビリティ（Composability）

小さなReducerを組み合わせて、より大きなReducerを作成できます。

## まとめ

- TCAは予測可能でテスト可能な状態管理を提供する
- State、Action、Reducerの3つのコンポーネントで構成される
- 一方向のデータフローにより、状態管理がシンプルになる

## 次のステップ

[Phase 2](./phase2-practice.md)では、実際にカウンターアプリを実装して、これらの概念を実践的に学びます。
