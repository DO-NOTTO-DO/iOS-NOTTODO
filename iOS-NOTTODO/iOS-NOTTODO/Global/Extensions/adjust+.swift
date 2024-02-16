//
//  adjust+.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2/16/24.
//

import UIKit

extension CGFloat {
    var adjusted: CGFloat {
        let ratio: CGFloat = Numbers.width / 375
        return ratio * CGFloat(self)
    }
}

extension Int {
    var adjusted: CGFloat {
        let ratio: CGFloat = (Numbers.width) / 375
        return ratio * CGFloat(self)
    }
}

extension Double {
    var adjusted: CGFloat {
        let ratio: CGFloat = (Numbers.width) / 375
        return ratio * CGFloat(self)
    }
}
