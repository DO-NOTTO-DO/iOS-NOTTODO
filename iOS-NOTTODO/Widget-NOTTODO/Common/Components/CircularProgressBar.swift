//
//  CircularProgressBar.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 4/17/24.
//

import WidgetKit
import SwiftUI

struct CircularProgressBarView: View {
    
    @State var percent = 0.0
    var size: CGFloat
    var lineWidth: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .frame(width: size, height: size)
                .foregroundColor(.gray3)
            
            Circle()
                .trim(from: 0, to: percent)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt))
                .frame(width: size, height: size)
                .foregroundColor(.green2)
                .rotationEffect(.degrees(-90))
                .scaleEffect(x: -1)
        }
    }
}

#Preview(as: .systemSmall) {
    Widget_NOTTODO()
} timeline: {
    SimpleEntry(lastThreeTask: [])
}
