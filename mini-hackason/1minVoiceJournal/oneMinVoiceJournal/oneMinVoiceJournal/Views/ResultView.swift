import SwiftUI
import SwiftData

struct ResultView: View {
    @Environment(\.modelContext) private var modelContext

    var onSave: (() -> Void)?

    @StateObject private var viewModel: ResultViewModel
    @StateObject private var playerService = AudioPlayerService()
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

    init(analysisResult: AnalysisResult, onSave: (() -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: ResultViewModel(analysisResult: analysisResult))
        self.onSave = onSave
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Text(EmotionEmoji.emoji(for: viewModel.analysisResult.emotion))
                    .font(.system(size: 52))
                VStack(alignment: .leading) {
                    Text(viewModel.analysisResult.emotion)
                        .font(.title3)
                    Text(viewModel.analysisResult.title.isEmpty ? "タイトル未設定" : viewModel.analysisResult.title)
                        .font(.title.bold())
                }
            }

            Group {
                Text("要約")
                    .font(.headline)
                Text(viewModel.analysisResult.summary.isEmpty ? "生成を待っています..." : viewModel.analysisResult.summary)
            }

            Group {
                Text("アドバイス")
                    .font(.headline)
                Text(viewModel.analysisResult.advice.isEmpty ? "生成を待っています..." : viewModel.analysisResult.advice)
            }

            playbackSection

            Spacer()

            Button(action: saveEntry) {
                Text("保存")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.accentColor))
                    .foregroundStyle(.white)
            }
        }
        .padding()
        .navigationTitle("結果")
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .onDisappear {
            playerService.stop()
        }
    }

    private func saveEntry() {
        do {
            try viewModel.saveEntry(in: modelContext)
            onSave?()
        } catch {
            presentAlert(title: "保存に失敗しました", message: error.localizedDescription)
        }
    }

    private var playbackSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("録音プレビュー")
                .font(.headline)

            ProgressView(value: progressValue)
                .tint(.accentColor)

            Text("\(formattedTime(playerService.currentTime)) / \(durationText)")
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)

            Button(action: handlePlayback) {
                Label(playbackButtonTitle, systemImage: playbackButtonIcon)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.accentColor.opacity(0.15)))
            }
        }
    }

    private func handlePlayback() {
        do {
            try playerService.togglePlayback(for: viewModel.analysisResult.audioURL)
        } catch {
            presentAlert(title: "再生できません", message: error.localizedDescription)
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

    private var playbackButtonTitle: String {
        if case .playing = playerService.state {
            return "再生を一時停止"
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

    private func presentAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
}

#Preview {
    NavigationStack {
        ResultView(analysisResult: AnalysisResult.mock(url: URL(fileURLWithPath: "sample.m4a")))
    }
    .modelContainer(for: JournalEntry.self, inMemory: true)
}
