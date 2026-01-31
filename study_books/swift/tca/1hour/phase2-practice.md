# Phase 2: 実践 - カウンターアプリ

## 学習目標

- TCAを使った実際のアプリケーションを実装する
- State、Action、Reducerを実装する
- ViewとTCAを統合する

## プロジェクトのセットアップ

### 1. 新しいプロジェクトを作成

1. Xcodeで新しいiOS Appプロジェクトを作成
2. プロジェクト名: `CounterApp`
3. Interface: SwiftUI
4. Language: Swift

### 2. TCAを追加

1. File → Add Packages...
2. 以下のURLを入力: `https://github.com/pointfreeco/swift-composable-architecture`
3. Version: 最新の安定版を選択
4. Add to Target: CounterApp

## 実装手順

### Step 1: Stateの定義

`CounterState.swift`を作成します：

```swift
import Foundation

struct CounterState: Equatable {
    var count: Int = 0
}
```

**ポイント**:
- `Equatable`に準拠させることで、Stateの変更を検知できる
- 初期値を設定する

### Step 2: Actionの定義

`CounterAction.swift`を作成します：

```swift
enum CounterAction: Equatable {
    case increment
    case decrement
    case reset
}
```

**ポイント**:
- ユーザーが実行できる操作をActionとして定義
- `Equatable`に準拠させる

### Step 3: Reducerの実装

`CounterReducer.swift`を作成します：

```swift
import ComposableArchitecture

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

**ポイント**:
- `Reducer`は3つの型パラメータを取る: `State`, `Action`, `Environment`
- 今回はEnvironmentは使わないので`Void`を指定
- Actionに応じてStateを更新
- 副作用がない場合は`.none`を返す

### Step 4: Viewの実装

`CounterView.swift`を作成します：

```swift
import SwiftUI
import ComposableArchitecture

struct CounterView: View {
    let store: Store<CounterState, CounterAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(spacing: 20) {
                Text("Count: \(viewStore.count)")
                    .font(.largeTitle)
                    .padding()
                
                HStack(spacing: 20) {
                    Button("-") {
                        viewStore.send(.decrement)
                    }
                    .font(.title)
                    .padding()
                    .background(Color.red.opacity(0.3))
                    .cornerRadius(10)
                    
                    Button("Reset") {
                        viewStore.send(.reset)
                    }
                    .font(.title)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                    
                    Button("+") {
                        viewStore.send(.increment)
                    }
                    .font(.title)
                    .padding()
                    .background(Color.green.opacity(0.3))
                    .cornerRadius(10)
                }
            }
        }
    }
}
```

**ポイント**:
- `Store`をViewに渡す
- `WithViewStore`を使って、StoreからViewStoreを取得
- `viewStore.send()`でActionを送信
- `viewStore.count`でStateを読み取り

### Step 5: Appの統合

`CounterApp.swift`（または`App.swift`）を更新します：

```swift
import SwiftUI
import ComposableArchitecture

@main
struct CounterApp: App {
    var body: some Scene {
        WindowGroup {
            CounterView(
                store: Store(
                    initialState: CounterState(),
                    reducer: counterReducer,
                    environment: ()
                )
            )
        }
    }
}
```

**ポイント**:
- `Store`を作成し、初期状態とReducerを指定
- Environmentは`()`（Void）を指定

## 実行と確認

1. プロジェクトをビルドして実行
2. ボタンをタップして、カウントが正しく増減することを確認
3. Resetボタンでカウントが0にリセットされることを確認

## コードの動作確認

### 動作フロー

1. ユーザーが「+」ボタンをタップ
2. `viewStore.send(.increment)`が呼ばれる
3. Action `.increment`がReducerに送られる
4. Reducerが`state.count += 1`を実行
5. 更新されたStateがViewに反映される
6. 画面に新しいカウントが表示される

## 練習問題

以下の機能を追加してみましょう：

1. **カウントの上限を設定**: カウントが10を超えないようにする
2. **カウントの下限を設定**: カウントが0未満にならないようにする
3. **カウントの色を変更**: カウントが5以上なら赤、それ以下なら青にする

### ヒント

- Stateに新しいプロパティを追加
- Actionに新しいケースを追加
- Reducerで条件分岐を追加
- Viewで条件に応じた表示を追加

## まとめ

このPhaseでは、TCAを使った基本的なアプリケーションを実装しました。

- Stateでアプリケーションの状態を管理
- Actionで状態変更の意図を表現
- Reducerで状態変更のロジックを実装
- Viewでユーザーインターフェースを構築

## 次のステップ

1時間版を完了しました！より深く学びたい場合は、[3時間版](../3hours/README.md)に進んでください。
