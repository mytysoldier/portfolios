import Foundation
import AVFoundation

@MainActor
final class AudioRecorderService: NSObject, ObservableObject {
    enum RecorderState: Equatable {
        case idle
        case recording(url: URL)
        case finished(url: URL)

        var recordedURL: URL? {
            switch self {
            case .recording(let url), .finished(let url):
                return url
            case .idle:
                return nil
            }
        }
    }

    enum RecorderError: Error, LocalizedError {
        case permissionDenied
        case failedToStart

        var errorDescription: String? {
            switch self {
            case .permissionDenied:
                return "マイクのアクセス許可がありません。設定から許可してください。"
            case .failedToStart:
                return "録音の開始に失敗しました。もう一度お試しください。"
            }
        }
    }

    @Published private(set) var state: RecorderState = .idle
    @Published private(set) var elapsedTime: TimeInterval = 0

    let maxDuration: TimeInterval = 60

    private var audioRecorder: AVAudioRecorder?
    private var meterTimer: Timer?

    private let audioSession = AVAudioSession.sharedInstance()
    private let fileManager = FileManager.default

    var isRecording: Bool {
        if case .recording = state { return true }
        return false
    }

    func startRecording() async throws {
        guard !isRecording else { return }

        let permissionGranted = try await requestPermissionIfNeeded()
        guard permissionGranted else { throw RecorderError.permissionDenied }

        let recordingURL = try prepareRecordingURL()
        let recorder = try AVAudioRecorder(url: recordingURL, settings: recordingSettings)
        audioRecorder = recorder
        recorder.delegate = self
        recorder.isMeteringEnabled = true

        elapsedTime = 0
        if recorder.record(forDuration: maxDuration) {
            state = .recording(url: recordingURL)
            startTimer()
        } else {
            throw RecorderError.failedToStart
        }
    }

    func stopRecording() {
        guard isRecording else { return }
        audioRecorder?.stop()
        audioRecorder = nil
        stopTimer()
    }

    func reset() {
        stopTimer()
        audioRecorder?.stop()
        audioRecorder = nil
        elapsedTime = 0
        state = .idle
    }
}

private extension AudioRecorderService {
    var recordingSettings: [String: Any] {
        [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44_100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
    }

    func requestPermissionIfNeeded() async throws -> Bool {
        try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
        try audioSession.setActive(true)

        if #available(iOS 17.0, *) {
            return await withCheckedContinuation { continuation in
                AVAudioApplication.requestRecordPermission { granted in
                    continuation.resume(returning: granted)
                }
            }
        } else {
            return await withCheckedContinuation { continuation in
                audioSession.requestRecordPermission { granted in
                    continuation.resume(returning: granted)
                }
            }
        }
    }

    func prepareRecordingURL() throws -> URL {
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let audioDirectory = documents.appendingPathComponent("Audio", isDirectory: true)
        if !fileManager.fileExists(atPath: audioDirectory.path) {
            try fileManager.createDirectory(at: audioDirectory, withIntermediateDirectories: true)
        }
        return audioDirectory.appendingPathComponent("\(UUID().uuidString).m4a")
    }

    func startTimer() {
        stopTimer()
        meterTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            guard self.isRecording else { return }
            if let currentTime = self.audioRecorder?.currentTime {
                self.elapsedTime = min(currentTime, self.maxDuration)
                if currentTime >= self.maxDuration {
                    self.stopRecording()
                }
            }
        }
    }

    func stopTimer() {
        meterTimer?.invalidate()
        meterTimer = nil
    }
}

extension AudioRecorderService: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        stopTimer()
        if flag {
            state = .finished(url: recorder.url)
        } else {
            state = .idle
        }
    }
}
