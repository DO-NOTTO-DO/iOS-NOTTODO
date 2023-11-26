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
    
    var mode: FSCalendarScope = .week {
        didSet {
            setLayout()
        }
    }
    var state: ToDoState = .none {
        didSet {
            updateUI(state: self.state)
        }
    }
    
    // MARK: - UI Components
    
    private let iconView = UIImageView()
    
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
        switch mode {
        case .month:
            iconView.snp.remakeConstraints {
                $0.height.equalToSuperview()
                $0.width.equalTo(contentView.bounds.size.height)
                $0.center.equalToSuperview()
            }
            
            titleLabel.snp.remakeConstraints {
                $0.centerY.equalToSuperview().offset(-1)
                $0.centerX.equalToSuperview()
            }
        case .week:
            iconView.snp.remakeConstraints {
                $0.height.width.equalTo(contentView.bounds.width - 8)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().inset(5)
            }
            subtitleLabel.snp.updateConstraints {
                $0.centerY.equalTo(iconView.snp.centerY)
            }
            
        @unknown default:
            break
        }
        
    }
    
    private func updateUI(state: ToDoState) {
        iconView.image = state.icon
    }
    
    func configure(percent: Float) {
        switch percent {
        case 0.0:
            self.state = .none
        case 1.0:
            self.state = .rateFull
        default:
            self.state = .rateHalf
        }
    }
}
