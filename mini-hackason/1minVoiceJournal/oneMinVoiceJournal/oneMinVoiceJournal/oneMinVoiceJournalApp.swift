//
//  oneMinVoiceJournalApp.swift
//  oneMinVoiceJournal
//
//  Created by mytysoldier on 2025/12/07.
//

import SwiftUI
import SwiftData

@main
struct OneMinVoiceJournalApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: JournalEntry.self)
    }
}
