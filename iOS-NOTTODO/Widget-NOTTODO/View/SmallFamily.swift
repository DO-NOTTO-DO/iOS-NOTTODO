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

    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                ZStack {
                    Text("월")
                        .foregroundStyle(.white)
                        .font(.custom("Pretendard", size: 13))
                        .fontWeight(.semibold)
                    
                    CircularProgressBarView(percent: 0.5, size: 27, lineWidth: 3)
                }
                
                Text("성공하지않는거엊이ㅏ러미아러어쩌구요명어니아러나어ㅏ아아아")
                    .foregroundStyle(.white)
                    .font(.custom("Pretendard", size: 7))
                    .fontWeight(.regular)
                    .lineLimit(2)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 48)
            .background(Color(.black))
            
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
                    ForEach(entry.lastThreeTask.prefix(3)) { task in
                        HStack {
                            Toggle("", isOn: task.$isCompleted)
                                .toggleStyle(CheckboxToggleStyle())
                            
                            Text(task.missionTitle)
                                .foregroundStyle(.black)
                                .font(.custom("Pretendard-Regular", size: 8))
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
        .background(.bg)
    }
}
