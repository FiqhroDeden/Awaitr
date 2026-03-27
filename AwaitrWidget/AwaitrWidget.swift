//
//  AwaitrWidget.swift
//  AwaitrWidget
//
//  Created by ZoldyckD on 26/03/26.
//

import WidgetKit
import SwiftUI

struct AwaitrWidget: Widget {
    let kind = "AwaitrWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AwaitrTimelineProvider()) { entry in
            AwaitrWidgetEntryView(entry: entry)
                .containerBackground(.ultraThinMaterial, for: .widget)
        }
        .configurationDisplayName("Awaitr")
        .description("Track your active waitlist items and upcoming deadlines.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Entry View Router

struct AwaitrWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: AwaitrWidgetEntry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

#Preview(as: .systemSmall) {
    AwaitrWidget()
} timeline: {
    AwaitrWidgetEntry.placeholder
    AwaitrWidgetEntry.empty
}

#Preview(as: .systemMedium) {
    AwaitrWidget()
} timeline: {
    AwaitrWidgetEntry.placeholder
    AwaitrWidgetEntry.empty
}
