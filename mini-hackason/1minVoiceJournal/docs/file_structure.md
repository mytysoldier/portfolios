# 📂 ファイル構成 (File Structure)

```
oneMinVoiceJournal/
├── 1minVoiceJournalApp.swift      // アプリケーションのエントリポイント
├── Models/
│   └── JournalEntry.swift         // SwiftDataで管理するジャーナル記録のデータモデル
├── Services/
│   ├── AudioRecorderService.swift // 録音機能の管理
│   ├── AudioPlayerService.swift   // 音声再生機能の管理
│   └── OpenAIService.swift        // OpenAI API (Whisper, GPT) との通信
├── Views/
│   ├── HomeView.swift             // ホーム画面 (録音と処理進捗の表示)
│   ├── ResultView.swift           // 分析結果の表示と保存
│   ├── LogListView.swift          // ジャーナル記録の一覧表示
│   └── DetailView.swift           // 記録の詳細表示、再生、削除
└── Helpers/
    └── EmotionEmoji.swift         // 感情と絵文字のマッピング
```
