//
//  DetailAchievementViewController.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/14.
//

import UIKit

import Then
import SnapKit

class DetailAchievementViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
        
    // MARK: - UI Components
    
    private let backGroundView = UIView()
    private let dateLabel = UILabel()
    private let verticalStackView = UIStackView()
    private let mission1 = DetailMissionView(tag: "출근 시간", title: "아침 거르지 않기", isHidden: false)
    private let mission2 = DetailMissionView(tag: "아침", title: "공복에 커피 마시지 않기", isHidden: true)
    private let mission3 = DetailMissionView(tag: "출근 시간", title: "아침 거르지 않기", isHidden: true)

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setRecognizer()
    }
}

// MARK: - Methods

extension DetailAchievementViewController {
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.8)

        backGroundView.do {
            $0.layer.cornerRadius = 15
            $0.backgroundColor = .white
            $0.isUserInteractionEnabled = false
        }
        dateLabel.do {
            $0.text = "2023년 12월 11일"
            $0.font = .Pretendard(.semiBold, size: 18)
            $0.textColor = .gray2
            $0.textAlignment = .center
        }
        verticalStackView.do {
            $0.addArrangedSubviews(mission1, mission2, mission3)
            $0.axis = .vertical
            $0.spacing = 0
            $0.distribution = .equalSpacing
        }
        
    }
    
    private func setRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setLayout() {
        view.addSubview(backGroundView)
        backGroundView.addSubviews(dateLabel, verticalStackView)
        
        backGroundView.snp.makeConstraints {
            $0.center.equalTo(safeArea)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(15)
            $0.height.equalTo(getDeviceWidth()*1.1)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(26)
            $0.centerX.equalToSuperview()
        }
        verticalStackView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
        }
    }

    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        dismiss(animated: false)
    }
}
