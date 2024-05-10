//
//  Widget_NOTTODO.swift
//  Widget-NOTTODO
//
//  Created by 강윤서 on 4/14/24.
//

import WidgetKit
import SwiftUI

struct Widget_NOTTODOEntryView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        switch self.family {
        case .systemSmall:
            SmallFamily(entry: entry)
        default:
            MediumFamily(entry: entry)
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
        .configurationDisplayName("오늘의 낫투두")
        .description("오늘 실천할 낫투두를 확인하고 명언을 통해 동기부여를 얻을 수 있어요")
        .contentMarginsDisabled()
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemMedium) {
    Widget_NOTTODO()
} timeline: {
    SimpleEntry(todayMission: [], quote: "")
}
