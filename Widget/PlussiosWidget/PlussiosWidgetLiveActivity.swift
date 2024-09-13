//
//  PlussiosWidgetLiveActivity.swift
//  PlussiosWidget
//
//  Created by Stan Sidel on 29.12.2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PlussiosWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct PlussiosWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PlussiosWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                expandedContent(
                    context: context
                )
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

    @DynamicIslandExpandedContentBuilder
    private func expandedContent(
        context: ActivityViewContext<PlussiosWidgetAttributes>
    ) -> DynamicIslandExpandedContent<some View> {
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
    }
}

extension PlussiosWidgetAttributes {
    fileprivate static var preview: PlussiosWidgetAttributes {
        PlussiosWidgetAttributes(name: "World")
    }
}

extension PlussiosWidgetAttributes.ContentState {
    fileprivate static var smiley: PlussiosWidgetAttributes.ContentState {
        PlussiosWidgetAttributes.ContentState(emoji: "😀")
    }

    fileprivate static var starEyes: PlussiosWidgetAttributes.ContentState {
        PlussiosWidgetAttributes.ContentState(emoji: "🤩")
    }
}

@available(iOS 17.0, *)
#Preview("Notification", as: .content, using: PlussiosWidgetAttributes.preview) {
    PlussiosWidgetLiveActivity()
} contentStates: {
    PlussiosWidgetAttributes.ContentState.smiley
    PlussiosWidgetAttributes.ContentState.starEyes
}
