import WidgetKit
import SwiftUI

struct JournalWidgetEntry: TimelineEntry {
    let date: Date
    let title: String
    let message: String
}

struct JournalWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> JournalWidgetEntry {
        JournalWidgetEntry(date: .now, title: "ボイス日記", message: "1分だけ話してみましょう")
    }

    func getSnapshot(in context: Context, completion: @escaping (JournalWidgetEntry) -> Void) {
        completion(placeholder(in: context))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<JournalWidgetEntry>) -> Void) {
        let entries = [
            JournalWidgetEntry(date: .now, title: "今日の気持ちは？", message: "1分ボイス日記を始めましょう"),
            JournalWidgetEntry(date: .now.addingTimeInterval(60 * 60), title: "小さな気づきをメモ", message: "声に出すと整理できます")
        ]
        completion(Timeline(entries: entries, policy: .after(Date().addingTimeInterval(60 * 60))))
    }
}

struct JournalWidgetEntryView: View {
    var entry: JournalWidgetProvider.Entry

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.purple.opacity(0.7), Color.blue.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.title)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(entry.message)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
            }
            .padding()
        }
    }
}

@main
struct JournalWidgetBundle: WidgetBundle {
    var body: some Widget {
        JournalWidget()
    }
}

struct JournalWidget: Widget {
    let kind: String = "JournalWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: JournalWidgetProvider()) { entry in
            JournalWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("1min Voice Journal")
        .description("1分ボイス日記のリマインダーウィジェット")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular])
    }
}

#Preview(as: .systemSmall) {
    JournalWidget()
} timeline: {
    JournalWidgetEntry(date: .now, title: "プレビュー", message: "1分だけ話してみましょう")
}
