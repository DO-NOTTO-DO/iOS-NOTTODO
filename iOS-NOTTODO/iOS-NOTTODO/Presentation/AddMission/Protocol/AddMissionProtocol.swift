//
//  AddMissionProtocol.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/03/14.
//

import UIKit

protocol AddMissionMenu {
    func setFoldState(_ state: FoldState)
    var missionCellHeight: ((CGFloat) -> Void)? { get set }
}
