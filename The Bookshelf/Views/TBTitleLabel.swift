//
//  TBTitleLabel.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 8/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

class TBTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = .systemFont(ofSize: fontSize, weight: .bold)
        configure()
    }
    
    func configure() {
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        lineBreakMode = .byTruncatingMiddle
        translatesAutoresizingMaskIntoConstraints = false
    }
}
