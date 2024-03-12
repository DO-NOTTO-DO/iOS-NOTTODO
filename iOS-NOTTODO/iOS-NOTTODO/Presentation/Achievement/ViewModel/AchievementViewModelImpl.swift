//
//  AchievementViewModelImpl.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/12/24.
//

import Foundation
import Combine

final class AchievementViewModelImpl: AchievementViewModel, AchievementViewModelPresentable {
    
    private weak var coordinator: AchieveCoordinator?
    private var manager: AchieveManager
    private var month: String?
    private var cancelBag = Set<AnyCancellable>()
    
    init(coordinator: AchieveCoordinator, manager: AchieveManager) {
        self.coordinator = coordinator
        self.manager = manager
    }
    
    let eventSubject = PassthroughSubject<CalendarEventData, Never>()
    
    func transform(input: AchievementViewModelInput) -> AchievementViewModelOutput {
        
        Publishers.CombineLatest(input.viewWillAppearSubject, input.currentMonthSubject)
            .map { _, month in month }
            .removeDuplicates()
            .sink { [weak self] month in
                guard let self = self else { return }
                let monthString = month.formattedString(format: "yyyy-MM") 
                self.month = monthString
                self.getCalendarEvent(month: monthString)
            }
            .store(in: &cancelBag)
        
        input.calendarCellTapped
            .sink { [weak self] date in
                self?.coordinator?.showAchieveDetailViewController(selectedDate: date)
            }
            .store(in: &cancelBag)
        
        return Output(viewWillAppearSubject: eventSubject.eraseToAnyPublisher())
    }
    
    func getCalendarEvent(month: String) {
        manager.getAchieveCalendar(month: month)
            .sink(receiveCompletion: { event in
                print("completion: \(event)")
            }, receiveValue: { data in
                dump(data)
                self.eventSubject.send(data)
            })
            .store(in: &cancelBag)
    }
}
