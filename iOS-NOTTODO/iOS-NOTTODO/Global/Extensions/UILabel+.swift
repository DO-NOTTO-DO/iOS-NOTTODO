//
//  UILabel+.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/23.
//

import UIKit

extension UILabel {
    
    /// 행간 조정 메서드
      func setLineSpacing(lineSpacing: CGFloat) {
          if let text = self.text {
              let attributedStr = NSMutableAttributedString(string: text)
              let style = NSMutableParagraphStyle()
              style.lineSpacing = lineSpacing
              attributedStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedStr.length))
              self.attributedText = attributedStr
          }
      }

      /// 자간 설정 메서드
      func setCharacterSpacing(_ spacing: CGFloat) {
          let attributedStr = NSMutableAttributedString(string: self.text ?? "")
          attributedStr.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: attributedStr.length))
          self.attributedText = attributedStr
      }

      /// 자간과 행간을 모두 조정하는 메서드
      func setLineAndCharacterSpacing(lineSpacing: CGFloat, characterSpacing: CGFloat) {
          if let text = self.text {
              let attributedStr = NSMutableAttributedString(string: text)
              let style = NSMutableParagraphStyle()
              style.lineSpacing = lineSpacing
              attributedStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedStr.length))
              attributedStr.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedStr.length))
              self.attributedText = attributedStr
          }
      }
    
    /// 라벨 일부 font 변경해주는 함수
    /// - targerString에는 바꾸고자 하는 특정 문자열을 넣어주세요
    /// - font에는 targetString에 적용하고자 하는 UIFont를 넣어주세요
    func partFontChange(targetString: String, font: UIFont) {
        let fullText = self.text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.font, value: font, range: range)
        self.attributedText = attributedString
    }
    
    /// 라벨 일부 textColor 변경해주는 함수
    /// - targetString에는 바꾸고자 하는 특정 문자열을 넣어주세요
    /// - textColor에는 targetString에 적용하고자 하는 특정 UIColor에 넣어주세요
    func partColorChange(targetString: String, textColor: UIColor) {
        let fullText = self.text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: textColor, range: range)
        self.attributedText = attributedString
    }
    
    func htmlToString(_ targetString: String) -> NSAttributedString? {
        let text = targetString
        
        guard let data = text.data(using: .utf8) else {
            return NSAttributedString()
        }
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
          return NSAttributedString()
        }
    }
    
    func setAttributedText(targetFontList: [String: UIFont],
                           targetColorList: [String: UIColor]) {
        let fullText = self.text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        for dic in targetFontList {
            let range = (fullText as NSString).range(of: dic.key)
            attributedString.addAttribute(.font, value: dic.value, range: range)
        }
        
        for dic in targetColorList {
            let range = (fullText as NSString).range(of: dic.key)
            attributedString.addAttribute(.foregroundColor, value: dic.value, range: range)
        }
        self.attributedText = attributedString
    }
}
