//
//  SwitchView.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/03/20.
//

import UIKit

import SnapKit

// MARK: - Protocols

protocol SwitchDelegate: AnyObject {
    func switchStateChanged(_ switch: Switch, isOn: Bool)
}

public class Switch: UIView {

    enum Number {
        static let circleInnerPadding: CGFloat = 2
        static let circleWidthHeight: CGFloat = 24
        static let containerWidth: CGFloat = 50
        static let containerHeight: CGFloat = 30
        static let duration: CGFloat = 0.2
    }

    // MARK: - UIComponents
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .purple
        return view
    }()

    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    // MARK: - Properties
    private var isOn: Bool = true
    weak var delegate: SwitchDelegate?

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)

        setViewHierchy()
        setDefaultConstraints()
        setLayout()
        makeViewRounded()
        setClickEvent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    @objc
    private func switchDidTap(sender: UITapGestureRecognizer) {
        self.isOn.switch()
        if self.isOn {
            self.turnOn()
        } else {
            self.turnOff()
        }
        self.delegate?.switchStateChanged(self, isOn: self.isOn)
    }

    // MARK: - Methods
    private func setViewHierchy() {
        self.addSubview(containerView)
        self.containerView.addSubview(circleView)
    }

    private func setDefaultConstraints() {
        self.snp.makeConstraints { make in
            make.width.equalTo(Number.containerWidth)
            make.height.equalTo(Number.containerHeight)
        }
    }

    private func setLayout() {
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.circleView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(Number.circleInnerPadding)
            make.width.height.equalTo(Number.circleWidthHeight)
        }
    }

    private func makeViewRounded() {
        self.makeRounded(radius: Number.containerHeight / 2)
        self.circleView.makeRounded(radius: Number.circleWidthHeight / 2)
    }

    private func setClickEvent() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(switchDidTap(sender:)))
        self.addGestureRecognizer(tapGesture)
    }

    private func turnOn() {
        self.circleView.snp.remakeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(Number.circleInnerPadding)
            make.width.height.equalTo(Number.circleWidthHeight)
        }

        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
            self.containerView.backgroundColor = .purple
        }
    }

    private func turnOff() {
        self.circleView.snp.remakeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(Number.circleInnerPadding)
            make.width.height.equalTo(Number.circleWidthHeight)
        }

        UIView.animate(withDuration: Number.duration) {
            self.layoutIfNeeded()
            self.containerView.backgroundColor = .gray
        }
    }

}

// TODO: - Global 모듈로 이동
extension UIView {

    func makeRounded(radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }

}
