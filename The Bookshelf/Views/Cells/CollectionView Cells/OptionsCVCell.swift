//
//  OptionsCVCell.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 10/28/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

//CollectionView cell to be used to display the options in a TBOptionEntryCVCell
class OptionsCVCell: UICollectionViewCell {
    
    static let reuseID = "OptionCell"
    
    private var nameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        layer.cornerRadius = Constants.smallItemCornerRadius
        backgroundColor = .secondarySystemBackground

//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            contentView.topAnchor.constraint(equalTo: topAnchor),
//            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
    }
    
    private func configureLabel() {

        nameLabel = UILabel()
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.75
//        nameLabel.backgroundColor = .secondarySystemBackground
        nameLabel.backgroundColor = .clear
        nameLabel.layer.cornerRadius = Constants.smallItemCornerRadius
        nameLabel.lineBreakMode = .byTruncatingMiddle
        nameLabel.textColor = .secondaryLabel
        
        contentView.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    public func setText(to string: String?) {
        nameLabel.text = string
    }
    
    public func getLabelSize() -> CGSize {
        nameLabel.intrinsicContentSize
    }
}
