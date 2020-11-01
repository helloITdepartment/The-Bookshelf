//
//  Constants.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 8/13/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

struct Constants {
    static let entryFormFieldBorderWidth: CGFloat = 2
    static let largeItemCornerRadius: CGFloat = 15
    static let mediumItemCornerRadius: CGFloat = 10
    static let smallItemCornerRadius: CGFloat = 5
    static let tintColor: UIColor = .systemTeal
}

enum EntryCellType {
    case regular
    case numeric
    case options
    case picture
}
