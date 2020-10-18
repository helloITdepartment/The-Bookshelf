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

extension UICollectionView {
    static func createFlowLayout(for width: CGFloat) -> UICollectionViewFlowLayout {
        
        let padding: CGFloat = 12
        let itemWidth = width - (padding * 2)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth/4)
        
        return flowLayout
        
    }
}
