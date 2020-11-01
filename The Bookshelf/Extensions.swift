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
    static func createVerticalFlowLayout(for width: CGFloat) -> UICollectionViewFlowLayout {
        
        let padding: CGFloat = 12
        let itemWidth = width - (padding * 2)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth/4)
        flowLayout.scrollDirection = .vertical
        
        return flowLayout
        
    }
    
    static func createHorizontalFlowLayout(for height: CGFloat) -> UICollectionViewFlowLayout{
        
        let padding: CGFloat = 3
        let itemHeight = height - (padding * 2)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemHeight * 4, height: itemHeight)
        flowLayout.scrollDirection = .horizontal
//        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        flowLayout.estimatedItemSize = CGSize.init(width: 1, height: 1)
        
        return flowLayout
    }
}

extension UIViewController {
    func presentErrorAlert(for error: TBError) {
        let ac = UIAlertController(title: "Something went wrong.", message: error.rawValue, preferredStyle: .alert)
        let gotItButton = UIAlertAction(title: "Got it", style: .default)
        ac.addAction(gotItButton)
        present(ac, animated: true)
    }
}
