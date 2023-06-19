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
    
    static let identifier = "SituationCollectionViewCell"
    var missionCellHeight: ((CGFloat) -> Void)?
    var missionTextData: ((String) -> Void)?
    private var fold: FoldState = .folded
    private var recommendSituatoinList: [RecommendSituationResponseDTO] = []
    
    // MARK: - UI Components
    
    private let titleLabel = TitleLabel(title: I18N.situation)
    private let subTitleLabel = SubTitleLabel(subTitle: I18N.subSituation,
                                              colorText: I18N.situation)
    private var addMissionTextField = AddMissionTextFieldView(textMaxCount: 10)
    private let recommendKeywordLabel = UILabel()
    private lazy var recommendCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLeftAlignLayout())
    
    private let stackView = UIStackView()
    private let foldStackView = UIStackView()
    private let paddingView = UIView()
    
    private let checkImage = UIImageView()
    private let enterMessage = UILabel()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUI()
        registerCell()
        setDelegate()
        setLayout()
        requestRecommendSituationAPI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFoldState(_ state: FoldState) {
        fold = state
        missionCellHeight?(state == .folded ? 54 : 314)
        updateUI()
        contentView.layoutIfNeeded()
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
        checkImage.isHidden = text.first!.isEmpty || fold == .unfolded
        addMissionTextField.setText(text.first!)
    }
}

private extension SituationCollectionViewCell {
    func setUI() {
        backgroundColor = .clear
        layer.borderColor = UIColor.gray3?.cgColor
        layer.cornerRadius = 12
        layer.borderWidth = 1
        checkImage.image = .icChecked
        stackView.axis = .vertical
        foldStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.spacing = 35
        }
        
        recommendCollectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = true               // 동적 뷰 계산 후 수정
        }
        
        recommendKeywordLabel.do {
            $0.text = I18N.recommendKeyword
            $0.textColor = .white
            $0.font = .Pretendard(.medium, size: 14)
        }
        
        enterMessage.do {
            $0.text = I18N.enterMessage
            $0.textColor = .gray3
            $0.font = .Pretendard(.regular, size: 15)
        }
    }
    
    func setLayout() {
        foldStackView.addArrangedSubviews(titleLabel, enterMessage, paddingView, checkImage)
        stackView.addArrangedSubviews(foldStackView, subTitleLabel, addMissionTextField,
                                      recommendKeywordLabel, recommendCollectionView)
        contentView.addSubviews(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(22)
        }
        
        stackView.do {
            $0.setCustomSpacing(10, after: foldStackView)
            $0.setCustomSpacing(25, after: subTitleLabel)
            $0.setCustomSpacing(14, after: addMissionTextField)
            $0.setCustomSpacing(10, after: recommendKeywordLabel)
            $0.setCustomSpacing(29, after: recommendCollectionView)
        }
        
        checkImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18).priority(.high)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        
        addMissionTextField.snp.makeConstraints {
            $0.height.equalTo(49)
        }
        
        recommendCollectionView.snp.makeConstraints {
            $0.height.equalTo(60)
        }
    }
    
    private func updateUI() {
        let isHidden: Bool = (fold == .folded)
        
        [subTitleLabel, addMissionTextField, recommendKeywordLabel, recommendCollectionView].forEach { $0.isHidden = isHidden }
        enterMessage.isHidden = !isHidden
        titleLabel.setTitleColor(isHidden)
        
        backgroundColor = isHidden ? .clear : .gray1
        layer.borderColor = isHidden ? UIColor.gray2?.cgColor : UIColor.gray3?.cgColor
        
        addMissionTextField.textFieldData = { string in
            self.missionTextData?((string))
        }
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
    
    func requestRecommendSituationAPI() {
        AddMissionAPI.shared.getRecommendSituation { [weak self] response in
            guard self != nil else { return }
            guard let response = response else { return }
            guard let data = response.data else { return }
            self?.recommendSituatoinList = data
            self?.recommendCollectionView.reloadData()
        }
    }
}

extension SituationCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendSituatoinList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendKeywordCollectionViewCell.identifier, for: indexPath) as? RecommendKeywordCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(recommendSituatoinList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RecommendKeywordCollectionViewCell else { fatalError() }
        addMissionTextField.setText(cell.getText())
        missionTextData?((addMissionTextField.getTextFieldText()))
    }
}

extension SituationCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = recommendSituatoinList[indexPath.row].name
        let itemSize = item.size(withAttributes: [
            NSAttributedString.Key.font: UIFont.Pretendard(.medium, size: 14)
        ])
        return CGSize(width: itemSize.width + 34, height: itemSize.height + 8)
    }
}
