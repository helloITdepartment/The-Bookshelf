//
//  MainVC.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 5/13/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

protocol AddBookDelegate {
    func didSubmit(book: Book)
}

class MainVC: UIViewController {
    
    var books: [Book] = []
    
    var collectionView: UICollectionView!
    var listView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemRed
        
        //TODO:- get rid of this, it's only for testing
        NetworkManager.shared.getBookTest(for: "idk some isbn") { [weak self] result in
            guard let self = self else { return }

            switch result{

            case .success(let book):
                print("Got the book \(book.title)")
                self.didSubmit(book: book)
            case .failure(let error):
                //TODO:- something useful with this error
                print(error.localizedDescription)
            }
        }
        
        configureNavBar()
        loadBooks()
        showCollectionView()
        
    }
    
    private func configureNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "text.justify"), style: .plain, target: self, action: #selector(listViewButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
    }
    
    private func loadBooks() {
        
        PersistenceManager.retrieveBooks { [weak self] result in
            
            guard let self = self else { return }
            
            switch result{
            case .success(let books):
                self.books = books
            case .failure(let error):
                //TODO:- actually do something useful with these errors
                print(error.rawValue)
            }
        }
    }
    
    private func showListView() {
        
        view.clear()
        
        listView = UITableView(frame: view.bounds)
        listView.rowHeight = 60
        listView.dataSource = self
        listView.delegate = self
        listView.register(TBBookCell.self, forCellReuseIdentifier: TBBookCell.reuseID)

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
        addEntryVC.addBookDelegate = self
        present(addEntryVC, animated: true)
        
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
}

extension MainVC: AddBookDelegate {
    
    func didSubmit(book: Book) {
        
        PersistenceManager.updateBooks(.add, book: book) { error in
            if let error = error {
                //TODO:- something useful with this error
                print(error.rawValue)
            }
        }
        
    }
    
}

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TBBookCell.reuseID) as! TBBookCell
        let book = books[indexPath.row]
        cell.set(book: book)
        return cell
    }
    
    
}
