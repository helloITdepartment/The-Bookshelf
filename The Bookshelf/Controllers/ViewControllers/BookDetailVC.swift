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
    
    var deleteBookDelegate: DeleteBookDelegate!
    
    var deleteButton: UIBarButtonItem!
    var editButton: UIBarButtonItem!
    
    let padding: CGFloat = 8
    
    var coverImageView: UIImageView?
    var titleLabel: TBTitleLabel!
    var authorLabel: TBAuthorLabel!
    var locationLabel: LocationLabelView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
//        view.backgroundColor = .systemGreen
        
       configureVC()
    }
    
    private func configureVC() {
        
        view.clear()
        
        if book.hasCoverImage() {
            print("configuring cover image view")
            configureCoverImageView()
        }
        
        configureTitleLabel()
        configureAuthorLabel()
        
        if book.location != nil {
            configureLocationLabel()
        }
        
        configureDeleteButton()
        configureEditButton()
        
        navigationItem.rightBarButtonItems = [deleteButton, editButton]
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
    
    private func configureLocationLabel() {
        
        //Create the label
        locationLabel = LocationLabelView()
        
        //Configure the text, font
        if book.location == .lentOut {
            if book.lentOutTo != nil {
                locationLabel?.set(labelText: "Lent out to \(book.lentOutTo!)")
            } else {
                locationLabel?.set(labelText: "Lent out")
            }
        } else {
            locationLabel?.set(labelText: book.location!) // Can safely unwrap since we're only getting into this func if the location is not nil
        }
        
        //Add it to the subview
        view.addSubview(locationLabel!)
        
        //Constrain it
        locationLabel?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabel!.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            locationLabel!.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: padding),
            locationLabel!.trailingAnchor.constraint(equalTo: authorLabel.trailingAnchor),
            locationLabel!.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func configureDeleteButton() {
        deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonTapped))
        deleteButton.tintColor = .systemRed
    }
    
    private func configureEditButton() {
        editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        editButton.tintColor = Constants.tintColor
    }
    
    @objc private func deleteButtonTapped() {
        self.deleteBookDelegate.didRequestToDelete(book: self.book)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func editButtonTapped() {
        let editingVC = ManualEntryVC()
        editingVC.book = book
        editingVC.addBookDelegate = self
        
        let vcToPresent = UINavigationController(rootViewController: editingVC)
        present(vcToPresent, animated: true)
    }
    
}

extension BookDetailVC: AddBookDelegate {
    
    func didSubmit(book: Book) {
        
        PersistenceManager.updateBooks(.delete, book: self.book) { (error) in
            if let error = error {
                self.presentErrorAlert(for: error)
            }
        }
        
        PersistenceManager.updateBooks(.add, book: book) { (error) in
            if let error = error {
                self.presentErrorAlert(for: error)
            }
        }
        
        self.book = book
        configureVC()
    }
    
}
