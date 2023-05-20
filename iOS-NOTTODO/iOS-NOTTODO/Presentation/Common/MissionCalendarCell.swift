//
//  MissionCalendarCell.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/17.
//

import Foundation

import FSCalendar
import Then
import SnapKit

enum ToDoState {
    case none
    case rateHalf
    case rateFull
}
extension ToDoState {
    var icon: UIImage? {
        switch self {
        case .none:
            return nil
        case .rateHalf:
            return .icDate50
        case .rateFull:
            return .icDate100
        }
    }
}

final class MissionCalendarCell: FSCalendarCell {
    
    // MARK: - Properties
    
    static let identifier = "HomeEmptyCollectionViewCell"
    
    var mode: FSCalendarScope = .week
    var state: ToDoState = .none
    
    // MARK: - UI Components

    private let iconView = UIImageView()
    private var padding = 8
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout(mode: mode)
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension MissionCalendarCell {
    
    private func setUI() {
        contentView.insertSubview(iconView, at: 0)
    }
    
    private func setLayout(mode: FSCalendarScope) {
        switch mode {
        case .week:
            iconView.snp.makeConstraints {
                $0.height.width.equalTo(contentView.bounds.width - 10)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().inset(5)
            }
        case .month:
            titleLabel.snp.updateConstraints {
                $0.center.equalToSuperview()
            }
            
            iconView.snp.remakeConstraints {
                $0.edges.equalTo(UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
            }
        @unknown default:
            fatalError()
        }
    }
    
    private func updateUI(state: ToDoState) {
        iconView.image = state.icon
    }
    
    func configure(_ state: ToDoState, _ mode: FSCalendarScope) {
        self.mode = mode
        self.state = state
        setLayout(mode: mode)
        updateUI(state: state)
    }
}
