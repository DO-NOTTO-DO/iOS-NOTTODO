//
//  PracticeCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/03/19.
//

import UIKit

import SnapKit
import Then

final class PracticeCollectionViewCell: UICollectionViewCell, AddMissionMenu {
    
    // MARK: - Properties
    
    var fold: FoldState = .unfolded
    static let identifier = "PracticeCollectionViewCell"
    
    // MARK: - UI Components
    
    private let titleLabel = TitleLabel(title: I18N.action)
    private let subTitleLabel = SubTitleLabel(subTitle: I18N.subAction,
                                              colorText: I18N.action)
    private var addMissionTextField = AddMissionTextFieldView(frame: .zero)
    
}
