//
//  TBNumericEntryCVCell.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 10/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

class TBNumericEntryCVCell: TBKeyboardEntryCVCell {
    
    static let reuseID = "NumericEntryCVCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureTextField() {
        super.configureTextField()
        
        textField.keyboardType = .numberPad
    }
}
