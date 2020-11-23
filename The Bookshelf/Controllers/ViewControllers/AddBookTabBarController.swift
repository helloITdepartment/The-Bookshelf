//
//  AddBookTabBarController.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 5/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

protocol EditBookDelegate {
    func edit(book: Book)
}

class AddBookTabBarController: UITabBarController {
    
    var addBookDelegate: AddBookDelegate! {
        didSet {
            isbnVC.addBookDelegate = addBookDelegate
            manualEntryVC.addBookDelegate = addBookDelegate
        }
    }
    
    var isbnVC: ISBNEntryVC!
    var manualEntryVC: ManualEntryVC!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureVC()
        
        configureISBNVC()
        configureManualEntryVC()
        
        viewControllers = [isbnVC, manualEntryVC]
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        tabBar.tintColor = Constants.tintColor
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(doneButtonTapped))
        doneButton.tintColor = Constants.tintColor
        navigationItem.rightBarButtonItem = doneButton
        
        title = "Add New Book"
    }
    
    private func configureISBNVC() {
        isbnVC = ISBNEntryVC()
        isbnVC.view.backgroundColor = .systemBackground
        isbnVC.editBookDelegate = self
        isbnVC.tabBarItem = UITabBarItem(title: "ISBN", image: UIImage(systemName: "barcode"), tag: 0)
    }

    private func configureManualEntryVC() {
        manualEntryVC = ManualEntryVC()
        manualEntryVC.view.backgroundColor = .systemBackground
        manualEntryVC.tabBarItem = UITabBarItem(title: "Manual", image: UIImage(systemName: "text.alignleft"), tag: 1)
    }
    
    @objc func doneButtonTapped() {
        dismiss(animated: true)
    }
    
}

extension AddBookTabBarController: EditBookDelegate {
    
    func edit(book: Book) {
        manualEntryVC.book = book
        manualEntryVC.tabBarController?.selectedIndex = 1
    }

}
