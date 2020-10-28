//
//  EntryFormField.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 5/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

class EntryFormField: UIView {
    
    private let titleLabel = TBEntryFieldLabel()
    private let textField = TBTextField()
    let padding: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(fieldName: String, placeholderText: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        configureView()
        configureTitleLabel(withText: fieldName)
        configureTextField(withPlaceholderText: placeholderText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = .systemGroupedBackground
//        layer.borderColor = UIColor.systemYellow.cgColor
//        layer.borderWidth = Constants.entryFormFieldBorderWidth
        layer.cornerRadius = Constants.smallItemCornerRadius
    }
    
    private func configureTitleLabel(withText text: String) {
        
        addSubview(titleLabel)
        titleLabel.text = text
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            titleLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func configureTextField(withPlaceholderText placeholderText: String) {
        
        addSubview(textField)
        textField.placeholder = placeholderText
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            textField.topAnchor.constraint(equalTo: self.centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        ])
    }
    
    public func getTextFieldValue() -> String? {
        textField.text
    }
}

