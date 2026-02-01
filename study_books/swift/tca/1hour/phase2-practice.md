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

### 3. ディレクトリ構成

TCAのベストプラクティスに基づいた推奨ディレクトリ構成は以下の通りです：

```
CounterApp/
├── CounterApp/
│   ├── App.swift                    # アプリのエントリーポイント
│   └── Features/                    # 機能ごとにフォルダを分ける
│       └── Counter/                 # Counter機能
│           ├── CounterView.swift     # View
│           ├── CounterState.swift   # State
│           ├── CounterAction.swift  # Action
│           └── CounterReducer.swift  # Reducer
```

**構成のポイント**:
- `Features/`フォルダで機能ごとに整理
- 各機能（Counter）を独立したフォルダに配置
- State、Action、Reducer、Viewを同じフォルダに配置して関連性を明確化
- 将来的に機能が増えても拡張しやすい構造

**注意**: この構成は推奨ですが、プロジェクトの規模やチームの方針に応じて調整してください。小規模なプロジェクトの場合は、`Features/`フォルダを省略して直接`Counter/`フォルダを作成しても問題ありません。

## 実装手順

以下の手順で、上記のディレクトリ構成に従ってファイルを作成していきます。

### Step 1: ディレクトリとStateの定義

まず、`Features/Counter/`フォルダを作成し、その中に`CounterState.swift`を作成します：

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

`Features/Counter/CounterAction.swift`を作成します：

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

`Features/Counter/CounterReducer.swift`を作成します：

```swift
import ComposableArchitecture

struct CounterReducer: Reducer {
    typealias State = CounterState
    typealias Action = CounterAction
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
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
}
```

**ポイント**:
- `struct CounterReducer: Reducer`でReducerプロトコルに準拠
- `typealias`を使って、別ファイルで定義した`CounterState`と`CounterAction`を参照
  - `typealias State = CounterState`で、Reducer内の`State`が`CounterState`を指すように定義
  - `typealias Action = CounterAction`で、Reducer内の`Action`が`CounterAction`を指すように定義
- `reduce(into:action:)`メソッドで状態を更新
- `inout`キーワードでStateを参照渡し（関数内で直接変更可能、パフォーマンスが良い）
- 戻り値は`Effect<Action>`型で、副作用がない場合は`.none`を返す
  - `Effect`は非同期処理やAPI呼び出しなどの副作用を表す型（今回は使用しない）

### Step 4: Viewの実装

`Features/Counter/CounterView.swift`を作成します：

```swift
import SwiftUI
import ComposableArchitecture

struct CounterView: View {
    let store: StoreOf<CounterReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
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

#Preview {
    CounterView(
        store: Store(initialState: CounterState()) {
            CounterReducer()
        }
    )
}
```

**ポイント**:
- `StoreOf<CounterReducer>`を使用（Reducerから自動的にStateとActionの型を推論）
- `WithViewStore`の`observe`パラメータで、どの部分のStateを観察するかを指定
- `observe: { $0 }`でState全体を観察
- `viewStore.send()`でActionを送信
- `viewStore.count`でStateを読み取り
- `#Preview`でXcodeのプレビュー機能を使用可能（Xcode 15以降）
  - プレビューでViewの見た目を確認しながら開発できる
  - Storeを作成してCounterViewに渡す

### Step 5: Appの統合

プロジェクトのルートにある`CounterApp.swift`（または`App.swift`）を更新します：

**ファイル構成の確認**:
```
CounterApp/
├── CounterApp/
│   ├── App.swift                    ← ここを更新
│   └── Features/
│       └── Counter/
│           ├── CounterView.swift
│           ├── CounterState.swift
│           ├── CounterAction.swift
│           └── CounterReducer.swift
```

```swift
import SwiftUI
import ComposableArchitecture

@main
struct CounterApp: App {
    var body: some Scene {
        WindowGroup {
            CounterView(
                store: Store(initialState: CounterState()) {
                    CounterReducer()
                }
            )
        }
    }
}
```

**ポイント**:
- `Store(initialState:reducer:)`でStoreを作成
- 初期状態として`CounterState()`を指定
- Reducerとして`CounterReducer()`のインスタンスを指定
- 新しいAPIでは、Environmentパラメータは不要（必要に応じてReducer内で定義）

## 完成したプロジェクト構成

実装が完了すると、以下のようなディレクトリ構成になります：

```
CounterApp/
├── CounterApp/
│   ├── App.swift                    ✅ 完成
│   └── Features/
│       └── Counter/
│           ├── CounterView.swift     ✅ 完成
│           ├── CounterState.swift   ✅ 完成
│           ├── CounterAction.swift  ✅ 完成
│           └── CounterReducer.swift ✅ 完成
└── CounterApp.xcodeproj/
```

この構成により、以下のメリットが得られます：
- **機能の独立性**: Counter機能が独立したフォルダにまとまっている
- **拡張性**: 新しい機能（例: Todo機能）を追加する際は、`Features/Todo/`フォルダを作成するだけ
- **保守性**: 関連するファイルが同じ場所にあるため、見つけやすく修正しやすい
- **スケーラビリティ**: プロジェクトが大きくなっても構造が明確

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
