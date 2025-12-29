//
//  GiftBoxAnimationViews.swift
//  audioWaveformGift
//

import SwiftUI

enum GiftAnimationPhase {
    case idle
    case dropping
    case landed
    case opening
    case opened
}

struct GiftBoxOverlay: View {
    let phase: GiftAnimationPhase

    var body: some View {
        let isVisible = phase != .idle
        GiftBoxView(phase: phase)
            .opacity(isVisible ? 1 : 0)
            .allowsHitTesting(false)
    }
}

struct FullscreenSparkleOverlay: View {
    let phase: GiftAnimationPhase

    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            let isActive = phase == .opened
            ZStack {
                RadialGradient(
                    colors: [Color.white.opacity(0.8), Color.white.opacity(0.2), Color.clear],
                    center: .center,
                    startRadius: 0,
                    endRadius: 420
                )
                .scaleEffect(isActive ? 1.35 : 0.1)
                .opacity(isActive ? 1 : 0)

                SparkleBurst(time: time, isActive: isActive)
                SparkleBurst(time: time + 1.2, isActive: isActive)
                SparkleBurst(time: time + 2.4, isActive: isActive)
            }
            .animation(.easeOut(duration: 0.8), value: isActive)
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}

struct SparkleBurst: View {
    let time: TimeInterval
    let isActive: Bool

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack {
                ForEach(0..<36, id: \.self) { index in
                    let seed = CGFloat(index)
                    let angle = seed / 36 * .pi * 2
                    let radius = (isActive ? 0.65 : 0) * min(size.width, size.height) * 0.85
                    let jitter = sin(CGFloat(time) * 2 + seed) * 12
                    let x = size.width / 2 + cos(angle) * radius + jitter
                    let y = size.height / 2 + sin(angle) * radius + jitter
                    Circle()
                        .fill(LinearGradient(
                            colors: [Color.white, Color(red: 1.0, green: 0.9, blue: 0.6), Color(red: 0.7, green: 0.9, blue: 1.0)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 8, height: 8)
                        .blur(radius: 0.8)
                        .position(x: x, y: y)
                        .opacity(isActive ? 1 : 0)
                }
            }
        }
    }
}

struct GiftBoxView: View {
    let phase: GiftAnimationPhase

    var body: some View {
        let dropOffset = dropOffsetForPhase(phase)
        let openProgress = openProgressForPhase(phase)
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(LinearGradient(
                    colors: [Color(red: 0.98, green: 0.35, blue: 0.55), Color(red: 0.9, green: 0.18, blue: 0.45)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 160, height: 120)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 16, x: 0, y: 12)

            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(red: 0.98, green: 0.86, blue: 0.3))
                .frame(width: 20, height: 120)

            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(red: 0.98, green: 0.86, blue: 0.3))
                .frame(width: 160, height: 20)

            GiftBoxLid(openProgress: openProgress)
                .offset(y: -68)
        }
        .offset(y: dropOffset)
    }

    private func dropOffsetForPhase(_ phase: GiftAnimationPhase) -> CGFloat {
        switch phase {
        case .idle:
            return -320
        case .dropping:
            return -320
        case .landed, .opening, .opened:
            return -20
        }
    }

    private func openProgressForPhase(_ phase: GiftAnimationPhase) -> CGFloat {
        switch phase {
        case .opening, .opened:
            return 1
        default:
            return 0
        }
    }
}

struct GiftBoxLid: View {
    let openProgress: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
            .fill(LinearGradient(
                colors: [Color(red: 0.98, green: 0.6, blue: 0.7), Color(red: 0.93, green: 0.28, blue: 0.55)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
            .frame(width: 170, height: 34)
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.white.opacity(0.45), lineWidth: 1)
            )
            .rotationEffect(.degrees(-45 * openProgress), anchor: .leading)
            .offset(x: -40 * openProgress, y: -24 * openProgress)
    }
}
