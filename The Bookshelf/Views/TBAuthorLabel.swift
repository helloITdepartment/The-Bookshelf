//
//  TBAuthorLabel.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 8/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

class TBAuthorLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        configure()
    }

    func configure() {
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }

}
