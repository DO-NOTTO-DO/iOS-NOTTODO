//
//  UICollectionViewCell+.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/03/22.
//

import UIKit

extension UICollectionViewCell {
    func calculateLabelHeight(_ text: String?, font: UIFont, width: CGFloat) -> CGFloat {
        guard let text = text else { return 0 }
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let attributes = [NSAttributedString.Key.font: font]
        let rect = text.boundingRect(with: size,
                                     options: .usesFontLeading,
                                     attributes: attributes,
                                     context: nil)
        return ceil(rect.height)
    }
}
