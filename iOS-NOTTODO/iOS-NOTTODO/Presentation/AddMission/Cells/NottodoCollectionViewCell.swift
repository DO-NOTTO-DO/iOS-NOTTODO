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
    
    var fold: FoldState = .unfolded
    static let identifier = "NottodoCollectionViewCell"
    
    // MARK: - UI Components
    
    private let titleLabel = TitleLabel(title: I18N.nottodo)
    private let subTitleLabel = SubTitleLabel(subTitle: I18N.subNottodo,
                                              colorText: I18N.nottodo)
    private var addMissionTextField = AddMissionTextFieldView(frame: .zero)
    private let historyLabel = UILabel()
    private lazy var historyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUI()
        setLayout()
        setDelegate()
        registerCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func calculateCellHeight() -> CGFloat {
        var cellHeight: CGFloat = 0
        
        let itemWidth = self.bounds.width
        let titleLabelHeight = calculateLabelHeight(titleLabel.text, font: titleLabel.font, width: itemWidth)
        let subTitleLabelHeight = calculateLabelHeight(subTitleLabel.text, font: subTitleLabel.font, width: itemWidth)
        let textFieldViewHeight: CGFloat = 48
        let historyLabelHeight = calculateLabelHeight(historyLabel.text, font: historyLabel.font, width: itemWidth)
        var historyCollectionViewHeight: CGFloat = CGFloat(37 * MissionHistoryModel.items.count)
        historyCollectionViewHeight = historyCollectionViewHeight > 134 ? 134 : historyCollectionViewHeight
        let spacing: CGFloat = 16 + 10 + 24 + 11 + 6 + 32
        
        cellHeight = titleLabelHeight + subTitleLabelHeight + textFieldViewHeight + historyLabelHeight + historyCollectionViewHeight + spacing
        print(cellHeight, "??")
        return cellHeight
    }
}

private extension NottodoCollectionViewCell {
    func setUI() {
        backgroundColor = .gray1
        layer.borderColor = UIColor.gray3?.cgColor
        layer.cornerRadius = 12
        layer.borderWidth = 1
        historyCollectionView.backgroundColor = .clear
        historyCollectionView.indicatorStyle = .white
        
        historyLabel.do {
            $0.font = .Pretendard(.regular, size: 14)
            $0.text = I18N.missionHistoryLabel
            $0.textColor = .gray4
        }
    }
    
    func setLayout() {
        addSubviews(titleLabel, subTitleLabel, addMissionTextField,
                    historyLabel, historyCollectionView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(21)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(23)
        }
        
        addMissionTextField.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(25)
            $0.directionalHorizontalEdges.equalToSuperview().inset(23)
            $0.height.equalTo(48)
        }
        
        historyLabel.snp.makeConstraints {
            $0.top.equalTo(addMissionTextField.snp.bottom).offset(11)
            $0.leading.equalToSuperview().inset(24)
        }
        
        historyCollectionView.snp.makeConstraints {
            $0.top.equalTo(historyLabel.snp.bottom).offset(6)
            $0.directionalHorizontalEdges.equalToSuperview().inset(28)
            $0.bottom.equalToSuperview().inset(32)
        }
    }
    
    func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
    
    func registerCell() {
        historyCollectionView.register(MissionHistoryCollectionViewCell.self,
                                       forCellWithReuseIdentifier: MissionHistoryCollectionViewCell.identifier)
    }
    
    func setDelegate() {
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
