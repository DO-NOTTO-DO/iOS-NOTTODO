//
//  AddMissionProtocol.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/03/14.
//

import UIKit

protocol AddMissionMenu {
    var title: String { get set }
    var subTitle: String { get set }
    init(title: String, subTitle: String)
    func makeUI()
    func fold()
}
