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
    @State private var showSavedToast = false

    init(analysisResult: AnalysisResult, isLoading: Bool = false, onSave: (() -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: ResultViewModel(analysisResult: analysisResult, isLoading: isLoading))
        self.onSave = onSave
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            headerSection

            summarySection

            playbackSection

            Spacer()

            Button(action: saveEntry) {
                Text(viewModel.isSaved ? "保存済み" : "保存")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(viewModel.isSaved ? Color.green : Color.accentColor))
                    .foregroundStyle(.white)
            }
            .disabled(viewModel.isSaved)
        }
        .padding()
        .navigationTitle("結果")
        .overlay(alignment: .top) {
            if showSavedToast {
                Text("保存しました")
                    .padding()
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(.top, 16)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
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
            withAnimation {
                showSavedToast = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    showSavedToast = false
                }
            }
        } catch {
            presentAlert(title: "保存に失敗しました", message: error.localizedDescription)
        }
    }

    @ViewBuilder
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Group {
                Text("要約")
                    .font(.headline)
                if viewModel.analysisResult.summary.isEmpty {
                    SkeletonView()
                } else {
                    Text(viewModel.analysisResult.summary)
                }
            }

            Group {
                Text("アドバイス")
                    .font(.headline)
                if viewModel.analysisResult.advice.isEmpty {
                    SkeletonView()
                } else {
                    Text(viewModel.analysisResult.advice)
                }
            }
        }
    }

    private var headerSection: some View {
        HStack(spacing: 12) {
            Text(EmotionEmoji.emoji(for: viewModel.analysisResult.emotion))
                .font(.system(size: 52))
            VStack(alignment: .leading) {
                Text(viewModel.analysisResult.emotion)
                    .font(.title3)
                if viewModel.analysisResult.title.isEmpty {
                    SkeletonView()
                        .frame(height: 24)
                } else {
                    Text(viewModel.analysisResult.title)
                        .font(.title.bold())
                }
            }
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
            .disabled(viewModel.isLoading)
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
