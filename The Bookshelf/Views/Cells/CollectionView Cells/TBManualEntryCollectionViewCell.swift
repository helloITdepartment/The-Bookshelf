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
    
    var id: EntryCellID!
    
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
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
//        backgroundColor = .systemGroupedBackground
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = Constants.largeItemCornerRadius
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


