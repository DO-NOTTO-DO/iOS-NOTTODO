//
//  HorizontalDivider.swift
//  Widget-NOTTODOExtension
//
//  Created by 강윤서 on 4/19/24.
//

import SwiftUI

struct HorizontalDivider: View {
    
    let color: Color
    let height: CGFloat
    
    init(color: Color, height: CGFloat = 1) {
        self.color = color
        self.height = height
    }
    
    var body: some View {
        color
            .frame(height: height)
    }
}
