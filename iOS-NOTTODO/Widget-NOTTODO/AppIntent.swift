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
    var id: String
    
    init() { }
    init(id: String) {
        self.id = id
    }
    
    func perform() async throws -> some IntentResult {
        if let index = MissionDataModel.shared.model.firstIndex(where: {$0.id == id}) {
            MissionDataModel.shared.model[index].isCompleted.toggle()
        }
        return .result()
    }
    
}
