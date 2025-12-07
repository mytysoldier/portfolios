import Foundation
import AVFoundation
import QuartzCore

@MainActor
final class AudioPlayerService: NSObject, ObservableObject {
    enum PlayerState: Equatable {
        case idle
        case prepared(url: URL)
        case playing(url: URL)
        case paused(url: URL)

        var currentURL: URL? {
            switch self {
            case let .prepared(url), let .playing(url), let .paused(url):
                return url
            case .idle:
                return nil
            }
        }
    }

    enum PlayerError: Error, LocalizedError {
        case fileNotFound
        case failedToPlay

        var errorDescription: String? {
            switch self {
            case .fileNotFound:
                return "音声ファイルが見つかりません。"
            case .failedToPlay:
                return "音声の再生に失敗しました。"
            }
        }
    }

    @Published private(set) var state: PlayerState = .idle
    @Published private(set) var currentTime: TimeInterval = 0
    @Published private(set) var duration: TimeInterval = 0

    private var player: AVAudioPlayer?
    private var displayLink: CADisplayLink?

    func togglePlayback(for url: URL) throws {
        if player?.url != url {
            try preparePlayer(with: url)
        }

        guard let player else { throw PlayerError.failedToPlay }

        if player.isPlaying {
            player.pause()
            stopDisplayLink()
            state = .paused(url: url)
        } else {
            if player.play() {
                startDisplayLink()
                state = .playing(url: url)
            } else {
                throw PlayerError.failedToPlay
            }
        }
    }

    func stop() {
        player?.stop()
        player = nil
        stopDisplayLink()
        currentTime = 0
        duration = 0
        state = .idle
    }

    private func preparePlayer(with url: URL) throws {
        let fileURL = url
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            throw PlayerError.fileNotFound
        }

        let newPlayer = try AVAudioPlayer(contentsOf: fileURL)
        newPlayer.delegate = self
        newPlayer.prepareToPlay()
        player = newPlayer
        duration = newPlayer.duration
        currentTime = newPlayer.currentTime
        state = .prepared(url: url)
    }
}

extension AudioPlayerService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard let url = player.url ?? state.currentURL else {
            stop()
            return
        }
        stopDisplayLink()
        currentTime = flag ? duration : 0
        state = flag ? .prepared(url: url) : .idle
    }
}


private extension AudioPlayerService {
    func startDisplayLink() {
        stopDisplayLink()
        let link = CADisplayLink(target: self, selector: #selector(updateProgress))
        link.add(to: .main, forMode: .common)
        displayLink = link
    }

    func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc func updateProgress() {
        guard let player else { return }
        currentTime = player.currentTime
        duration = player.duration
        if !player.isPlaying {
            stopDisplayLink()
        }
    }
}
