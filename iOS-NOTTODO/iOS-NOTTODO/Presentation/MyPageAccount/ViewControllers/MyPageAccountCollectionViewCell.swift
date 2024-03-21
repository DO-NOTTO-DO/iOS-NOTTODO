//
//  MyInfoAccountCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/15/24.
//

import UIKit
import Combine

import SnapKit
import Then

final class MyPageAccountCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MyPageAccountCollectionViewCell"
    
    // MARK: - Properties
    
    var switchTapped = PassthroughSubject<Bool, Never>()
    var cancelBag = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    private let notificationSwitch = UISwitch()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
        setBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension MyPageAccountCollectionViewCell {
    
    private func setUI() {
        backgroundColor = .gray1
        
        titleLabel.do {
            $0.font = .Pretendard(.medium, size: 14)
            $0.numberOfLines = 0
            $0.textAlignment = .left
        }
        
        contentLabel.do {
            $0.font = .Pretendard(.regular, size: 14)
            $0.textColor = .gray6
            $0.numberOfLines = 0
            $0.textAlignment = .right
        }
        
        notificationSwitch.do {
            $0.onTintColor = .green2
        }
    }
    
    private func setLayout() {
        contentView.addSubviews(titleLabel, contentLabel, notificationSwitch)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview()
        }
        
        notificationSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(30)
            $0.width.equalTo(50)
        }
    }
    
    func configure(data: AccountRowData) {
        titleLabel.textColor = data.titleColor
        titleLabel.text = data.title
        contentLabel.text = data.content
        notificationSwitch.setOn(data.isOn, animated: true)

        notificationSwitch.isHidden = !data.isSwitch
        contentLabel.isHidden = data.isSwitch
    }
    
    func setBindings() {
        notificationSwitch.tapPublisher
            .sink { [weak self] isOn in
                guard let self else { return }
                self.switchTapped.send(isOn)
            }
            .store(in: &cancelBag)
    }
}

// 임시 코드 - 윤서 코드 merge 후 삭제
extension UIControl {
    func controlPublisher(for event: UIControl.Event) -> UIControl.EventPublisher {
        return UIControl.EventPublisher(control: self, event: event)
    }
    
    // Publisher
    struct EventPublisher: Publisher {
        typealias Output = UIControl
        typealias Failure = Never
        
        let control: UIControl
        let event: UIControl.Event
        
        func receive<S>(subscriber: S)
        where S: Subscriber, Never == S.Failure, UIControl == S.Input {
            let subscription = EventSubscription(
                control: control,
                subscriber: subscriber,
                event: event
            )
            subscriber.receive(subscription: subscription)
        }
    }
    
    // Subscription
    fileprivate class EventSubscription<EventSubscriber: Subscriber>: Subscription
    where EventSubscriber.Input == UIControl, EventSubscriber.Failure == Never {
        let control: UIControl
        let event: UIControl.Event
        var subscriber: EventSubscriber?
        
        init(control: UIControl, subscriber: EventSubscriber, event: UIControl.Event) {
            self.control = control
            self.subscriber = subscriber
            self.event = event
            control.addTarget(self, action: #selector(eventDidOccur), for: event)
        }
        
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() {
            subscriber = nil
            control.removeTarget(self, action: #selector(eventDidOccur), for: event)
        }
        
        @objc func eventDidOccur() {
            _ = subscriber?.receive(control)
        }
    }
}

extension UISwitch {
    var tapPublisher: AnyPublisher<Bool, Never> {
        controlPublisher(for: .valueChanged)
            .map { control in
                guard let uiSwitch = control as? UISwitch else { return false }
                return uiSwitch.isOn
            }
            .eraseToAnyPublisher()
    }
}
