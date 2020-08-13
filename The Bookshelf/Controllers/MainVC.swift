//
//  MainVC.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 5/13/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    var collectionView: UICollectionView!
    var listView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemRed
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "text.justify"), style: .plain, target: self, action: #selector(listViewButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        
        showCollectionView()
    }
    
    @objc private func listViewButtonTapped() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid.3x2"), style: .plain, target: self, action: #selector(collectionViewButtonTapped))
        
        print("Switching to list view")
        
        showListView()
    }
    
    @objc private func collectionViewButtonTapped() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "text.justify"), style: .plain, target: self, action: #selector(listViewButtonTapped))
        
        print("Switching to collection view")
        
        showCollectionView()
    }
    
    @objc private func plusButtonTapped() {
        showAddEntryController()
    }
    
    private func showListView() {
        
        view.clear()
        
        listView = UITableView(frame: view.bounds)
        listView.backgroundColor = .systemYellow
        view.addSubview(listView)
    }
    
    private func showCollectionView() {
        
        view.clear()
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .systemOrange
        view.addSubview(collectionView)
    }
    
    private func showAddEntryController() {
        print("Pretend the addBookVC just popped up")
        
        let addEntryVC = AddBookTabBarController()
        present(addEntryVC, animated: true)
        
    }
}
