//
//  HomeViewController.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/15.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let missionList: [MissionListModel] = MissionListModel.items
    
    private let missionTableView = UITableView(frame: .zero)
    
    enum Section: Int, Hashable {
        case mission
    }
    
    var dataSource: UITableViewDiffableDataSource<Section, MissionListModel>! = nil
    private lazy var safeArea = self.view.safeAreaLayoutGuide
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

extension HomeViewController {
    private func register() {
        missionTableView.register(MissionListTableViewCell.self, forCellReuseIdentifier: MissionListTableViewCell.identifier)
    }
    private func setUI() {
        view.backgroundColor = .bg
        
        missionTableView.do {
            $0.backgroundColor = .clear
            $0.separatorStyle = .none
            $0.rowHeight = 108
        }
        
    }
    private func setLayout() {
        view.addSubview(missionTableView)
        
        missionTableView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(162)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(18)
            $0.bottom.equalTo(safeArea)
        }
    }
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, MissionListModel>(tableView: missionTableView, cellProvider: { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MissionListTableViewCell.identifier, for: indexPath) as? MissionListTableViewCell else { return UITableViewCell()}
            cell.configure(model: item)
            cell.isTappedClosure = { result in
                if result {
                    cell.isTapped.toggle()
                    cell.setUI()
                }
            }
            cell.selectionStyle = .none
            return cell
        })
    }
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, MissionListModel>()
        defer {
            dataSource.apply(snapShot, animatingDifferences: false)
        }
        snapShot.appendSections([.mission])
        snapShot.appendItems(missionList, toSection: .mission)
    }
}
extension HomeViewController {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let mission = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        // Delete action
        let deleteAction = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
            print("delete")
            completionHandler(true)

        }
        
        // modify action
        let modifyAction = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
            print("modify")
            completionHandler(true)

        }
        
        deleteAction.backgroundColor = .ntdBlue
        deleteAction.image = .icFix
        
        modifyAction.backgroundColor = .ntdRed
        modifyAction.image = .icTrash
        
        // Configure both actions as swipe action
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [modifyAction, deleteAction])
        return swipeConfiguration
    }
}
