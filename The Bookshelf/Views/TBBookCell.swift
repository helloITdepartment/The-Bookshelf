//
//  TBBookCell.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 8/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

class TBBookCell: UITableViewCell {

    static let reuseID = "BookCell"
    let padding: CGFloat = 10

    let coverImageView = TBCoverImageView(frame: .zero)
    let titleLabel = TBTitleLabel(textAlignment: .left, fontSize: 20)
    let authorLabel = TBAuthorLabel(textAlignment: .left, fontSize: 15)


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        accessoryType = .disclosureIndicator
        backgroundColor = .systemBackground
        
        configureCoverImageView()
        configureTitleLabel()
        configureAuthorLabel()
    }
    
    func set(book: Book) {
        
        //set the coverImageView's image
        if let coverUrl = book.coverUrl {
            coverImageView.setImage(fromUrl: coverUrl)
        } //else the placeholder image will be used
        
        //set the titleLabel's text
        titleLabel.text = book.title
        
        //set the authorLabel's text
        if !book.authors.isEmpty {
            authorLabel.text = book.authors.joined(separator: ", ")
        }
        
    }
    
    private func configureCoverImageView() {
        
        addSubview(coverImageView)
        
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            coverImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            coverImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            coverImageView.widthAnchor.constraint(equalTo: coverImageView.heightAnchor)
        ])
        
    }
    
    private func configureTitleLabel() {
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: padding),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            titleLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
    }
    
    private func configureAuthorLabel() {
        
        addSubview(authorLabel)
        
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: padding),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding/2),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            authorLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        ])
        
    }
       
}
