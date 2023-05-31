//
//  SituationCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/03/14.
//

import UIKit

import SnapKit
import Then

final class SituationCollectionViewCell: UICollectionViewCell, AddMissionMenu {
    
    // MARK: - Properties
    
    var missionCellHeight: ((CGFloat) -> Void)?
    private var fold: FoldState = .folded
    static let identifier = "SituationCollectionViewCell"
    
    // MARK: - UI Components
    
    private let titleLabel = TitleLabel(title: I18N.situation)
    private let subTitleLabel = SubTitleLabel(subTitle: I18N.subSituation,
                                              colorText: I18N.situation)
    private var addMissionTextField = AddMissionTextFieldView(textMaxCount: 10)
    private let recommendKeywordLabel = UILabel()
    private lazy var recommendCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLeftAlignLayout())
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUI()
        registerCell()
        setDelegate()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFoldState(_ state: FoldState) {
        fold = state
        missionCellHeight?(state == .folded ? 54 : 314)
        updateLayout()
        updateUI()
        contentView.layoutIfNeeded()
    }

}

private extension SituationCollectionViewCell {
    func setUI() {
        backgroundColor = .gray1
        layer.borderColor = UIColor.gray3?.cgColor
        layer.cornerRadius = 12
        layer.borderWidth = 1
        
        recommendCollectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
        }
        
        recommendKeywordLabel.do {
            $0.text = I18N.recommendKeyword
            $0.textColor = .white
            $0.font = .Pretendard(.medium, size: 14)
        }
    }
    
    func setLayout() {
        contentView.addSubviews(titleLabel, subTitleLabel, addMissionTextField,
                    recommendKeywordLabel, recommendCollectionView)
        updateLayout()
        updateUI()
    }
    
    private func updateLayout() {
        titleLabel.snp.remakeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(21)
        }
        
        subTitleLabel.snp.remakeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(23)
        }
        
        addMissionTextField.snp.remakeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(25)
            $0.directionalHorizontalEdges.equalToSuperview().inset(23)
            $0.height.equalTo(48)
        }

        recommendKeywordLabel.snp.remakeConstraints {
            $0.top.equalTo(addMissionTextField.snp.bottom).offset(14)
            $0.leading.equalToSuperview().inset(25)
        }

        recommendCollectionView.snp.remakeConstraints {
            $0.top.equalTo(recommendKeywordLabel.snp.bottom).offset(10)
            $0.directionalHorizontalEdges.equalToSuperview().inset(23)
            $0.bottom.equalToSuperview().inset(29)
        }
    }
    
    private func updateUI() {
        let isHidden: Bool = (fold == .folded)
        
        [titleLabel, subTitleLabel, addMissionTextField, recommendKeywordLabel, recommendCollectionView].forEach { $0.isHidden = isHidden }
    }
    
    func registerCell() {
        recommendCollectionView.register(RecommendKeywordCollectionViewCell.self,
                                         forCellWithReuseIdentifier: RecommendKeywordCollectionViewCell.identifier)
    }
    
    func setDelegate() {
        recommendCollectionView.delegate = self
        recommendCollectionView.dataSource = self
    }
    
    func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 8
        return layout
    }
}

extension SituationCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RecommendKeywordModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendKeywordCollectionViewCell.identifier, for: indexPath) as? RecommendKeywordCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(RecommendKeywordModel.items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RecommendKeywordCollectionViewCell else { fatalError() }
        addMissionTextField.setText(cell.getText())
    }
}

extension SituationCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = RecommendKeywordModel.items[indexPath.row].keyword
        let itemSize = item.size(withAttributes: [
            NSAttributedString.Key.font: UIFont.Pretendard(.medium, size: 14)
        ])
        return CGSize(width: itemSize.width + 34, height: itemSize.height + 8)
    }
}
