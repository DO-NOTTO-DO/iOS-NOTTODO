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
    
    func transform(input: MyPageViewModelInput) -> MyPageViewModelOutput {
        let viewWillAppearSubject =  input.viewWillAppearSubject
              .map { _ -> MyPageModel in
                  return MyPageModel(sections: [
                    .profile,
                    .support,
                    .info,
                    .version
                ])
            }
              .eraseToAnyPublisher()
        
        input.profileCellTapped
            .sink { [weak self] _  in
                self?.coordinator?.showMyInfoAccountViewController()
            }
            .store(in: &cancelBag)
            
        return Output(viewWillAppearSubject: viewWillAppearSubject)
    }
}
