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
    
    var state: ToDoState = .none {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - UI Components
    
    private let iconView = UIImageView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        titleLabel.snp.remakeConstraints {
            $0.center.equalToSuperview()
        }
        
        contentView.insertSubview(iconView, at: 0)
        iconView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    private func updateUI() {
        iconView.backgroundColor = .yellow
        }
}
extension MissionCalendarCell {
    func configure(_ state: ToDoState) {
        self.state = state
        updateUI()
    }
}
