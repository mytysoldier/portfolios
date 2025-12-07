//
//  oneMinVoiceJournalWidgetLiveActivity.swift
//  oneMinVoiceJournalWidget
//
//  Created by 高松由樹 on 2025/12/07.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct oneMinVoiceJournalWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct oneMinVoiceJournalWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: oneMinVoiceJournalWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension oneMinVoiceJournalWidgetAttributes {
    fileprivate static var preview: oneMinVoiceJournalWidgetAttributes {
        oneMinVoiceJournalWidgetAttributes(name: "World")
    }
}

extension oneMinVoiceJournalWidgetAttributes.ContentState {
    fileprivate static var smiley: oneMinVoiceJournalWidgetAttributes.ContentState {
        oneMinVoiceJournalWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: oneMinVoiceJournalWidgetAttributes.ContentState {
         oneMinVoiceJournalWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: oneMinVoiceJournalWidgetAttributes.preview) {
   oneMinVoiceJournalWidgetLiveActivity()
} contentStates: {
    oneMinVoiceJournalWidgetAttributes.ContentState.smiley
    oneMinVoiceJournalWidgetAttributes.ContentState.starEyes
}
