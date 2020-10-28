//
//  TBTextField.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 5/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

class TBTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = Constants.smallItemCornerRadius
//        layer.borderWidth = 2
//        layer.borderColor = UIColor.systemGray4.cgColor
        
        textColor = .label
        tintColor = Constants.tintColor
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        
//        backgroundColor = .secondarySystemGroupedBackground
        backgroundColor = .tertiarySystemBackground
        
        returnKeyType = .go
        autocorrectionType = .no
        autocapitalizationType = .words
    }

}
