//
//  AddMissionViewController.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/15.
//

import UIKit

import SnapKit
import Then

enum FoldState {
    case folded, unfolded
    
    mutating func toggle() {
        self = (self == FoldState.folded) ? FoldState.unfolded : FoldState.folded
    }
}

final class AddMissionViewController: UIViewController {
    
    // MARK: Properties
    
    var isAdd: Bool = false {
        didSet {
            setAddButtonUI()
        }
    }
    private var foldStateList: [FoldState] = [.folded, .folded, .folded, .folded, .folded]
    
    private var heightList: [CGFloat] = [54, 54, 54, 54, 54]
    private var nottodoLabel: String?
    private var situationLabel: String?
    private var actionLabel: String?
    private var goalLabel: String?
    
    // MARK: - UI Components
    
    private let navigationView = UIView()
    private let dismissButton = UIButton()
    private let navigationTitle = UILabel()
    private let addButton = UIButton()
    private let separateView = UIView()
    
    private lazy var addMissionCollectionView = UICollectionView(frame: .zero,
                                                                 collectionViewLayout: layout())

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        registerCell()
        setDelegate()
        hideKeyboardWhenTappedAround()
    }
    
    func setNottodoLabel(_ text: String) {
        nottodoLabel = text
    }
    
    func setActionLabel(_ text: String) {
        actionLabel = text
    }
}

private extension AddMissionViewController {
    func setUI() {
        setAddButtonUI()
        view.backgroundColor = .ntdBlack
        separateView.backgroundColor = .gray2
        
        dismissButton.do {
            $0.setBackgroundImage(.icDelete, for: .normal)
            $0.addTarget(self, action: #selector(self.popViewController), for: .touchUpInside)
        }
        
        navigationTitle.do {
            $0.font = .Pretendard(.semiBold, size: 18)
            $0.textColor = .white
            $0.text = I18N.recommendNavTitle
        }
        
        addButton.do {
            $0.layer.cornerRadius = 26 / 2
            $0.titleLabel?.font = .Pretendard(.medium, size: 15)
            $0.setTitle(I18N.add, for: .normal)
            $0.setTitleColor(.gray3, for: .disabled)
            $0.setTitleColor(.gray1, for: .normal)
        }
        
        addMissionCollectionView.do {
            $0.backgroundColor = .clear
        }
    }
    
    func setAddButtonUI() {
        addButton.do {
            $0.isEnabled = isAdd
            $0.backgroundColor = isAdd ? .green2 : .gray2
        }
    }
    
    func setLayout() {
        navigationView.addSubviews(dismissButton, navigationTitle, addButton)
        view.addSubviews(navigationView, separateView, addMissionCollectionView)
        
        dismissButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(15)
        }
        
        navigationTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.trailing.equalToSuperview().inset(19)
            $0.width.equalTo(60)
            $0.height.equalTo(26)
        }
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(58)
        }
        
        separateView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(0.7)
        }
        
        addMissionCollectionView.snp.makeConstraints {
            $0.top.equalTo(separateView.snp.bottom).offset(12)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 14
        layout.footerReferenceSize = CGSize(width: getDeviceWidth(), height: 319)
        return layout
    }
    
    func setDelegate() {
        addMissionCollectionView.delegate = self
        addMissionCollectionView.dataSource = self
    }
    
    func registerCell() {
        addMissionCollectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: DateCollectionViewCell.identifier)
        addMissionCollectionView.register(NottodoCollectionViewCell.self,
                                          forCellWithReuseIdentifier: NottodoCollectionViewCell.identifier)
        addMissionCollectionView.register(SituationCollectionViewCell.self,
                                          forCellWithReuseIdentifier: SituationCollectionViewCell.identifier)
        addMissionCollectionView.register(ActionCollectionViewCell.self,
                                          forCellWithReuseIdentifier: ActionCollectionViewCell.identifier)
        addMissionCollectionView.register(GoalCollectionViewCell.self,
                                          forCellWithReuseIdentifier: GoalCollectionViewCell.identifier)
        addMissionCollectionView.register(AddMissionFooterCollectionReusableView.self,
                                          forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                          withReuseIdentifier: AddMissionFooterCollectionReusableView.identifier)
    }
}

extension AddMissionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foldStateList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = makeCollectionCell(collectionView: collectionView, for: indexPath)
        
        guard var missionMenuCell = cell as? AddMissionMenu else {
            return UICollectionViewCell()
        }
        
        let currentFoldState = foldStateList[indexPath.row]
        
        missionMenuCell.missionCellHeight = { [weak self] height in
            
            self?.heightList[indexPath.row] = height
            self?.addMissionCollectionView.collectionViewLayout.collectionView?.reloadItems(at: [indexPath])
        }
                
        missionMenuCell.setFoldState(currentFoldState)

        return cell
    }
}

extension AddMissionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = UIScreen.main.bounds.width - 40
        let height = heightList[indexPath.row]

        return CGSize(width: cellWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AddMissionFooterCollectionReusableView.identifier, for: indexPath) as? AddMissionFooterCollectionReusableView else { return UICollectionReusableView() }
            return footer
        } else { return UICollectionReusableView() }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        addMissionCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        foldStateList[indexPath.row].toggle()
        addMissionCollectionView.reloadData()
    }
}

extension AddMissionViewController {
    private func makeCollectionCell(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionViewCell.identifier, for: indexPath) as? DateCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NottodoCollectionViewCell.identifier, for: indexPath) as? NottodoCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SituationCollectionViewCell.identifier, for: indexPath) as? SituationCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActionCollectionViewCell.identifier, for: indexPath) as? ActionCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case 4:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalCollectionViewCell.identifier, for: indexPath) as? GoalCollectionViewCell else { return UICollectionViewCell() }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
