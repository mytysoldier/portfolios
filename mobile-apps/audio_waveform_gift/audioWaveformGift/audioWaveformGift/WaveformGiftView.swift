//
//  WaveformGiftView.swift
//  audioWaveformGift
//

import SwiftUI

struct WaveformGiftView: View {
    let isActive: Bool

    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            let phase = CGFloat(time * 0.9)

            ZStack {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.82), Color.white.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .stroke(Color.black.opacity(0.08), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 10)

                SparkleField(phase: phase, isActive: isActive)
                    .opacity(isActive ? 1 : 0.3)

                WaveformPathView(phase: phase, isActive: isActive)
                    .padding(.horizontal, 16)

                GiftRibbonView(phase: phase, isActive: isActive)
                    .frame(width: 130, height: 130)
                    .offset(y: -12)
                    .opacity(isActive ? 1 : 0.35)
                    .scaleEffect(isActive ? 1 : 0.9)
                    .animation(.easeInOut(duration: 0.6), value: isActive)
            }
        }
    }
}

struct WaveformPathView: View {
    let phase: CGFloat
    let isActive: Bool

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            Canvas { context, canvasSize in
                let path = waveformPath(size: canvasSize, phase: phase)
                let glowPath = waveformPath(size: canvasSize, phase: phase + 0.6, amplitudeScale: 0.75)
                let gradient = Gradient(colors: [
                    Color(red: 0.1, green: 0.3, blue: 0.95),
                    Color(red: 0.55, green: 0.25, blue: 0.9),
                    Color(red: 0.95, green: 0.35, blue: 0.45)
                ])
                let lineWidth: CGFloat = isActive ? 3.5 : 2.2

                context.stroke(
                    glowPath,
                    with: .color(Color.white.opacity(isActive ? 0.35 : 0.18)),
                    lineWidth: lineWidth * 2.6
                )
                context.stroke(
                    path,
                    with: .linearGradient(gradient, startPoint: .zero, endPoint: CGPoint(x: canvasSize.width, y: canvasSize.height)),
                    lineWidth: lineWidth
                )
            }
            .frame(width: size.width, height: size.height)
        }
    }

    private func waveformPath(size: CGSize, phase: CGFloat, amplitudeScale: CGFloat = 1) -> Path {
        var path = Path()
        let midY = size.height * 0.55
        let amplitude = size.height * 0.24 * amplitudeScale
        let frequency: CGFloat = 2.4
        let step: CGFloat = 4

        for x in stride(from: CGFloat.zero, through: size.width, by: step) {
            let progress = x / size.width
            let mix = 0.6 + 0.4 * sin(progress * .pi * 2 + phase * 0.7)
            let y = midY + sin((progress * frequency * .pi * 2) + phase) * amplitude * mix
            if x == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        return path
    }
}

struct SparkleField: View {
    let phase: CGFloat
    let isActive: Bool

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack {
                ForEach(0..<12, id: \.self) { index in
                    let seed = CGFloat(index)
                    let driftX = sin(phase + seed) * 18
                    let driftY = cos(phase * 0.8 + seed) * 16
                    let x = size.width * (0.15 + 0.7 * sin(seed * 1.3 + 1).magnitude)
                    let y = size.height * (0.2 + 0.6 * cos(seed * 1.1 + 0.7).magnitude)
                    let sizeFactor = isActive ? 1.0 : 0.6
                    Circle()
                        .fill(Color.white.opacity(0.6))
                        .frame(width: 6 * sizeFactor, height: 6 * sizeFactor)
                        .blur(radius: 0.5)
                        .position(x: x + driftX, y: y + driftY)
                }
            }
        }
        .allowsHitTesting(false)
    }
}

struct GiftRibbonView: View {
    let phase: CGFloat
    let isActive: Bool

    var body: some View {
        let pulse = 0.96 + 0.04 * sin(phase * 2)
        let bowTilt = Angle(degrees: Double(sin(phase) * 6))
        let ribbonOpacity = isActive ? 1 : 0.4

        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(red: 0.9, green: 0.2, blue: 0.4).opacity(ribbonOpacity))
                .frame(width: 14, height: 92)

            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(red: 0.9, green: 0.2, blue: 0.4).opacity(ribbonOpacity))
                .frame(width: 92, height: 14)

            Circle()
                .fill(LinearGradient(
                    colors: [Color(red: 0.99, green: 0.85, blue: 0.35), Color(red: 0.96, green: 0.65, blue: 0.15)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 60, height: 60)

            HStack(spacing: -6) {
                Capsule(style: .continuous)
                    .fill(Color(red: 0.96, green: 0.35, blue: 0.55).opacity(ribbonOpacity))
                    .frame(width: 46, height: 26)
                    .rotationEffect(.degrees(20))
                    .scaleEffect(pulse)
                Capsule(style: .continuous)
                    .fill(Color(red: 0.96, green: 0.35, blue: 0.55).opacity(ribbonOpacity))
                    .frame(width: 46, height: 26)
                    .rotationEffect(.degrees(-20))
                    .scaleEffect(pulse)
            }
            .rotationEffect(bowTilt)
        }
        .shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: 6)
    }
}
