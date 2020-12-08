//
//  BookDetailVC.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 5/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

class BookDetailVC: UIViewController {

    var book: Book!
    
    let padding: CGFloat = 8
    
    var coverImageView: UIImageView?
    var titleLabel: TBTitleLabel!
    var authorLabel: TBAuthorLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
//        view.backgroundColor = .systemGreen
        
        if book.hasCoverImage() {
            print("configuring cover image view")
            configureCoverImageView()
        }
        
        configureTitleLabel()
        configureAuthorLabel()
    }
    
    private func configureCoverImageView() {
        //Create the imageView
        coverImageView = UIImageView()
        
        //Tell it which picture to display and how
        book.coverImage { (result) in
            switch result {
        
            case .success(let image):
                //Since we're updating UI
                DispatchQueue.main.async {
                    self.coverImageView?.image = image
                }
            case .failure(let error):
                //TODO:- something useful with this error
                print(error.rawValue)
            }
        }
        
        coverImageView!.contentMode = .scaleAspectFit
//        coverImageView!.backgroundColor = .systemBlue
        
        //Add it to the view
        view.addSubview(coverImageView!)
        
        //Constrain it
        coverImageView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coverImageView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            coverImageView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coverImageView!.widthAnchor.constraint(equalTo: view.widthAnchor),
            coverImageView!.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    private func configureTitleLabel() {
        //Create the label
        titleLabel = TBTitleLabel(textAlignment: .left, fontSize: 50)
        
        //Configure its text, font
        titleLabel.text = book.title
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 2
        
        //Add it to the view
        view.addSubview(titleLabel)
        
        //Constrain it
        //Decide where to pin it. Either to the bottom of the coverImageView if it exists, or just the top of the view otherwise
//        let topAnchor = (coverImageView != nil ? coverImageView!.bottomAnchor : view.safeAreaLayoutGuide.topAnchor)
        let topAnchor = (coverImageView?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configureAuthorLabel() {
        
        //Create the label
        authorLabel = TBAuthorLabel(textAlignment: .left, fontSize: 30)
        
        //Configure the text, font
        authorLabel.text = book.authorString()
        authorLabel.minimumScaleFactor = 0.5
        
        //Add it to the subview
        view.addSubview(authorLabel)
        
        //Constrain it
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            authorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            authorLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
}
