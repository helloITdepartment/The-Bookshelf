//
//  ISBNEntryVC.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 5/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

class ISBNEntryVC: UIViewController {

    var addBookDelegate: AddBookDelegate!

    var entryField = TBManualEntryCollectionViewCell(frame: .zero)
    var goButton: UIButton!
    
    let padding: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureEntryField()
        configureGoButton()
        //configureAddButton
    }

    private func configureEntryField() {
        entryField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(entryField)
        
        entryField.set(labelText: "ISBN", textFieldPlaceholderText: "123456789")
        
        NSLayoutConstraint.activate([
            entryField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            entryField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            entryField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            entryField.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configureGoButton() {
        
        goButton = UIButton()
        goButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(goButton)
        
        goButton.setTitle("Search", for: .normal)
        goButton.setTitleColor(.secondaryLabel, for: .normal)
        goButton.tintColor = Constants.tintColor
        goButton.backgroundColor = .secondarySystemBackground
        goButton.layer.cornerRadius = 15
        
        NSLayoutConstraint.activate([
            goButton.leadingAnchor.constraint(equalTo: entryField.leadingAnchor),
            goButton.topAnchor.constraint(equalTo: entryField.bottomAnchor, constant: padding),
            goButton.trailingAnchor.constraint(equalTo: entryField.trailingAnchor),
            goButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        goButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    @objc private func searchButtonTapped() {
        
        guard let isbn = entryField.getTextFieldValue() else { return }
        
        NetworkManager.shared.getBook(for: isbn) { result in
            
            switch result {
            case .success(let book):
                print(book)
                
                DispatchQueue.main.async {
                    let authorString = book.authorString()
                    let ac = UIAlertController(title: "Here's what we found", message: "\(book.title) by \(authorString)", preferredStyle: .alert)
                    
                    let correctButton = UIAlertAction(title: "Looks great, let's add it!", style: .default) { (alertAction) in
                        self.correctButtonTapped(book: book)
                    }
                    let correctEditButton = UIAlertAction(title: "Looks pretty close, but let me edit some things", style: .default) { (alertAction) in
                        self.correctEditButtonTapped(book: book)
                    }
                    let incorrectButton = UIAlertAction(title: "Hmm that doesn't look right", style: .destructive) { (alertAction) in
                        self.incorrectButtonTapped()
                    }
                    
                    ac.addAction(correctButton)
                    ac.addAction(correctEditButton)
                    ac.addAction(incorrectButton)
                    
                    self.present(ac, animated: true)
                }
                
            case .failure(let error):
                //TODO:- actually do something useful with these errors
                print(error.localizedDescription)
            }
        }
    }
    
    private func correctButtonTapped(book: Book) {
        print("Correct, let's add it")
        addBookDelegate.didSubmit(book: book)
        dismiss(animated: true)
    }
    
    private func correctEditButtonTapped(book: Book) { 
        print("Correct, but let's change some things")
    }
    
    private func incorrectButtonTapped() {
        print("Incorrect")
        dismiss(animated: true)
    }
}
