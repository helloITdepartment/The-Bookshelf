//
//  TBManualEntryCollectionViewCell.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 8/26/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

class TBManualEntryCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "ManualEntryCVCell"
    let padding: CGFloat = 8
    
    private let titleLabel = TBEntryFieldLabel()
    private let textField = TBTextField()
    
    var labelHeightAnchor: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
        configureLabel()
        configureTextField()
    }
    
    func set(labelText: String, textFieldPlaceholderText placeholderText: String) {
        
        titleLabel.text = labelText
        textField.placeholder = placeholderText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        backgroundColor = .systemGroupedBackground
        layer.cornerRadius = 15
    }
    
    private func configureLabel() {
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding)//,
//            titleLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -padding)
        ])
        
        labelHeightAnchor = titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        labelHeightAnchor.isActive = true
    }
    
    private func configureTextField(){
        
        addSubview(textField)
        textField.delegate = self
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        ])
        
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

extension TBManualEntryCollectionViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        grow()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        shrink()
    }
}
