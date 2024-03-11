//
//  NottodoCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/03/14.
//

import UIKit

import SnapKit
import Then

final class NottodoCollectionViewCell: UICollectionViewCell, AddMissionMenu {
    
    // MARK: - Properties
    
    static let identifier = "NottodoCollectionViewCell"
    var missionCellHeight: ((CGFloat) -> Void)?
    var missionTextData: (([String]) -> Void)?
    private var fold: FoldState = .folded
    private var recentMissionList: [RecentMissionResponseDTO] = []
    
    // MARK: - UI Components
    
    private let titleLabel = TitleLabel(title: I18N.nottodo)
    private let subTitleLabel = SubTitleLabel(subTitle: I18N.subNottodo,
                                              colorText: I18N.nottodo)
    private var addMissionTextField = AddMissionTextFieldView(textMaxCount: 20)
    private let historyLabel = UILabel()
    private lazy var historyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    private let stackView = UIStackView()
    private let foldStackView = UIStackView()
    private let paddingView = UIView()
    
    private let checkImage = UIImageView()
    private let enterMessage = UILabel()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUI()
        setDelegate()
        registerCell()
        setLayout()
        requestRecentMissionAPI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFoldState(_ state: FoldState) {
        fold = state
        missionCellHeight?(state == .folded ? 54 : 347)
        updateUI()
        layoutIfNeeded()
    }
    
    func setCellData(_ text: [String]) {
        if text.first!.isEmpty {
            enterMessage.text = I18N.enterMessage
            enterMessage.textColor = .gray3
            enterMessage.font = .Pretendard(.regular, size: 15)
        } else {
            enterMessage.text = text.first
            enterMessage.textColor = .white
            enterMessage.font = .Pretendard(.medium, size: 15)
        }
        addMissionTextField.setText(text.first!)
    }
}

extension NottodoCollectionViewCell {
    private func setUI() {
        backgroundColor = .clear
        layer.borderColor = UIColor.gray3?.cgColor
        layer.cornerRadius = 12
        layer.borderWidth = 1
        historyCollectionView.backgroundColor = .clear
        historyCollectionView.indicatorStyle = .white
        checkImage.image = .icChecked
        stackView.axis = .vertical
        addMissionTextField.setPlaceholder(I18N.nottodoPlaceholder)
        foldStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fill
        }
        
        historyLabel.do {
            $0.font = .Pretendard(.regular, size: 14)
            $0.text = I18N.missionHistoryLabel
            $0.textColor = .gray4
        }
        
        enterMessage.do {
            $0.text = I18N.enterMessage
            $0.textColor = .gray3
            $0.font = .Pretendard(.regular, size: 15)
        }
    }
    
    private func setLayout() {
        foldStackView.addArrangedSubviews(titleLabel, enterMessage, paddingView, checkImage)
        stackView.addArrangedSubviews(foldStackView, subTitleLabel, addMissionTextField,
                                      historyLabel, historyCollectionView)
        
        contentView.addSubviews(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(22)
        }
        
        stackView.do {
            $0.setCustomSpacing(10, after: foldStackView)
            $0.setCustomSpacing(19, after: subTitleLabel)
            $0.setCustomSpacing(11, after: addMissionTextField)
            $0.setCustomSpacing(6, after: historyLabel)
            $0.setCustomSpacing(32, after: historyCollectionView)
        }
        
        foldStackView.do {
            $0.setCustomSpacing(22, after: titleLabel)
        }
        
        checkImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18).priority(.high)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        addMissionTextField.snp.makeConstraints {
            $0.height.equalTo(49)
        }
        
        historyCollectionView.snp.makeConstraints {
            $0.height.equalTo(134)
        }
    }
    
    private func updateUI() {
        let isHidden: Bool = (fold == .folded)
        
        [subTitleLabel, addMissionTextField, historyLabel, historyCollectionView].forEach { $0.isHidden = isHidden }
        enterMessage.isHidden = !isHidden
        checkImage.isHidden = !isHidden ? true : addMissionTextField.getTextFieldText().isEmpty
        titleLabel.setTitleColor(isHidden)
        
        backgroundColor = isHidden ? .clear : .gray1
        layer.borderColor = isHidden ? UIColor.gray2?.cgColor : UIColor.gray3?.cgColor
        
        addMissionTextField.textFieldData = { string in
            self.missionTextData?(([string]))
        }
    }
    
    private func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
    
    private func registerCell() {
        historyCollectionView.register(MissionHistoryCollectionViewCell.self,
                                       forCellWithReuseIdentifier: MissionHistoryCollectionViewCell.identifier)
    }
    
    private func setDelegate() {
        historyCollectionView.delegate = self
        historyCollectionView.dataSource = self
    }
    
    private func requestRecentMissionAPI() {
        MissionAPI.shared.getRecentMission { [weak self] response in
            guard self != nil else { return }
            guard let response = response else { return }
            guard let data = response.data else { return }
            self?.recentMissionList = data
            self?.historyCollectionView.reloadData()
        }
    }
}

extension NottodoCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentMissionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionHistoryCollectionViewCell.identifier, for: indexPath) as? MissionHistoryCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(recentMissionList[indexPath.row].title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MissionHistoryCollectionViewCell else { fatalError() }
        addMissionTextField.setText(cell.getText())
        missionTextData?(([addMissionTextField.getTextFieldText()]))
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.CreateAndUpdateMissionCommon.clickMissionHistory(title: cell.getText()))
    }
}

extension NottodoCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 37)
    }
}
