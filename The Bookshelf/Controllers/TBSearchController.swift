//
//  TBSearchController.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 2/3/21.
//  Copyright © 2021 Q Technologies. All rights reserved.
//

import UIKit

class TBSearchController: UISearchController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(searchBar.frame)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }

}
