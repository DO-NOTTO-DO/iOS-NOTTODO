//
//  Widget_NOTTODO.swift
//  Widget-NOTTODO
//
//  Created by 강윤서 on 4/14/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(lastThreeTask: Array(MissionDataModel.shared.model.prefix(3)))
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(lastThreeTask: Array(MissionDataModel.shared.model.prefix(3)))
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let lastestTask = Array(MissionDataModel.shared.model.prefix(3))
        let entries: [SimpleEntry] = [SimpleEntry(lastThreeTask: lastestTask)]
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date = .now
    var lastThreeTask: [MissionModel]
}

struct Widget_NOTTODOEntryView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        switch self.family {
        case .systemSmall:
            SmallFamily(entry: SimpleEntry(lastThreeTask: MissionDataModel.shared.model))
        default:
            MediumFamily(entry: SimpleEntry(lastThreeTask: []))
        }
    }
    
}

struct Widget_NOTTODO: Widget {
    let kind: String = "Widget_NOTTODO"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            Widget_NOTTODOEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("낫투두 위젯")
        .description("낫투두 위젯입니다.")
        .contentMarginsDisabled()
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        return intent
    }
}

#Preview(as: .systemMedium) {
    Widget_NOTTODO()
} timeline: {
    SimpleEntry(lastThreeTask: MissionDataModel.shared.model)
}
