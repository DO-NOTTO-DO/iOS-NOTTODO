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
    private lazy var today: Date = { return Date() }()
    var dataSource: [String: Float] = [:]
    var selectDate: Date?
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let achievementLabel = UILabel()
    private let monthCalendar = CalendarView(calendarScope: .month, scrollDirection: .horizontal)
    private let statisticsView = StatisticsView()
    
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

extension AchievementViewController {
    
    func reloadMonthData(month: String) {
        requestMonthAPI(month: month)
    }
    
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
            $0.calendar.register(MissionCalendarCell.self, forCellReuseIdentifier: MissionCalendarCell.identifier)
            $0.calendar.delegate = self
            $0.calendar.dataSource = self
            $0.monthCalendarClosure = { [self] result in
                let month = result
                self.reloadMonthData(month: month)
            }
        }
    }
    private func setLayout() {
        view.addSubview(scrollView)
        scrollView.addSubviews(achievementLabel, monthCalendar, statisticsView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeArea)
        }
        achievementLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(23)
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
    func requestMonthAPI(month: String) {
        AchieveAPI.shared.getAchieveCalendar(month: month) { [weak self] result in
            guard let result = result?.data else { return }
            self?.dataSource = [:]
            for item in result {
                self?.dataSource[item.actionDate] = item.percentage
            }
            self?.monthCalendar.calendar.reloadData()
        }
    }
}

extension AchievementViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        monthCalendar.yearMonthLabel.text = Utils.dateFormatterString(format: I18N.yearMonthTitle, date: calendar.currentPage)
        reloadMonthData(month: Utils.dateFormatterString(format: "yyyy-MM", date: calendar.currentPage))
    }
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        Utils.dateFormatterString(format: "dd", date: date)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendar.appearance.selectionColor = .clear
        calendar.appearance.titleSelectionColor = .white
        let dateString = Utils.dateFormatterString(format: "yyyy-MM-dd", date: date)
        if self.dataSource.contains(where: { $0.key == dateString }) {
            let vc = DetailAchievementViewController()
            vc.selectedDate = date
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: false)
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        Calendar.current.isDate(date, equalTo: calendar.currentPage, toGranularity: .month)
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: MissionCalendarCell.identifier, for: date, at: position) as! MissionCalendarCell
        let dateString = Utils.dateFormatterString(format: "yyyy-MM-dd", date: date)
        let count = self.dataSource.count
        if let percentage = self.dataSource[dateString] {
            if count == 1 {
                switch percentage {
                case 1:
                    cell.configure(.rateFull, .month)
                default:
                    cell.configure(.none, .month)
                }
            }
            else if count == 2 {
                switch percentage {
                case 0.5:
                    cell.configure(.rateHalf, .month)
                case 1:
                    cell.configure(.rateFull, .month)
                default:
                    cell.configure(.none, .month)
                }
            } else {
                switch percentage {
                case 0:
                    cell.configure(.none, .month)
                case 1.0:
                    cell.configure(.rateFull, .month)
                default:
                    cell.configure(.rateHalf, .month)
                }
            }
        }
        return cell
    }
}
