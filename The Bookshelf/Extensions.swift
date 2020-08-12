//
//  Extensions.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 5/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

extension UIView {
    func clear() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}
