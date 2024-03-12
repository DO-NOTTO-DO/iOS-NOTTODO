//
//  DetailAchievementViewModelImpl.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/12/24.
//

import Foundation
import Combine

final class DetailAchievementViewModelImpl: DetailAchievementViewModel {
    
    private weak var coordinator: AchieveCoordinator?
    private var manager: AchieveManager
    private var selectedDate: String?
    private var cancelBag = Set<AnyCancellable>()
    
    init(coordinator: AchieveCoordinator, manager: AchieveManager) {
        self.coordinator = coordinator
        self.manager = manager
    }
    
    let missionsSubject = PassthroughSubject<[AchieveDetailData], Never>()
    
    func transform(input: DetailAchievementViewModelInput) -> DetailAchievementViewModelOutput {
        
    input.viewWillAppearSubject
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                guard let selectedDate = self.selectedDate else { return }
                self.getDailyMission(date: selectedDate)
            })
            .store(in: &cancelBag)
        
        input.dismissSubject
            .sink {[weak self] _ in
                self?.coordinator?.dismiss()
            }
            .store(in: &cancelBag)
        
        return Output(viewWillAppearSubject: missionsSubject.eraseToAnyPublisher())
    }
    
    func getDailyMission(date: String) {
        manager.getDailyMission(date: date)
            .sink(receiveCompletion: { event in
                print("completion: \(event)")
            }, receiveValue: { data in
                self.missionsSubject.send([data])
            })
            .store(in: &cancelBag)
        }
}

extension DetailAchievementViewModelImpl: DetailAchievementViewModelPresentable {
    func selectedDate(_ date: String) {
        self.selectedDate = date
    }
}
