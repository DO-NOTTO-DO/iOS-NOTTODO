//
//  CheckboxToggleStyle.swift
//  Widget-NOTTODOExtension
//
//  Created by 강윤서 on 4/14/24.
//

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                Image(configuration.isOn ? .btnSmallBoxFill : .btnSmallBox)
                    .imageScale(.large)
                configuration.label
            }
        })
        .buttonStyle(.plain)
        .frame(width: 16, height: 16)
        .disabled(!isEnabled)
    }
}
