//
//  TBManualEntryCollectionViewCell.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 8/26/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

class TBManualEntryCollectionViewCell: UICollectionViewCell {
    
//    static let reuseID = "ManualEntryCVCell"
    let padding: CGFloat = 8
    
    internal let titleLabel = TBEntryFieldLabel()
    internal let lowerView = UIView()
//    private let textField = TBTextField()
    
    var labelHeightAnchor: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
        configureLabel()
        configureLowerView()
//        configureTextField()
    }
    
//    func set(labelText: String, textFieldPlaceholderText placeholderText: String, type: EntryCellType) {
//        
//        titleLabel.text = labelText
//        textField.placeholder = placeholderText
//
//        switch type {
//        case .regular:
//            return
//        case .numeric:
//            textField.keyboardType = .numberPad
//        case .picture:
//            return
//        case .location:
//            return
//        }
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
//        backgroundColor = .systemGroupedBackground
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 15
    }
    
    internal func configureLabel() {
        
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
    
//    private func configureTextField(){
//        
//        addSubview(textField)
//        textField.delegate = self
//        
//        NSLayoutConstraint.activate([
//            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
//            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
//            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
//            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
//        ])
//        
//        textField.returnKeyType = .done
//        
//    }
    
    internal func configureLowerView(){
  
        lowerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(lowerView)

        NSLayoutConstraint.activate([
            lowerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            lowerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            lowerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            lowerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        ])
    }
    
    public func isEmpty() -> Bool {
        fatalError("Must override isEmpty")
    }
    
//    public func getData() -> Any {
//        fatalError("Must override getData() method")
//    }
    
//    public func getTextFieldValue() -> String? {
//        textField.text
//    }
    
//    public func grow() {
//
//        DispatchQueue.main.async {
//
//            self.labelHeightAnchor.isActive = false
//
//            self.labelHeightAnchor = self.titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25)
//
//            self.labelHeightAnchor.isActive = true
//
//            UIView.animate(withDuration: 0.3) {
//
//                self.layoutIfNeeded()
//
//            }
//        }
//    }
//
//    public func shrink() {
//
//        DispatchQueue.main.async {
//
//            self.labelHeightAnchor.isActive = false
//
//            self.labelHeightAnchor = self.titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
//
//            self.labelHeightAnchor.isActive = true
//
//            UIView.animate(withDuration: 0.2) {
//
//                self.layoutIfNeeded()
//
//            }
//        }
//    }
//
//    public func makeTextFieldPrimary() {
//        textField.becomeFirstResponder()
//    }
    
    public func flashRed() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 2.5) {
                self.backgroundColor = .systemRed
            }
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.5) {
                self.backgroundColor = .secondarySystemBackground
            }
        }
    }
}

//extension TBManualEntryCollectionViewCell: UITextFieldDelegate {
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        grow()
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        shrink()
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        let didProperlyResign = textField.resignFirstResponder()
//        shrink()
//        return didProperlyResign
//    }
//}
