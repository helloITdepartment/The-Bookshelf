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
    
    //Instead of reading the values of the cells when the add button is tapped-
    //The cells have all have a didEnterValue closure given to them by their collectionView
    //In theory it can be anything, but for right now they effectively say "assign (the string that's going to be passed in) to this variable"
    //where the variable is one in the VC that holds the collectionView, which represents a component of the Book
//    var didEnterValue: ((String?) -> Void)!

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

    public func setTextFieldValue(to text: String) {
        textField.text = text
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
//        didEnterValue(getTextFieldValue())
        shrink()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let didProperlyResign = textField.resignFirstResponder()
//        didEnterValue(getTextFieldValue())
        shrink()
        return didProperlyResign
    }
}
