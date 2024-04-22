//
//  MediumFamily.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 4/19/24.
//

import SwiftUI
import WidgetKit

struct MediumFamily: View {
    var entry: Provider.Entry
    
    var body: some View {
        let progressPercent = Double(entry.lastThreeTask.filter { $0.completionStatus == .CHECKED }.count) / Double(entry.lastThreeTask.count)
        HStack {
            VStack {
                ZStack {
                    Text("월")
                        .foregroundStyle(Color.black)
                        .font(.custom("Pretendard", size: 18))
                        .fontWeight(.semibold)
                    CircularProgressBarView(percent: progressPercent, size: 42, lineWidth: 4.34)}
                Spacer()
            }
            .padding(.top, 14)
            .padding(.leading, 17)
            
            VStack {
                Text("성공한상위십퍼센트는하하글자수가과연어디까지일까요하하하먼저하지말아야할어쩌구저쩌구")
                    .foregroundStyle(.gray3)
                    .font(.custom("Pretendard", size: 10))
                    .fontWeight(.regular)
                    .lineLimit(2)
                    .padding(.horizontal, 12)
                    .padding(.top, 18)
                
                HorizontalDivider(color: .gray5)
                    .padding(.top, 6)
                
                VStack(spacing: 9) {
                    if entry.lastThreeTask.isEmpty {
                        Button(action: {
                            print("앱으로 이동")
                        }, label: {
                            Image(.icPlusDark)
                                .imageScale(.large)
                        })
                        .buttonStyle(.plain)
                        .position(x: 10, y: 9)
                    } else {
                        ForEach(entry.lastThreeTask) { task in
                            HStack {
                                Button(intent: ToggleButtonIntent(id: task.id)) {
                                    Image(task.completionStatus == .CHECKED ? .btnMediumFill : .btnMedium)
                                }
                                .buttonStyle(.plain)
                                .frame(width: 19, height: 19)
                                
                                Text(task.title)
                                    .foregroundStyle(.gray1)
                                    .font(.custom("Pretendard-Regular", size: 11))
                                    .fontWeight(.regular)
                                Spacer()
                            }
                            .padding(.leading, 16)
                            .frame(height: 20)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.trailing, 22)
        }
        .background(.white)
    }
}

#Preview(as: .systemMedium) {
    Widget_NOTTODO()
} timeline: {
    SimpleEntry(lastThreeTask: [])
}
