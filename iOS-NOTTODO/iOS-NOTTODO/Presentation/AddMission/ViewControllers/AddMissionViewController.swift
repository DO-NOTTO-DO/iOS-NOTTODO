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
    private var dateList: [String] = []
    private var nottodoInfoList: [String] = ["", "", "", "", ""] {
        didSet {
            isAdd = !nottodoInfoList[1].isEmpty && !nottodoInfoList[2].isEmpty
        }
    }
    
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
    
    func setDate(_ date: String) {
        dateList.append(date)
    }
    
    func setNottodoLabel(_ text: String) {
        nottodoInfoList[1] = text
    }
    
    func setSituationLabel(_ text: String) {
        nottodoInfoList[2] = text
    }
    
    func setActionLabel(_ text: String) {
        nottodoInfoList[3] = text
    }
}

extension AddMissionViewController {
    private func setUI() {
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
    
    private func setAddButtonUI() {
        addButton.do {
            $0.isEnabled = isAdd
            $0.backgroundColor = isAdd ? .green2 : .gray2
        }
    }
    
    private func setLayout() {
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
    
    private func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 14
        layout.footerReferenceSize = CGSize(width: getDeviceWidth(), height: 319)
        return layout
    }
    
    private func setDelegate() {
        addMissionCollectionView.delegate = self
        addMissionCollectionView.dataSource = self
    }
    
    private func registerCell() {
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
        let currentDateList = dateList
        
        missionMenuCell.setFoldState(currentFoldState)
        if indexPath.row == 0 {
            missionMenuCell.setCellData(currentDateList)
            missionMenuCell.missionTextData = { [weak self] string in
                self?.dateList = string
            }
        } else {
            let currentCellInfo = nottodoInfoList[indexPath.row]
            missionMenuCell.missionTextData = { [weak self] string in
                self?.nottodoInfoList[indexPath.row] = string.first!
            }
            missionMenuCell.setCellData([currentCellInfo])
        }

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
        
        let cell = makeCollectionCell(collectionView: collectionView, for: indexPath)
        guard var missionMenuCell = cell as? AddMissionMenu else {
            return
        }
        
        missionMenuCell.missionCellHeight = { [weak self] height in
            self?.heightList[indexPath.row] = height
        }
        let currentFoldState = foldStateList[indexPath.row]
        
        missionMenuCell.setFoldState(currentFoldState)
        addMissionCollectionView.collectionViewLayout.collectionView?.reloadItems(at: [indexPath])
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
