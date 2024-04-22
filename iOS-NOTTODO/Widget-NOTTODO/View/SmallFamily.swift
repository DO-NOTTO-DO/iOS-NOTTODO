//
//  SmallFamily.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 4/19/24.
//

import SwiftUI
import WidgetKit

struct SmallFamily: View {
    var entry: Provider.Entry
    @AppStorage("dayOfWeek", store: UserDefaults.shared) var dayOfWeek: String = ""

    var body: some View {
        let progressPercent = Double(entry.lastThreeTask.filter { $0.completionStatus == .CHECKED }.count) / Double(entry.lastThreeTask.count)
        
        VStack {
            HStack {
                Spacer()
                
                ZStack {
                    Text(dayOfWeek)
                        .foregroundStyle(dayOfWeek == "일" ? .wdgRed : .white)
                        .font(.custom("Pretendard", size: 13))
                        .fontWeight(.semibold)
                    
                    CircularProgressBarView(percent: progressPercent, size: 27, lineWidth: 3)
                }
                
                Text("성공하지않는거엊이ㅏ러미아러어쩌구요명어니아러나어ㅏ아아아")
                    .foregroundStyle(.white)
                    .font(.custom("Pretendard", size: 7))
                    .fontWeight(.regular)
                    .lineLimit(2)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 48)
            .background(.ntdBlack)
            
            VStack(spacing: 12) {
                if entry.lastThreeTask.isEmpty {
                    Button(action: {
                        print("앱으로 이동")
                    }, label: {
                        Image(.icPlus)
                            .imageScale(.large)
                    })
                    .buttonStyle(.plain)
                    .position(x: 17, y: 12)
                } else {
                    ForEach(entry.lastThreeTask) { task in
                        HStack {
                            Button(intent: ToggleButtonIntent(id: task.id)) {
                                Image(task.completionStatus == .CHECKED ? .btnSmallBoxFill : .btnSmallBox)
                            }
                            .buttonStyle(.plain)
                            .frame(width: 16, height: 16)
                            
                            Text(task.title)
                                .foregroundStyle(task.completionStatus == .CHECKED ? .gray4 : .ntdBlack)
                                .strikethrough(task.completionStatus == .CHECKED, color: .gray4)
                                .font(.custom("Pretendard-Regular", size: 8))
                                .fontWeight(.regular)
                                .lineLimit(2)
                            Spacer()
                        }
                        .padding(.leading, 16)
                        .frame(height: 22)
                    }
                }
            }
            
            Spacer()
        }
        .background(.bg)
    }
}
