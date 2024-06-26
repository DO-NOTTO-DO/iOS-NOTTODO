//
//  AppIntent.swift
//  Widget-NOTTODO
//
//  Created by 강윤서 on 4/14/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
}

struct ToggleButtonIntent: AppIntent {
    static var title: LocalizedStringResource = .init(stringLiteral: "Mission's State")
    
    @Parameter(title: "Mission ID")
    var id: Int
    
    @Parameter(title: "Mission status")
    var status: String
    
    init() { }
    init(id: Int, status: String) {
        self.id = id
        self.status = status == CompletionStatus.UNCHECKED.rawValue ? CompletionStatus.CHECKED.rawValue : CompletionStatus.UNCHECKED.rawValue
    }
    
    func perform() async throws -> some IntentResult {
        _ = try await WidgetService.shared.updateMission(id: id, status: status)
        return .result()
    }
}
