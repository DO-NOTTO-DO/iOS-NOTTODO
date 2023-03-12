//
//  PopupView.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/08.
//

import UIKit

import Then
import SnapKit

class PopUpView: UIView {
    
    private let scenes = UIApplication.shared.connectedScenes
    private lazy var windowScene = self.scenes.first as? UIWindowScene
    
    static let shared = PopUpView()
    var addedSubView: UIView!
    
    private var customAction: (() -> Void)?
    var width: CGFloat?
    var height: CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    lazy var blackView =  UIView().then {
        $0.backgroundColor = UIColor.black
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
    }
    
    let backgroundView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PopUpView {
    func initializeMainView() {
        if let window = windowScene?.windows.first {
            window.endEditing(true)
            backgroundView.alpha = 1
            blackView.alpha = 0.6
            
            blackView.frame = window.frame
            window.addSubviews(blackView, backgroundView)
            
            backgroundView.snp.remakeConstraints {
                $0.centerX.centerY.equalToSuperview()
            }
        }
    }
}

extension PopUpView {
    func appearPopUpView(subView: UIView, width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
        initializeMainView()
        addedSubView = subView
        backgroundView.addSubview(addedSubView)
        
        addedSubView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }
        
        self.bringSubviewToFront(backgroundView)
        backgroundView.bringSubviewToFront(addedSubView)
        
        if (windowScene?.windows.first) != nil {
            let transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            backgroundView.transform = transform
            blackView.alpha = 0
            UIView.animate(
                withDuration: 0.7,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 1,
                options: .curveEaseOut,
                animations: {
                    self.blackView.alpha = 0.5
                    self.backgroundView.transform = .identity
                },
                completion: nil)
        }
    }
    
    @objc func dismiss(gesture: UITapGestureRecognizer) {
        dissmissFromSuperview()
    }
    
    @objc
    func dissmissFromSuperview() {
        if (windowScene?.windows.first) != nil {
            let transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(
                withDuration: 0,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 1,
                options: .curveEaseOut,
                animations: { [unowned self] in
                    backgroundView.transform = transform
                    backgroundView.alpha = 0
                    blackView.alpha = 0
                },
                completion: { _ in
                    self.blackView.removeFromSuperview()
                    self.backgroundView.removeFromSuperview()
                    self.backgroundView.removeFromSuperview()
                    self.addedSubView.removeFromSuperview()
                    self.addedSubView = nil
                }
            )
        }
    }
}
