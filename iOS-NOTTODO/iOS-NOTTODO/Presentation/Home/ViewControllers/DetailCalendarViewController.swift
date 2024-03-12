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

final class DetailCalendarViewController: UIViewController {
    
    // MARK: - Properties
    
    var anotherDate: [String] = [] {
        didSet {
            updateUI()
        }
    }
    var invalidDate: [String] = []
    var dataSource: [String: Float] = [:]
    var detailModel: MissionDetailResponseDTO?
    var userId: Int?
    var count: Int?
    var movedateClosure: ((_ date: String) -> Void)?
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    private lazy var today: Date = { return Date() }()
    private weak var coordinator: HomeCoordinator?
    
    // MARK: - UI Components
    
    private let monthCalendar = CalendarView(calendarScope: .month, scrollDirection: .horizontal)
    private let completeButton = UIButton()
    private let subLabel = UILabel()
    
    // MARK: - init
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.SelectDate.appearAnotherDayModal)
        
        if let id = self.userId {
            requestParticualrDatesAPI(id: id)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first!
        let location = touch.location(in: self.view)
        
        if !monthCalendar.frame.contains(location) {
            coordinator?.dismissLastPresentedViewController()
        }
    }
}

// MARK: - Methods

extension DetailCalendarViewController {
    
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.6)
        
        completeButton.do {
            $0.setTitle(I18N.detailComplete, for: .normal)
            $0.titleLabel?.font = .Pretendard(.medium, size: 16)
            $0.addTarget(self, action: #selector(completeBtnTapped(sender:)), for: .touchUpInside)
            
        }
        
        monthCalendar.do {
            $0.layer.cornerRadius = 12
            $0.configure(delegate: self, datasource: self)
        }
        
        subLabel.do {
            $0.text = I18N.subText
            $0.font = .Pretendard(.regular, size: 12)
            $0.textColor = .gray4
        }
        
        updateUI()
    }
    
    private func updateUI() {
        completeButton.do {
            if anotherDate.count == 0 {
                $0.isEnabled = false
                $0.setTitleColor(.gray4, for: .normal)
            } else {
                $0.isEnabled = true
                $0.setTitleColor(.white, for: .normal)
            }
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
        
        monthCalendar.snp.makeConstraints {
            $0.centerY.equalTo(safeArea)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(15)
            $0.height.equalTo((Numbers.width-30)*1.2)
        }
        
        subLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(25)
            $0.left.equalToSuperview().offset(17)
        }
        
        monthCalendar.updateConstraints()
    }
}

extension DetailCalendarViewController {
    
    @objc
    func completeBtnTapped(sender: UIButton) {
        guard let data = self.detailModel else { return }
        if let id = self.userId {
            requestAddAnotherDay(id: id, dates: anotherDate)
            AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.SelectDate.completeAddMissionAnotherDay(title: data.title,
                                                                                                                situation: data.situation,
                                                                                                                goal: data.goal,
                                                                                                                action: data.actions.map { $0.name }
                                                                                                                , date: anotherDate))
        }
    }
}

extension DetailCalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        monthCalendar.configureYearMonth(to: Utils.dateFormatterString(format: I18N.yearMonthTitle, date: calendar.currentPage))
        guard let id = self.userId else { return }
        requestParticualrDatesAPI(id: id)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        var datesArray: [Date] = []
        var currentDate = today
        
        for _ in 0..<7 {
            datesArray.append(currentDate)
            let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
            currentDate = Calendar.current.startOfDay(for: nextDay!)
        }
        
        let formattedDatesArray = datesArray.map { Utils.dateFormatterString(format: "yyyy.MM.dd", date: $0) }
        let formattedDate = Utils.dateFormatterString(format: "yyyy.MM.dd", date: date)
        
        return (!formattedDatesArray.contains(formattedDate) || !invalidDate.contains(formattedDate)) && Utils.calendarSelected(today: today, date: date)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        anotherDate.append(Utils.dateFormatterString(format: "yyyy.MM.dd", date: date))
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectDate = Utils.dateFormatterString(format: "yyyy.MM.dd", date: date)
        if let index = anotherDate.firstIndex(of: selectDate) {
            anotherDate.remove(at: index)
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if self.invalidDate.contains(Utils.dateFormatterString(format: "yyyy.MM.dd", date: date)) {
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
        MissionAPI.shared.postAnotherDay(id: id, dates: dates) { response in
            guard response != nil else { return }
            guard let statusCode = response?.status else { return }
            switch statusCode {
            case 200..<204:
                self.setUI()
                self.coordinator?.dismiss()
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.SelectDate.closeAnotherDayModal)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy.MM.dd"
                if let earliestDate = dateFormatter.date(from: self.anotherDate.min() ?? "") {
                    let earliestDateString = dateFormatter.string(from: earliestDate)
                    self.movedateClosure?(earliestDateString)
                }
            default:
                self.showToast(message: self.htmlToString(response?.message ?? "")?.string ?? "", controller: self)
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.SelectDate.appearMaxedIssueMessage)
            }
        }
    }
    
    func requestParticualrDatesAPI(id: Int) {
        MissionAPI.shared.particularMissionDates(id: id) { [weak self] response in
            guard let dates = response.data else { return }
            self?.invalidDate = dates
            self?.monthCalendar.reloadCollectionView()
        }
    }
}
