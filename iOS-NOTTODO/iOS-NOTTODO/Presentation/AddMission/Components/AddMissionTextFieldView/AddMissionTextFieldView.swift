//
//  AddMissionTextFieldView.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/03/09.
//

import UIKit

import SnapKit
import Then

final class AddMissionTextFieldView: UIView, textFiledDelegateProtocol {
    
    // MARK: - Properties
    
    private var textMaxCount: Int
    var textFieldData: ((String) -> Void)?
    
    // MARK: - UI Components
    
    private let addMissionTextField = UITextField()
    private let textCountLabel = UILabel()
    private let textFieldUnderLineView = UIView()
    
    // MARK: - Life Cycle
    
    init(textMaxCount: Int) {
        self.textMaxCount = textMaxCount
        super.init(frame: .zero)
        setUI()
        setLayout()
        setDelegate()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String) {
        textFieldData?(text)
        addMissionTextField.text = text
        textCountLabel.text = "\(text.count)/\(textMaxCount)"
    }
    
    func setMaxCount(_ max: Int) {
        textMaxCount = max
    }
    
    func upKeyboard() {
        addMissionTextField.becomeFirstResponder()
    }
    
    func downKeyboard() {
        textFieldData?(getTextFieldText())
        addMissionTextField.resignFirstResponder()
    }
    
    func setReturnType( _ type: UIKeyboardType) {
        addMissionTextField.keyboardType = type
    }
    
    func getTextFieldText() -> String {
        return addMissionTextField.text ?? ""
    }
}

extension AddMissionTextFieldView {
    private func setUI() {
        addMissionTextField.do {
            $0.borderStyle = .none
            $0.textColor = .white
            $0.font = .Pretendard(.regular, size: 15)
            $0.returnKeyType = .go
        }
        
        textFieldUnderLineView.do {
            $0.backgroundColor = .gray3
        }
        
        textCountLabel.do {
            $0.font = .Pretendard(.regular, size: 12)
            $0.textColor = .gray3
            $0.text = "0/\(textMaxCount)"
        }
    }
    
    private func setLayout() {
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
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = addMissionTextField.text else { return }
        textCountLabel.text = "\(text.count)/\(textMaxCount)"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changeText = currentText.replacingCharacters(in: stringRange, with: string)
        textFieldUnderLineView.backgroundColor = changeText.count == 0 ? .gray3 : .white
        textFieldData?(changeText)
        return changeText.count < textMaxCount + 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldData?(getTextFieldText())
        textField.resignFirstResponder()
        return true
    }
}
