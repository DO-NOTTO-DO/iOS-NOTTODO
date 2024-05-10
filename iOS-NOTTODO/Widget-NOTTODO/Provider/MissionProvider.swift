//
//  MissionProvider.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 5/11/24.
//

import SwiftUI
import WidgetKit

struct Provider: AppIntentTimelineProvider {
    @AppStorage("dailyMission", store: UserDefaults.shared) var sharedData: Data = Data()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(todayMission: [], quote: "")
    }
 
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        do {
            let entry = try await getTimelineEntry()
            return entry
        } catch {
            return SimpleEntry(todayMission: [], quote: "")
        }
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        do {
            let entry = try await getTimelineEntry()
            return Timeline(entries: [entry], policy: .never)
        } catch {
            return Timeline(entries: [], policy: .never)
        }
        
    }
    
    private func getTimelineEntry() async throws -> SimpleEntry {
        guard let decodedData = try? JSONDecoder().decode([DailyMissionResponseDTO].self, from: sharedData) else { 
            return SimpleEntry(todayMission: [], quote: "")
        }
        
        let quoteResponse = try await WidgetService.shared.fetchWiseSaying()
        let quote = quoteResponse.description + " - " + quoteResponse.author
        return SimpleEntry(todayMission: decodedData, quote: quote)
    }
}
