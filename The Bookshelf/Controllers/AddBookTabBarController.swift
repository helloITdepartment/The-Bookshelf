//
//  AddBookTabBarController.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 5/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

class AddBookTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemPink
        // Do any additional setup after loading the view.
        viewControllers = [configureISBNVC(), configureManualEntryVC()]
    }
    
    private func configureISBNVC() -> UIViewController {
        let isbnEntryVC = ISBNEntryVC()
        isbnEntryVC.view.backgroundColor = .systemBlue
        isbnEntryVC.tabBarItem = UITabBarItem(title: "ISBN", image: UIImage(systemName: "barcode"), tag: 0)
        
        return isbnEntryVC
    }

    private func configureManualEntryVC() -> UIViewController{
        let manualEntryVC = ManualEntryVC()
        manualEntryVC.view.backgroundColor = .systemPurple
        manualEntryVC.tabBarItem = UITabBarItem(title: "Manual", image: UIImage(systemName: "text.alignleft"), tag: 1)
        
        return manualEntryVC
    }
}
