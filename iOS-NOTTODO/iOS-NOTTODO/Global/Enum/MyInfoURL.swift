//
//  MyInFoURL.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/05/17.
//

import Foundation

import SafariServices

enum MyInfoURL {
    case guid, quesition, notice, contact, service, personalInfo, googleForm, opensource
    var url: String {
        switch self {
        case .guid:
            return "https://teamnottodo.notion.site/f35a7f2d6d5c4b33b4d0949f6077e6cd"
        case .quesition:
            return "https://teamnottodo.notion.site/a6ef7036bde24e289e576ace099f39dc"
        case .notice:
            return "https://teamnottodo.notion.site/a5dbb310ec1d43baae02b7e9bf0b3411"
        case .contact:
            return "http://pf.kakao.com/_fUIQxj/chat"
        case .service:
            return "https://teamnottodo.notion.site/0c3c7c02857b46e1b16307ce7a8f6ca9"
        case .personalInfo:
            return "https://teamnottodo.notion.site/5af34df7da3649fc941312c5f533c1eb"
        case .googleForm:
            return "https://forms.gle/gwBJ4hL4bCTjXRTP6"
        case .opensource:
            return ""
        }
    }
    
}
