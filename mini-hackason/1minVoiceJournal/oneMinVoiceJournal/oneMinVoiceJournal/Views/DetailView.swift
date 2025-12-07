import SwiftUI
import SwiftData

struct DetailView: View {
    let entry: JournalEntry
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: DetailViewModel
    @StateObject private var playerService = AudioPlayerService()
    @State private var showingPlaybackError = false
    @State private var playbackErrorMessage: String?
    @State private var showingDeleteConfirm = false
    @State private var deleteError: String?

    init(entry: JournalEntry, modelContext: ModelContext) {
        self.entry = entry
        _viewModel = StateObject(wrappedValue: DetailViewModel(entry: entry, modelContext: modelContext))
    }

    private var audioURL: URL? {
        viewModel.audioURL
    }

    private var playbackButtonTitle: String {
        if case .playing = playerService.state {
            return "再生を一時停止"
        } else if case .idle = playerService.state {
            return audioURL == nil ? "音声がありません" : "音声を再生"
        } else {
            return "音声を再生"
        }
    }

    private var playbackButtonIcon: String {
        if case .playing = playerService.state {
            return "pause.circle"
        } else {
            return "play.circle"
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                headerSection
                summarySection
                adviceSection
                transcriptSection
                if audioURL != nil {
                    progressSection
                    playbackButton
                } else {
                    Text("音声ファイルが見つかりません。")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("詳細")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive) {
                    showingDeleteConfirm = true
                } label: {
                    Label("ログを削除", systemImage: "trash")
                }
            }
        }
        .alert("再生できません", isPresented: $showingPlaybackError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(playbackErrorMessage ?? "音声ファイルの読み込みに失敗しました。")
        }
        .alert("削除に失敗しました", isPresented: Binding<Bool>(
            get: { deleteError != nil },
            set: { newValue in
                if !newValue { deleteError = nil }
            }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(deleteError ?? "")
        }
        .confirmationDialog("このログと音声ファイルを削除しますか？", isPresented: $showingDeleteConfirm, titleVisibility: .visible) {
            Button("削除", role: .destructive, action: deleteEntry)
            Button("キャンセル", role: .cancel) { }
        }
        .onDisappear {
            playerService.stop()
        }
    }

    private var headerSection: some View {
        HStack(spacing: 12) {
            Text(EmotionEmoji.emoji(for: entry.emotion))
                .font(.system(size: 52))
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.title.isEmpty ? "タイトル未設定" : entry.title)
                    .font(.title2.bold())
                Text(entry.createdAt, format: .dateTime.year().month().day().weekday().hour().minute())
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var summarySection: some View {
        Group {
            if !entry.summary.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("要約")
                        .font(.headline)
                    Text(entry.summary)
                }
            }
        }
    }

    private var adviceSection: some View {
        Group {
            if !entry.advice.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("アドバイス")
                        .font(.headline)
                    Text(entry.advice)
                }
            }
        }
    }

    private var transcriptSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("全文")
                .font(.headline)
            Text(entry.text.isEmpty ? "文字起こしはまだありません。" : entry.text)
        }
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            ProgressView(value: progressValue)
                .tint(.accentColor)
            Text("\(formattedTime(playerService.currentTime)) / \(durationText)")
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)
        }
    }

    private var playbackButton: some View {
        Button(action: handlePlayback) {
            Label(playbackButtonTitle, systemImage: playbackButtonIcon)
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.accentColor.opacity(audioURL == nil ? 0.1 : 0.15)))
        }
        .disabled(audioURL == nil)
    }

    private func handlePlayback() {
        guard let url = audioURL else { return }
        do {
            try playerService.togglePlayback(for: url)
        } catch {
            playbackErrorMessage = error.localizedDescription
            showingPlaybackError = true
        }
    }

    private func deleteEntry() {
        playerService.stop()
        do {
            try viewModel.deleteEntry()
            dismiss()
        } catch {
            deleteError = error.localizedDescription
        }
    }

    private var progressValue: Double {
        guard playerService.duration > 0 else { return 0 }
        return min(playerService.currentTime / playerService.duration, 1)
    }

    private func formattedTime(_ time: TimeInterval) -> String {
        let limited = max(time, 0)
        let minutes = Int(limited) / 60
        let seconds = Int(limited) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private var durationText: String {
        playerService.duration > 0 ? formattedTime(playerService.duration) : "--:--"
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: JournalEntry.self, configurations: config)
        let context = ModelContext(container)
        let entry = JournalEntry.SampleData.entries.first!
        context.insert(entry)
        return NavigationStack {
            DetailView(entry: entry, modelContext: context)
        }
        .modelContainer(container)
    } catch {
        fatalError("Preview setup failed: \(error)")
    }
}
