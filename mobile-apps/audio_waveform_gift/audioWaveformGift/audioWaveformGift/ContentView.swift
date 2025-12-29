//
//  ContentView.swift
//  audioWaveformGift
//

import SwiftUI

struct ContentView: View {
    @State private var selectedFileURL: URL?
    @State private var showFilePicker = false
    @State private var showShareSheet = false
    @State private var giftPhase: GiftAnimationPhase = .idle

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.96, green: 0.93, blue: 0.88), Color(red: 0.86, green: 0.92, blue: 0.96)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Audio Waveform Gift")
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                    Text(selectedFileURL == nil ? "音声ファイルを選んでね" : "近づけてね")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                WaveformGiftView(isActive: selectedFileURL != nil)
                    .frame(height: 180)
                    .padding(.horizontal, 24)

                Button {
                    showFilePicker = true
                } label: {
                    Label("音声ファイルを選ぶ", systemImage: "music.note")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.black.opacity(0.08), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 24)
            }
            .padding(.vertical, 40)

            GiftBoxOverlay(phase: giftPhase)
            FullscreenSparkleOverlay(phase: giftPhase)
        }
        .sheet(isPresented: $showFilePicker) {
            AudioDocumentPicker { url in
                selectedFileURL = url
                triggerGiftAnimation()
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let url = selectedFileURL {
                ShareSheet(activityItems: [url])
            }
        }
        .onChange(of: showShareSheet) { isPresented in
            if isPresented {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    giftPhase = .idle
                }
            }
        }
    }

    private func triggerGiftAnimation() {
        guard selectedFileURL != nil else { return }
        giftPhase = .dropping
        withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
            giftPhase = .landed
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation(.easeOut(duration: 0.35)) {
                giftPhase = .opening
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.05) {
            giftPhase = .opened
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.65) {
            showShareSheet = true
        }
    }
}

#Preview {
    ContentView()
}
