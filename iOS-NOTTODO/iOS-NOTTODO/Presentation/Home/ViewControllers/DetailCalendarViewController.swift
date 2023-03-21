//
//  DetailCalendarViewController.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/13.
//

import UIKit

import FSCalendar
import Then
import SnapKit

class DetailCalendarViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    private lazy var today: Date = { return Date() }()
    
    // MARK: - UI Components
    
    private let monthCalendar = CalendarView(calendarScope: .month, scrollDirection: .horizontal)
    private let completeButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - Methods

extension DetailCalendarViewController {
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.6)
        
        completeButton.do {
            $0.setTitle(I18N.detailComplete, for: .normal)
            $0.setTitleColor(.gray4, for: .normal)
            $0.titleLabel?.font = .Pretendard(.medium, size: 16)
            $0.addTarget(self, action: #selector(completeBtnTapped(sender:)), for: .touchUpInside)
        }
        monthCalendar.do {
            $0.layer.cornerRadius = 12
            $0.calendar.delegate = self
            $0.calendar.dataSource = self
        }
    }
    
    private func setLayout() {
        view.addSubviews(monthCalendar)
        monthCalendar.addSubview(completeButton)
        
        completeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(CGSize(width: 44, height: 35))
        }
        
        monthCalendar.horizonStackView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(54)
        }
        
        monthCalendar.snp.makeConstraints {
            $0.centerY.equalTo(safeArea)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(15)
            $0.height.equalTo((getDeviceWidth()-30)*1.1)
        }
    }
}

extension DetailCalendarViewController {
    @objc
    func completeBtnTapped(sender: UIButton) {
        view.alpha = 0
        self.dismiss(animated: true)
        print("완료")
    }
}
extension DetailCalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        monthCalendar.yearMonthLabel.text = Utils.DateFormatterString(format: I18N.yearMonthTitle, date: calendar.currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
     //   switch calendar.to
        Utils.calendarSelected(today: today, date: date)
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        Utils.calendarTitleColor(today: today, date: date, selected: true)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        Utils.calendarTitleColor(today: today, date: date, selected: false)
    }
}
