//
//  UIImageView+.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/20.
//

import UIKit

import Kingfisher

extension UIImageView {
    func setImage(with urlString: String) {
        let cache = ImageCache.default
        cache.retrieveImage(forKey: urlString, options: nil) { [weak self] result in // 캐시에서 키를 통해 이미지를 가져온다.
            switch result {
            case .success(let value):
                if let image = value.image { // 만약 캐시에 이미지가 존재한다면
                    DispatchQueue.main.async { [weak self] in // 이미지 설정은 메인 스레드에서 수행되어야 하므로 async로 처리한다.
                        self?.image = image // 이미지를 셋한다.
                    }
                } else {
                    guard let url = URL(string: urlString) else { return }
                    let resource = KF.ImageResource(downloadURL: url, cacheKey: urlString) // URL로부터 이미지를 다운받고 String 타입의 URL을 캐시키로 지정하고
                    self?.kf.setImage(with: resource) // 이미지를 셋한다.
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
