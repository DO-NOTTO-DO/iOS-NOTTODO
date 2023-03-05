//
//  AchievementViewController.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/15.
//

import UIKit

import FSCalendar
import Then
import SnapKit

final class AchievementViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let achievementLabel = UILabel()
    private let monthCalendar = CalendarView(calendarScope: .month, scrollDirection: .horizontal)
    private let statisticsView = UIView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - Methods

extension AchievementViewController {
    private func setUI() {
        view.backgroundColor = .ntdBlack
        scrollView.backgroundColor = .clear
        
        achievementLabel.do {
            $0.text = I18N.achievement
            $0.font = .Pretendard(.semiBold, size: 18)
            $0.textColor = .white
        }
        monthCalendar.do {
            $0.layer.cornerRadius = 12
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray4?.cgColor
        }
        statisticsView.do {
            $0.layer.cornerRadius = 12
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray4?.cgColor
        }
    }
    private func setLayout() {
        view.addSubview(scrollView)
        scrollView.addSubviews(achievementLabel, monthCalendar, statisticsView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeArea)
        }
        achievementLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(23)
            $0.leading.equalTo(safeArea).offset(21)
        }
        
        monthCalendar.snp.makeConstraints {
            $0.top.equalTo(achievementLabel.snp.bottom).offset(22)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(15)
            $0.height.equalTo((getDeviceWidth()-30)*1.1)
        }
        
        statisticsView.snp.makeConstraints {
            $0.top.equalTo(monthCalendar.snp.bottom).offset(20)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(15)
            $0.height.equalTo((getDeviceWidth()-30)*0.6)
            $0.bottom.equalTo(scrollView.snp.bottom).inset(20)
        }
    }
}
