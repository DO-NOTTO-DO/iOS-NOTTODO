//
//  Widget_NOTTODO.swift
//  Widget-NOTTODO
//
//  Created by 강윤서 on 4/14/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    @AppStorage("dailyMission", store: UserDefaults.shared) var sharedData: Data = Data()
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(lastThreeTask: [])
    }
 
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        if let decodedData = try? JSONDecoder().decode([DailyMissionResponseDTO].self, from: sharedData) {
            return SimpleEntry(lastThreeTask: decodedData)
        }
        return SimpleEntry(lastThreeTask: [])
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        if let decodedData = try? JSONDecoder().decode([DailyMissionResponseDTO].self, from: sharedData) {
            let entries: [SimpleEntry] = [SimpleEntry(lastThreeTask: decodedData)]

            return Timeline(entries: entries, policy: .never)
        }
        
        return Timeline(entries: [], policy: .never)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date = .now
    var lastThreeTask: [DailyMissionResponseDTO]
}

struct Widget_NOTTODOEntryView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        @AppStorage("dailyMission", store: UserDefaults.shared) var sharedData: Data = Data()

        if let decodedData = try? JSONDecoder().decode([DailyMissionResponseDTO].self, from: sharedData) {
            
            switch self.family {
            case .systemSmall:
                SmallFamily(entry: SimpleEntry(lastThreeTask: decodedData))
            default:
                MediumFamily(entry: SimpleEntry(lastThreeTask: decodedData))
            }
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

#Preview(as: .systemMedium) {
    Widget_NOTTODO()
} timeline: {
    SimpleEntry(lastThreeTask: [])
}
