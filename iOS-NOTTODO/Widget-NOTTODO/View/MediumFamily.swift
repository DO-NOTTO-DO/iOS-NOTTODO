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
        let progressPercent = Double(entry.todayMission.filter { $0.completionStatus == .CHECKED }.count) / Double(entry.todayMission.count)
        HStack {
            VStack {
                ZStack {
                    Text(entry.dayOfWeek)
                        .foregroundStyle(entry.dayOfWeek == "일" ? .wdgRed : .ntdBlack)
                        .font(.custom("Pretendard", size: 18))
                        .fontWeight(.semibold)
                    CircularProgressBarView(percent: progressPercent, size: 42, lineWidth: 4.34)}
                Spacer()
            }
            .padding(.top, 14)
            .padding(.leading, 17)
            
            VStack {
                Text(entry.quote)
                    .foregroundStyle(.gray3)
                    .font(.custom("Pretendard", size: 10))
                    .fontWeight(.regular)
                    .lineLimit(2)
                    .padding(.horizontal, 12)
                    .padding(.top, 18)
                    .frame(maxWidth: .infinity, maxHeight: 51, alignment: .leading)
                
                HorizontalDivider(color: .gray5)
                    .padding(.top, 6)
                
                VStack(spacing: 9) {
                    if entry.todayMission.isEmpty {
                        Button(action: {
                            print("앱으로 이동")
                        }, label: {
                            Image(.icPlusDark)
                                .imageScale(.large)
                        })
                        .buttonStyle(.plain)
                        .position(x: 10, y: 9)
                    } else {
                        ForEach(entry.todayMission) { task in
                            HStack {
                                Button(intent: ToggleButtonIntent(id: task.id, status: task.completionStatus.rawValue)) {
                                    Image(task.completionStatus == .CHECKED ? .btnMediumFill : .btnMedium)
                                }
                                .buttonStyle(.plain)
                                .frame(width: 19, height: 19)
                                
                                Text(task.title)
                                    .foregroundStyle(task.completionStatus == .CHECKED ? .gray4 : .ntdBlack)
                                    .strikethrough(task.completionStatus == .CHECKED, color: .gray4)
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
    SimpleEntry(todayMission: [], quote: "")
}
