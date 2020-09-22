//
//  AddBookTabBarController.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 5/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

class AddBookTabBarController: UITabBarController {
    
    var addBookDelegate: AddBookDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureVC()
        viewControllers = [configureISBNVC(), configureManualEntryVC()]
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        tabBar.tintColor = Constants.tintColor
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(doneButtonTapped))
        doneButton.tintColor = Constants.tintColor
        navigationItem.rightBarButtonItem = doneButton
        
        title = "Add New Book"
    }
    
    private func configureISBNVC() -> UIViewController {
        let isbnEntryVC = ISBNEntryVC()
        isbnEntryVC.view.backgroundColor = .systemBackground
        isbnEntryVC.tabBarItem = UITabBarItem(title: "ISBN", image: UIImage(systemName: "barcode"), tag: 0)
        isbnEntryVC.addBookDelegate = addBookDelegate
        
        return isbnEntryVC
    }

    private func configureManualEntryVC() -> UIViewController{
        let manualEntryVC = ManualEntryVC()
        manualEntryVC.view.backgroundColor = .systemBackground
        manualEntryVC.tabBarItem = UITabBarItem(title: "Manual", image: UIImage(systemName: "text.alignleft"), tag: 1)
        manualEntryVC.addBookDelegate = addBookDelegate
        
        return manualEntryVC
    }
    
    @objc func doneButtonTapped() {
        dismiss(animated: true)
    }
}
