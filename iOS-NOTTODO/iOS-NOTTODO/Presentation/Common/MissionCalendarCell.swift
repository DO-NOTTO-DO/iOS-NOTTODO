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
            return .icDate50
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
    var state: ToDoState = .none {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - UI Components
    
    private let iconView = UIImageView()
    private var padding = 8
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateUI()
        self.state = .none
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        contentView.insertSubview(iconView, at: 0)
        
        switch mode {
        case .month:
            titleLabel.snp.remakeConstraints {
                $0.center.equalToSuperview()
            }
            
            iconView.snp.makeConstraints {
                $0.edges.equalTo(UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
            }
            
        case .week:
            iconView.snp.makeConstraints {
                $0.height.width.equalTo(contentView.bounds.width - 10)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().inset(5)
            }
        @unknown default:
            iconView.snp.makeConstraints {
                $0.edges.equalTo(UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
            }
        }
    }
    private func updateUI() {
     //   iconView.image = .icDate50
        self.state = .none
        self.mode = .week
    }
}
extension MissionCalendarCell {
    func configure(_ state: ToDoState, _ mode: FSCalendarScope) {
        self.mode = mode
        self.state = state
        updateUI()
    }
}
