//
//  AchievementViewModelImpl.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/12/24.
//

import Foundation
import Combine

final class AchievementViewModelImpl: AchievementViewModel {
    
    private weak var coordinator: AchieveCoordinator?
    private var manager: AchieveManager
    private var cancelBag = Set<AnyCancellable>()
    
    init(coordinator: AchieveCoordinator, manager: AchieveManager) {
        self.coordinator = coordinator
        self.manager = manager
    }
    
    let eventSubject = PassthroughSubject<CalendarEventData, Never>()
    var dataSource: [String: Float] = [:]
    
    func transform(input: AchievementViewModelInput) -> AchievementViewModelOutput {
        
        input.viewWillAppearSubject
            .merge(with: input.currentMonthSubject)
            .removeDuplicates()
            .sink { [weak self] month in
                guard let self = self else { return }
                self.getCalendarEvent(month: month)
            }
            .store(in: &cancelBag)
        
        input.calendarCellTapped
            .compactMap { date -> String? in
                guard let percentage = self.dataSource[date.formattedString()], percentage != 0.0 else {
                    return nil
                }
                return date.formattedString()
            }
            .sink { [weak self] date in
                self?.coordinator?.showAchieveDetailViewController(selectedDate: date)
            }
        .store(in: &cancelBag)
        
        return Output(viewWillAppearSubject: eventSubject.eraseToAnyPublisher())
    }
    
    func getCalendarEvent(month: Date) {
        manager.getAchieveCalendar(month: month)
            .sink(receiveCompletion: { event in
                print("completion: \(event)")
            }, receiveValue: { data in
                self.eventSubject.send(data)
                self.dataSource = data.percentages
            })
            .store(in: &cancelBag)
    }
}
