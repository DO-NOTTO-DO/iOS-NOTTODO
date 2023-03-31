//
//  AddMissionProtocol.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/03/14.
//

import UIKit

enum FoldState {
    case folded, unfolded
}

protocol AddMissionMenu {
    var fold: FoldState { get set }
    func calculateCellHeight() -> CGFloat
}
