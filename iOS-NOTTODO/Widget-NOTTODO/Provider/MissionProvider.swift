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
    @AppStorage("quote", store: UserDefaults.shared) var quote: String = ""
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(todayMission: [], quote: quote)
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        do {
            try await getQuote()
        } catch {
            return SimpleEntry(todayMission: [], quote: "")
        }
        return SimpleEntry(todayMission: [], quote: quote)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        do {
            let now = Date()
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now) ?? now
            let midnightTomorrow = Calendar.current.startOfDay(for: tomorrow)
            let midnightToday = Calendar.current.startOfDay(for: now)
            
            if now == midnightToday {
                try await getQuote()
                try await getDailyMission(date: Formatter.dateFormatterString(format: nil, date: now))
            }
            
            guard let decodedData = try? JSONDecoder().decode([DailyMissionResponseDTO].self, from: sharedData) else {
                return Timeline(entries: [], policy: .never)
            }
            
            let entry = SimpleEntry(todayMission: decodedData, quote: quote)
            return Timeline(entries: [entry], policy: .after(midnightTomorrow))
        } catch {
            return Timeline(entries: [], policy: .never)
        }
        
    }
    
    private func getQuote() async throws {
        let quoteResponse = try await WidgetService.shared.fetchWiseSaying()
        quote = quoteResponse.description + " - " + quoteResponse.author
    }
    
    private func getDailyMission(date: String) async throws {
        let dailyMission = try await WidgetService.shared.fetchDailyMissoin(date: date)
        UserDefaults.shared?.setSharedCustomArray(dailyMission, forKey: "dailyMission")
    }
}
