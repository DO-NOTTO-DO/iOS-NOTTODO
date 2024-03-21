//
//  MyPageViewModelImpl.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/15/24.
//

import Foundation
import Combine

final class MyPageViewModelImpl: MyPageViewModel {
    
    private weak var coordinator: MypageCoordinator?
    private var cancelBag = Set<AnyCancellable>()
    
    init(coordinator: MypageCoordinator) {
        self.coordinator = coordinator
    }
    
    private let openSafariController = PassthroughSubject<String, Never>()
    
    func transform(input: MyPageViewModelInput) -> MyPageViewModelOutput {
        
        let viewWillAppearSubject =  input.viewWillAppearSubject
        
            .map { _ -> MyPageModel in
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.MyInfo.viewMyInfo)
                
                return MyPageModel(sections: [
                    .profile,
                    .support,
                    .info,
                    .version
                ])
            }
            .eraseToAnyPublisher()
        
        input.myPageCellTapped
            .sink { [weak self] indexPath in
                guard let self else { return }
                guard let section = MyPageModel.Section(rawValue: indexPath.section),
                      indexPath.item < section.events.count else { return }
                
                self.sendAnalyticsEvent(section.events[indexPath.item])
                
                switch section {
                case .profile:
                    self.coordinator?.showMyInfoAccountViewController()
                case .support, .info:
                    let url = section.urls[indexPath.item]
                    self.openSafariController.send(url.url)
                case .version:
                    break
                }
            }
            .store(in: &cancelBag)
        
        return Output(viewWillAppearSubject: viewWillAppearSubject, openSafariController: openSafariController.eraseToAnyPublisher())
    }
    
    private func sendAnalyticsEvent(_ event: AnalyticsEvent.MyInfo) {
        AmplitudeAnalyticsService.shared.send(event: event)
    }
}
