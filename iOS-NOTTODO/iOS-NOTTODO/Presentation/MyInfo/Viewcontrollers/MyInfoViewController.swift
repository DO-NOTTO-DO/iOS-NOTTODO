//
//  MyInfoViewController.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/15.
//

import UIKit

import Then
import SnapKit
import MessageUI

final class MyInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    private let infoOne: [InfoModelOne] = InfoModelOne.item
    private let infoTwo: [InfoModelTwo] = InfoModelTwo.items
    private let infoThree: [InfoModelThree] = InfoModelThree.items
    private let infoFour: [InfoModelFour] = InfoModelFour.item
    
    enum Sections: Int, Hashable {
        case one, two, three, four
    }
    typealias DataSource = UICollectionViewDiffableDataSource<Sections, AnyHashable>
    var dataSource: DataSource?
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
    // MARK: - UI Components
    
    private lazy var myInfoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        register()
        setLayout()
        setupDataSource()
        reloadData()
    }
}

// MARK: - Methods

extension MyInfoViewController {
    private func register() {
        myInfoCollectionView.register(MyProfileCollectionViewCell.self, forCellWithReuseIdentifier: MyProfileCollectionViewCell.identifier)
        myInfoCollectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: InfoCollectionViewCell.identifier)
        myInfoCollectionView.register(MyInfoHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyInfoHeaderReusableView.identifier)
    }
    
    private func setUI() {
        view.backgroundColor = .ntdBlack
        
        myInfoCollectionView.do {
            $0.backgroundColor = .clear
            $0.bounces = false
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            $0.showsVerticalScrollIndicator = false
            $0.delegate = self
        }
    }
    
    private func setLayout() {
        view.addSubview(myInfoCollectionView)
        
        myInfoCollectionView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(22)
            $0.directionalVerticalEdges.equalTo(safeArea)
        }
    }
    
    // MARK: - Data
    
    private func setupDataSource() {
        dataSource = DataSource(collectionView: myInfoCollectionView, cellProvider: { collectionView, indexPath, item in
            let section = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
            case .one:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyProfileCollectionViewCell.identifier, for: indexPath) as! MyProfileCollectionViewCell
                cell.configure(model: item as! InfoModelOne )
                return cell
            case .two:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.identifier, for: indexPath) as! InfoCollectionViewCell
                cell.configureWithIcon(model: item as! InfoModelTwo )
                return cell
            case .three:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.identifier, for: indexPath) as! InfoCollectionViewCell
                cell.configureWithArrow(model: item as! InfoModelThree)
                return cell
            case .four, .none:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.identifier, for: indexPath) as! InfoCollectionViewCell
                cell.configure(model: item as! InfoModelFour)
                return cell
            }
        })
    }
    
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<Sections, AnyHashable>()
        defer {
            dataSource?.apply(snapShot, animatingDifferences: false)
        }
        snapShot.appendSections([.one, .two, .three, .four])
        snapShot.appendItems(infoOne, toSection: .one)
        snapShot.appendItems(infoTwo, toSection: .two)
        snapShot.appendItems(infoThree, toSection: .three)
        snapShot.appendItems(infoFour, toSection: .four)
        
        dataSource?.supplementaryViewProvider = { (collectionView, _, indexPath) in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyInfoHeaderReusableView.identifier, for: indexPath) as? MyInfoHeaderReusableView else { return UICollectionReusableView() }
            return header
        }
    }
    
    // MARK: - Layout
    
    private func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, env  in
            let section = self.dataSource?.snapshot().sectionIdentifiers[sectionIndex]
            switch section {
            case .one:
                return CompositionalLayout.setUpSection(layoutEnvironment: env, mode: .supplementary, 24, 0)
            case .two, .three:
                return CompositionalLayout.setUpSection(layoutEnvironment: env, mode: .none, 18, 0)
            case .four, .none:
                return CompositionalLayout.setUpSection(layoutEnvironment: env, mode: .none, 18, 60)
            }
        }
        return layout
    }
}
extension MyInfoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.item {
            case 0:
                Utils.myInfoUrl(vc: self, url: MyInfoURL.guid.url)
            default:
                Utils.myInfoUrl(vc: self, url: MyInfoURL.quesition.url)
            }
        case 2:
            switch indexPath.item {
            case 0:
                Utils.myInfoUrl(vc: self, url: MyInfoURL.notice.url)
            case 2:
                Utils.myInfoUrl(vc: self, url: MyInfoURL.service.url)
            default: 
                sendEmail()
            }
        default:
            return
        }
    }
}
extension MyInfoViewController {
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
            composeViewController.mailComposeDelegate = self
            
            let bodyString = """
                                 
                                 -------------------
                                 
                                 Device Model : \(self.getDeviceIdentifier())
                                 Device OS : \(UIDevice.current.systemVersion)
                                 App Version : \(self.getCurrentVersion())
                                 
                                 -------------------
                                 """
            
            composeViewController.setToRecipients(["notodonow@gmail.com"])
            composeViewController.setSubject("낫투두에게 문의해요")
            composeViewController.setMessageBody(bodyString, isHTML: false)
            
            self.present(composeViewController, animated: true, completion: nil)
        } else {
            print("메일 보내기 실패")
            let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
            let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
                // 앱스토어로 이동하기(Mail)
                if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
            
            sendMailErrorAlert.addAction(goAppStoreAction)
            sendMailErrorAlert.addAction(cancleAction)
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
    }
    // Device Identifier 찾기
    func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }

    // 현재 버전 가져오기
    func getCurrentVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
}
extension MyInfoViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}
