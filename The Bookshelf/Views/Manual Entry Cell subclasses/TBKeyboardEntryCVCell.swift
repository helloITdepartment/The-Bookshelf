//
//  TBKeyboardEntryCVCell.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 10/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

class TBKeyboardEntryCVCell: TBManualEntryCollectionViewCell {
    
    internal let textField = TBTextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    internal func configureTextField(){
        lowerView.addSubview(textField)
        textField.delegate = self
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: lowerView.leadingAnchor),
            textField.topAnchor.constraint(equalTo: lowerView.topAnchor),
            textField.trailingAnchor.constraint(equalTo: lowerView.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: lowerView.bottomAnchor)
        ])
        
        textField.returnKeyType = .done
        
    }
    
    func set(labelText: String, textFieldPlaceholderText placeholderText: String) {
        
        titleLabel.text = labelText
        textField.placeholder = placeholderText
        
    }
    
    override func isEmpty() -> Bool {
        !textField.hasText
    }
    
    public func getTextFieldValue() -> String? {
        textField.text
    }

    public func grow() {
        
        DispatchQueue.main.async {
            
            self.labelHeightAnchor.isActive = false
            
            self.labelHeightAnchor = self.titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25)

            self.labelHeightAnchor.isActive = true
            
            UIView.animate(withDuration: 0.3) {
                
                self.layoutIfNeeded()
                
            }
        }
    }
    
    public func shrink() {
        
        DispatchQueue.main.async {
            
            self.labelHeightAnchor.isActive = false
            
            self.labelHeightAnchor = self.titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)

            self.labelHeightAnchor.isActive = true
            
            UIView.animate(withDuration: 0.2) {
                
                self.layoutIfNeeded()
                
            }
        }
    }
    
    public func makeTextFieldPrimary() {
        textField.becomeFirstResponder()
    }
}

extension TBKeyboardEntryCVCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        grow()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        shrink()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let didProperlyResign = textField.resignFirstResponder()
        shrink()
        return didProperlyResign
    }
}
