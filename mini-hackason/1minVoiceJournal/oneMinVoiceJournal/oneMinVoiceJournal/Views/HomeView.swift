import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var recorderService = AudioRecorderService()
    @State private var errorMessage: String?
    @State private var showingError = false
    @State private var showingAnalysisError = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    Text("1min Voice Journal")
                        .font(.largeTitle.bold())
                    Text("1分だけ声で気持ちを残しましょう")
                        .foregroundStyle(.secondary)
                }

                Button(action: toggleRecording) {
                    ZStack {
                        Circle()
                            .fill(recorderService.isRecording ? Color.red.opacity(0.8) : Color.accentColor)
                            .frame(width: 180, height: 180)
                            .shadow(radius: 8)

                        Image(systemName: recorderService.isRecording ? "stop.fill" : "mic.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.white)
                    }
                }
                .buttonStyle(.plain)
                .disabled(viewModel.isProcessing)

                Text("\(formattedElapsedTime) / 1:00")
                    .font(.title3.monospacedDigit())
                    .foregroundStyle(recorderService.isRecording ? .primary : .secondary)

                if case .finished = recorderService.state {
                    Text("録音が完了しました")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                if viewModel.isProcessing {
                    ProgressView(viewModel.processingMessage ?? "解析中...")
                        .padding()
                }

                Spacer()

                NavigationLink(isActive: $viewModel.navigateToResult) {
                    if let analysisResult = viewModel.analysisResult {
                        ResultView(
                            analysisResult: analysisResult,
                            onSave: {
                                viewModel.reset()
                                recorderService.reset()
                            }
                        )
                    } else {
                        ProgressView("解析中...")
                    }
                } label: {
                    EmptyView()
                }
                .hidden()

                NavigationLink {
                    LogListView(modelContext: modelContext)
                } label: {
                    Label("ログ一覧へ", systemImage: "list.bullet")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Capsule().fill(Color.secondary.opacity(0.2)))
                }
            }
            .padding()
            .alert("録音エラー", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "不明なエラーが発生しました。")
            }
            .alert("解析に失敗しました", isPresented: $showingAnalysisError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.analysisError ?? "処理に失敗しました。")
            }
            .onChange(of: recorderService.state) { newState in
                switch newState {
                case .finished(let url):
                    Task {
                        await viewModel.processRecording(at: url)
                        if viewModel.analysisError != nil {
                            showingAnalysisError = true
                        }
                    }
                case .idle:
                    viewModel.reset()
                case .recording:
                    break
                }
            }
        }
    }

    private var formattedElapsedTime: String {
        let limitedTime = min(recorderService.elapsedTime, recorderService.maxDuration)
        let minutes = Int(limitedTime) / 60
        let seconds = Int(limitedTime) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func toggleRecording() {
        if recorderService.isRecording {
            recorderService.stopRecording()
        } else {
            Task {
                do {
                    try await recorderService.startRecording()
                } catch {
                    errorMessage = error.localizedDescription
                    showingError = true
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .modelContainer(for: JournalEntry.self, inMemory: true)
}
