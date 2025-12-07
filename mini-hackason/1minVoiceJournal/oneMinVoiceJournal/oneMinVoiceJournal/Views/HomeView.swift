import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var recorderService = AudioRecorderService()
    @State private var errorMessage: String?
    @State private var showingError = false
    @State private var isPulsing = false

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
                            .overlay {
                                Circle()
                                    .stroke(Color.white.opacity(0.4), lineWidth: 4)
                                    .scaleEffect(isPulsing ? 1.1 : 0.9)
                                    .opacity(recorderService.isRecording ? 1 : 0)
                                    .animation(
                                        recorderService.isRecording
                                        ? .easeInOut(duration: 0.8).repeatForever(autoreverses: true)
                                        : .default,
                                        value: isPulsing
                                    )
                            }

                        Image(systemName: recorderService.isRecording ? "stop.fill" : "mic.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.white)
                    }
                }
                .buttonStyle(.plain)
                .disabled(viewModel.isProcessing)

                VStack(spacing: 4) {
                    Text("経過 \(formattedElapsedTime) / 1:00")
                        .font(.title3.monospacedDigit())
                        .foregroundStyle(recorderService.isRecording ? .primary : .secondary)
                    if recorderService.isRecording {
                        Text("残り \(formattedRemainingTime)")
                            .font(.footnote.monospacedDigit())
                            .foregroundStyle(.secondary)
                        ProgressView(value: recorderService.elapsedTime, total: recorderService.maxDuration)
                            .progressViewStyle(.linear)
                            .tint(.red)
                            .padding(.horizontal, 32)
                    }
                }

                if case .finished = recorderService.state {
                    Text("録音が完了しました")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                if viewModel.isProcessing, let message = viewModel.processingMessage {
                    ProgressView(message)
                        .padding()
                }

                if let analysisError = viewModel.analysisError {
                    VStack(spacing: 8) {
                        Text(analysisError)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.leading)

                        if viewModel.canRetry {
                            Button {
                                Task {
                                    await viewModel.retryProcessing()
                                }
                            } label: {
                                Text("再試行")
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Capsule().stroke(Color.accentColor))
                            }
                        }
                    }
                }

                Spacer()

                NavigationLink(isActive: $viewModel.navigateToResult) {
                    if let analysisResult = viewModel.analysisResult {
                        ResultView(
                            analysisResult: analysisResult,
                            isLoading: viewModel.isProcessing,
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
            .onChange(of: recorderService.state) { newState in
                switch newState {
                case .finished(let url):
                    isPulsing = false
                    Task {
                        await viewModel.processRecording(at: url)
                    }
                case .idle:
                    isPulsing = false
                    viewModel.reset()
                case .recording:
                    isPulsing = true
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

    private var formattedRemainingTime: String {
        let remaining = max(recorderService.maxDuration - recorderService.elapsedTime, 0)
        let minutes = Int(remaining) / 60
        let seconds = Int(remaining) % 60
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
