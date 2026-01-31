# Phase 2: 基本的な実践 - Todoアプリ

## 学習目標

- TCAを使った実践的なアプリケーションを実装する
- リスト表示とCRUD操作を実装する
- State、Action、Reducerの実装パターンを学ぶ

## プロジェクトのセットアップ

### 1. 新しいプロジェクトを作成

1. Xcodeで新しいiOS Appプロジェクトを作成
2. プロジェクト名: `TodoApp`
3. Interface: SwiftUI
4. Language: Swift

### 2. TCAを追加

1. File → Add Packages...
2. URL: `https://github.com/pointfreeco/swift-composable-architecture`
3. 最新の安定版を選択

## 実装手順

### Step 1: モデルの定義

`Todo.swift`を作成します：

```swift
import Foundation

struct Todo: Equatable, Identifiable {
    let id: UUID
    var description: String
    var isComplete: Bool
    
    init(id: UUID = UUID(), description: String, isComplete: Bool = false) {
        self.id = id
        self.description = description
        self.isComplete = isComplete
    }
}
```

### Step 2: Stateの定義

`TodoState.swift`を作成します：

```swift
import Foundation

struct TodoState: Equatable {
    var todos: [Todo] = []
    var newTodoDescription: String = ""
}
```

**ポイント**:
- `todos`: Todoアイテムのリスト
- `newTodoDescription`: 新しいTodoを入力するためのテキスト

### Step 3: Actionの定義

`TodoAction.swift`を作成します：

```swift
enum TodoAction: Equatable {
    case addTodo
    case deleteTodo(IndexSet)
    case toggleTodo(id: UUID)
    case updateNewTodoDescription(String)
    case moveTodo(from: IndexSet, to: Int)
}
```

**ポイント**:
- 各操作に対応するActionを定義
- 関連データ（ID、テキストなど）を含める

### Step 4: Reducerの実装

`TodoReducer.swift`を作成します：

```swift
import ComposableArchitecture

let todoReducer = Reducer<TodoState, TodoAction, Void> { state, action, _ in
    switch action {
    case .addTodo:
        guard !state.newTodoDescription.isEmpty else {
            return .none
        }
        let newTodo = Todo(description: state.newTodoDescription)
        state.todos.append(newTodo)
        state.newTodoDescription = ""
        return .none
        
    case .deleteTodo(let indexSet):
        state.todos.remove(atOffsets: indexSet)
        return .none
        
    case .toggleTodo(let id):
        if let index = state.todos.firstIndex(where: { $0.id == id }) {
            state.todos[index].isComplete.toggle()
        }
        return .none
        
    case .updateNewTodoDescription(let description):
        state.newTodoDescription = description
        return .none
        
    case .moveTodo(let from, let to):
        state.todos.move(fromOffsets: from, toOffset: to)
        return .none
    }
}
```

**ポイント**:
- 各Actionに対応する処理を実装
- Stateを直接変更（TCAが内部的に処理）
- バリデーション（空文字チェックなど）もReducerで行う

### Step 5: Viewの実装

`TodoView.swift`を作成します：

```swift
import SwiftUI
import ComposableArchitecture

struct TodoView: View {
    let store: Store<TodoState, TodoAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack {
                    // 新しいTodoを追加する入力欄
                    HStack {
                        TextField(
                            "新しいTodoを入力",
                            text: viewStore.binding(
                                get: { $0.newTodoDescription },
                                send: TodoAction.updateNewTodoDescription
                            )
                        )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button("追加") {
                            viewStore.send(.addTodo)
                        }
                        .disabled(viewStore.newTodoDescription.isEmpty)
                    }
                    .padding()
                    
                    // Todoリスト
                    List {
                        ForEach(viewStore.todos) { todo in
                            HStack {
                                Button(action: {
                                    viewStore.send(.toggleTodo(id: todo.id))
                                }) {
                                    Image(systemName: todo.isComplete ? "checkmark.square" : "square")
                                        .foregroundColor(todo.isComplete ? .green : .gray)
                                }
                                
                                Text(todo.description)
                                    .strikethrough(todo.isComplete)
                                    .foregroundColor(todo.isComplete ? .gray : .primary)
                            }
                        }
                        .onDelete { indexSet in
                            viewStore.send(.deleteTodo(indexSet))
                        }
                        .onMove { from, to in
                            viewStore.send(.moveTodo(from: from, to: to))
                        }
                    }
                }
                .navigationTitle("Todoリスト")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
            }
        }
    }
}
```

**ポイント**:
- `viewStore.binding`で双方向バインディングを作成
- `ForEach`でリストを表示
- `onDelete`と`onMove`でスワイプ削除と並び替えを実装

### Step 6: Appの統合

`TodoApp.swift`を更新します：

```swift
import SwiftUI
import ComposableArchitecture

@main
struct TodoApp: App {
    var body: some Scene {
        WindowGroup {
            TodoView(
                store: Store(
                    initialState: TodoState(),
                    reducer: todoReducer,
                    environment: ()
                )
            )
        }
    }
}
```

## 実行と確認

1. プロジェクトをビルドして実行
2. 新しいTodoを追加できることを確認
3. Todoをタップして完了状態を切り替えられることを確認
4. スワイプで削除できることを確認
5. 並び替えができることを確認

## コードの動作確認

### データフローの例：Todoを追加する場合

1. ユーザーがテキストフィールドに入力
   - `updateNewTodoDescription` Actionが送信される
   - Stateの`newTodoDescription`が更新される

2. ユーザーが「追加」ボタンをタップ
   - `addTodo` Actionが送信される
   - Reducerが新しいTodoを作成してリストに追加
   - `newTodoDescription`がクリアされる

3. Viewが更新される
   - 新しいTodoがリストに表示される

## 練習問題

以下の機能を追加してみましょう：

### 1. フィルタリング機能

完了済みと未完了のTodoをフィルタリングできるようにする。

**ヒント**:
- Stateに`filter: FilterType`を追加
- `FilterType` enumを作成（`all`, `active`, `completed`）
- Actionに`setFilter(FilterType)`を追加
- ViewでフィルタリングUIを追加

### 2. 編集機能

既存のTodoを編集できるようにする。

**ヒント**:
- Stateに`editingTodoId: UUID?`を追加
- Actionに`startEditing(UUID)`と`updateTodo(id: UUID, description: String)`を追加
- Viewで編集モードを実装

### 3. 統計表示

完了済みと未完了のTodoの数を表示する。

**ヒント**:
- Viewで`viewStore.todos`をフィルタリングして計算
- または、Stateに`stats: TodoStats`を追加してReducerで計算

## まとめ

このPhaseでは、TCAを使った実践的なTodoアプリを実装しました。

- リスト表示とCRUD操作の実装方法
- State、Action、Reducerの実装パターン
- ViewとTCAの統合方法
- 双方向バインディングの使い方

## 次のステップ

[Phase 3](./phase3-complex-state.md)では、より複雑な状態管理を学びます。
