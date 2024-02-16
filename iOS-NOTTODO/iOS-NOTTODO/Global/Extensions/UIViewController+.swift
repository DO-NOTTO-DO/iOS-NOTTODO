//
//  UIViewController+.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/17.
//

import UIKit

import SnapKit

extension UIViewController {
    /// Constraint 설정 시 노치 유무로 기기를 대응하는 상황에서 사용
    func constraintByNotch(_ hasNotch: CGFloat, _ noNotch: CGFloat) -> CGFloat {
        return UIScreen.main.hasNotch ? hasNotch : noNotch
    }
    
    /// 아이폰 13 미니(width 375)를 기준으로 레이아웃을 잡고, 기기의 width 사이즈를 곱해 대응 값을 구할 때 사용
    func convertByWidthRatio(_ convert: CGFloat) -> CGFloat {
        return (convert / 375) * Numbers.width
    }
    
    /// 아이폰 13 미니(height 812)를 기준으로 레이아웃을 잡고, 기기의 height 사이즈를 곱해 대응 값을 구할 때 사용
    func convertByHeightRatio(_ convert: CGFloat) -> CGFloat {
        return (convert / 812) * Numbers.height
    }
    
    func changeRootViewController(_ viewControllerToPresent: UIViewController) {
        if let window = view.window?.windowScene?.keyWindow {
            window.rootViewController = viewControllerToPresent
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
        } else {
            viewControllerToPresent.modalPresentationStyle = .overFullScreen
            self.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }
    
    /// toastMessage를 호출하는 메소드
    func showToast(message: String, controller: UIViewController) {
        let toastView = NottodoToastView(message: message, viewController: controller)
        view.addSubview(toastView)
        
        toastView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
            $0.directionalHorizontalEdges.equalToSuperview().inset(23)
            $0.height.equalTo(61)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteToast(_:)))
        toastView.addGestureRecognizer(tapGestureRecognizer)
        toastView.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn) {
            toastView.alpha = 1.0
        } completion: { _ in
            UIView.animate(withDuration: 0.4, delay: 1.5, options: .curveEaseOut) {
                toastView.alpha = 0.0
            } completion: { _ in
                toastView.removeFromSuperview()
            }
        }
    }
    
    @objc
    private func deleteToast(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    /// html을 string으로 변환하는 메소드
    func htmlToString(_ targetString: String) -> NSAttributedString? {
        let text = targetString

        guard let data = text.data(using: .utf8) else {
            return NSAttributedString()
        }
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
          return NSAttributedString()
        }
    }
    
    /// 화면 터치시 작성 종료하는 메서드
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc
    func dismissViewController() {
        self.dismiss(animated: true)
    }
    
    @objc
    func popViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
