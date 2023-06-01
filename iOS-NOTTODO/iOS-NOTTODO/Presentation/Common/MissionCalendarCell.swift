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
        case .rateHalf:
            return .icDate50
        case .rateFull:
            return .icDate100
        case .none:
            return nil
        }
    }
}

final class MissionCalendarCell: FSCalendarCell {
    
    // MARK: - Properties
    
    static let identifier = "MissionCalendarCell"
    
    var mode: FSCalendarScope = .week
    var state: ToDoState = .none
    
    // MARK: - UI Components
    
    let iconView = UIImageView()
    private var padding = 8
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateUI(state: .none)
        self.state = .none
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
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
    
    private func setLayout() {
        iconView.snp.makeConstraints {
            $0.height.width.equalTo(contentView.bounds.width - 10)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(5)
        }
        subtitleLabel.snp.updateConstraints {
            $0.centerY.equalTo(iconView.snp.centerY)
        }
    }
    
    private func updateUI(state: ToDoState) {
        iconView.image = state.icon
    }
    
    func configure(_ state: ToDoState, _ mode: FSCalendarScope) {
        self.mode = mode
        self.state = state
        setLayout()
        updateUI(state: state)
    }
}
