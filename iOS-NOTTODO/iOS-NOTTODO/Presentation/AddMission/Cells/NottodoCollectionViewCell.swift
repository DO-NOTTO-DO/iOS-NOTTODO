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
    
    var missionCellHeight: ((CGFloat) -> Void)?
    private var fold: FoldState = .folded
    static let identifier = "NottodoCollectionViewCell"
    
    // MARK: - UI Components
    
    private let titleLabel = TitleLabel(title: I18N.nottodo)
    private let subTitleLabel = SubTitleLabel(subTitle: I18N.subNottodo,
                                              colorText: I18N.nottodo)
    private var addMissionTextField = AddMissionTextFieldView(textMaxCount: 20)
    private let historyLabel = UILabel()
    private let stackView = UIStackView()
    private let foldStackView = UIStackView()
    private let paddingView = UIView()
    private lazy var historyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    private var currentValue: String?
    private let enterMessage = UILabel()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUI()
        setDelegate()
        registerCell()
        setLayout()
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
    
    func getText() -> String {
        return addMissionTextField.getTextFieldText()
    }
}

extension NottodoCollectionViewCell {
    private func setUI() {
        backgroundColor = .gray1
        layer.borderColor = UIColor.gray3?.cgColor
        layer.cornerRadius = 12
        layer.borderWidth = 1
        historyCollectionView.backgroundColor = .clear
        historyCollectionView.indicatorStyle = .white
        stackView.axis = .vertical
        foldStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.spacing = 22
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
        foldStackView.addArrangedSubviews(titleLabel, enterMessage, paddingView)
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
        titleLabel.setTitleColor(isHidden)
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
}

extension NottodoCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MissionHistoryModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionHistoryCollectionViewCell.identifier, for: indexPath) as? MissionHistoryCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(MissionHistoryModel.items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MissionHistoryCollectionViewCell else { fatalError() }
        addMissionTextField.setText(cell.getText())
    }
}

extension NottodoCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 37)
    }
}
