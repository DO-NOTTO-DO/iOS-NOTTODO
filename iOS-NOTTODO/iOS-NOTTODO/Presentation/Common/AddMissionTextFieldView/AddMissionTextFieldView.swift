//
//  AddMissionTextFieldView.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/03/09.
//

import UIKit

import SnapKit
import Then

final class AddMissionTextFieldView: UIView {
    
    // MARK: - UI Components
    
    private let addMissionTextField = UITextField()
    private let textCountLabel = UILabel()
    private let textFieldUnderLineView = UIView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        setDelegate()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AddMissionTextFieldView {
    func setUI() {
        addMissionTextField.do {
            $0.borderStyle = .none
            $0.textColor = .white
            $0.font = .Pretendard(.regular, size: 15)
        }
        
        textFieldUnderLineView.do {
            $0.backgroundColor = .gray3
            
        }
        
        textCountLabel.do {
            $0.font = .Pretendard(.regular, size: 12)
            $0.textColor = .gray3
            $0.text = "0/20"
        }
    }
    
    func setLayout() {
        addMissionTextField.addSubview(textFieldUnderLineView)
        addSubviews(addMissionTextField, textCountLabel)
        
        addMissionTextField.snp.makeConstraints {
            $0.top.leading.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        textFieldUnderLineView.snp.makeConstraints {
            $0.height.equalTo(1.5)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
        
        textCountLabel.snp.makeConstraints {
            $0.top.equalTo(addMissionTextField.snp.bottom).offset(3)
            $0.trailing.equalToSuperview()
        }
    }
}

extension AddMissionTextFieldView: UITextFieldDelegate {
    func setDelegate() {
        self.addMissionTextField.delegate = self
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textFieldUnderLineView.backgroundColor = .white
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        print(stringRange, "ㅇㄹㄴㅇㄹㅁㅇㄹ")
        let changeText = currentText.replacingCharacters(in: stringRange, with: string)
        print(string, "???")
        print(changeText, "❤️")
        
        textFieldUnderLineView.backgroundColor = changeText.count == 0 ? .gray3 : .white
        textCountLabel.text = "\(changeText.count)/20"
        return changeText.count < 20
    }
}
