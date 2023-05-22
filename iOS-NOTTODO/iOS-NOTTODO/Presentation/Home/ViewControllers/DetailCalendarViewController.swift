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
    
    var anotherDate: [String] = []
    var dataSource: [String: Float] = [:]
    var userId: Int?
    var count: Int?
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    private lazy var today: Date = { return Date() }()
    
    // MARK: - UI Components
    
    private let monthCalendar = CalendarView(calendarScope: .month, scrollDirection: .horizontal)
    private let completeButton = UIButton()
    private let subLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let today = monthCalendar.calendar.today {
            requestMonthAPI(month: Utils.dateFormatterString(format: "yyyy-MM", date: today))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - Methods

extension DetailCalendarViewController {
    
    func reloadMonthData(month: String) {
        requestMonthAPI(month: month)
    }
    
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
        subLabel.do {
            $0.text = I18N.subText
            $0.font = .Pretendard(.regular, size: 12)
            $0.textColor = .gray4
        }
    }
    
    private func setLayout() {
        view.addSubviews(monthCalendar)
        monthCalendar.addSubviews(completeButton, subLabel)
        
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
            $0.height.equalTo((getDeviceWidth()-30)*1.2)
        }
        monthCalendar.calendar.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(45)
        }
        subLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(25)
            $0.left.equalToSuperview().offset(17)
        }
    }
}

extension DetailCalendarViewController {
    @objc
    func completeBtnTapped(sender: UIButton) {
        if let id = self.userId {
            requestAddAnotherDay(id: id, dates: anotherDate)
        }
        view.alpha = 0
        self.dismiss(animated: true)
        print("완료")
    }
}
extension DetailCalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        monthCalendar.yearMonthLabel.text = Utils.dateFormatterString(format: I18N.yearMonthTitle, date: calendar.currentPage)
        reloadMonthData(month: Utils.dateFormatterString(format: "yyyy-MM", date: calendar.currentPage))
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        var datesArray: [Date] = []
        var currentDate = today
        
        for _ in 0..<7 {
            datesArray.append(currentDate)
            let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
            currentDate = Calendar.current.startOfDay(for: nextDay!)
        }
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd"

        let formattedDatesArray = datesArray.map { dateFormatter.string(from: $0) }
        print("formattedDate:\(formattedDatesArray)")
        let arrayKeys = Array(dataSource.keys)
        print("arrayKeys:\(arrayKeys)")
        let formattedDate = Utils.dateFormatterString(format: nil, date: date)
        anotherDate.append(Utils.dateFormatterString(format: "YYYY.MM.dd", date: date))
        print("anotherDate:\(anotherDate)")
        return (!formattedDatesArray.contains(formattedDate) || !arrayKeys.contains(formattedDate)) && Utils.calendarSelected(today: today, date: date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let dateKeys = Array(dataSource.keys)
        
        if dateKeys.contains(Utils.dateFormatterString(format: nil, date: date)) {
            return .gray3
        }
        return .clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        Utils.calendarTitleColor(today: today, date: date, selected: true)
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
            Utils.calendarTitleColor(today: today, date: date, selected: false)
        }
}
extension DetailCalendarViewController {
    private func requestAddAnotherDay(id: Int, dates: [String]) {
        HomeAPI.shared.postAnotherDay(id: id, dates: dates) { [weak self] response in
            guard response != nil else { return }
        }
    }
    func requestMonthAPI(month: String) {
        AchieveAPI.shared.getAchieveCalendar(month: month) { [weak self] result in
            guard let result = result?.data else { return }
            self?.dataSource = [:]
            for item in result {
                self?.dataSource[item.actionDate] = item.percentage
                self?.count = self?.dataSource.count
            }
            self?.monthCalendar.calendar.reloadData()
        }
    }
}
