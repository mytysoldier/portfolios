import Foundation
import SwiftData

@Model
final class JournalEntry {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var audioFilePath: String?
    var text: String
    var emotion: String
    var title: String
    var summary: String
    var advice: String

    init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        audioFilePath: String? = nil,
        text: String = "",
        emotion: String = "Neutral",
        title: String = "",
        summary: String = "",
        advice: String = ""
    ) {
        self.id = id
        self.createdAt = createdAt
        self.audioFilePath = audioFilePath
        self.text = text
        self.emotion = emotion
        self.title = title
        self.summary = summary
        self.advice = advice
    }
}

extension JournalEntry {
    struct SampleData {
        static let entries: [JournalEntry] = [
            JournalEntry(
                createdAt: .now.addingTimeInterval(-3600),
                text: "今日はすっきりした気分で散歩した。",
                emotion: "Happy",
                title: "朝の散歩が気持ちいい",
                summary: "朝の散歩で気分が上がった一日。",
                advice: "良かったことを日記に残しておきましょう。"
            ),
            JournalEntry(
                createdAt: .now.addingTimeInterval(-86400),
                text: "仕事のことが気になって少し不安。",
                emotion: "Overwhelmed",
                title: "やることの多さに圧倒",
                summary: "仕事量が多く気が張っている様子。",
                advice: "タスクを小分けにして順番に取り組んでみましょう。"
            )
        ]
    }
}
