//
//  TBCollectionViewCell.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 8/16/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

//TODO:- change this to TBCollectionViewBookCell
class TBCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "BookCVCell"
    let padding: CGFloat = 8
    
    let coverImageView = TBCoverImageView(frame: .zero)
    let titleLabel = TBTitleLabel(textAlignment: .center, fontSize: 20)
    let authorLabel = TBAuthorLabel(textAlignment: .center, fontSize: 15)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCoverImageView()
        configureTitleLabel()
        configureAuthorLabel()
    }
    
    func set(book: Book) {
        
        //set the coverImageView's image
        if let coverImage = book.coverImage() {
            coverImageView.image = coverImage
        } else if let coverUrl = book.coverUrl {
            coverImageView.setImage(fromUrl: coverUrl)
        } //else the placeholder image will be used
        
        //set the titleLabel's text
        titleLabel.text = book.title
        
        //set the authorLabel's text
        if book.authors.isEmpty {
            authorLabel.text = "Unknown"
        } else {
            authorLabel.text = book.authors.joined(separator: ", ")
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCoverImageView() {
        
        addSubview(coverImageView)
        
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            coverImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            coverImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            coverImageView.widthAnchor.constraint(equalTo: coverImageView.heightAnchor)
        ])
        
    }
    
    private func configureTitleLabel() {
        
        addSubview(titleLabel)
        titleLabel.minimumScaleFactor = 0.6
        titleLabel.numberOfLines = 0

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
    }
    
    private func configureAuthorLabel() {
        
        addSubview(authorLabel)
        authorLabel.minimumScaleFactor = 0.5
        
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding/2),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            authorLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
}
