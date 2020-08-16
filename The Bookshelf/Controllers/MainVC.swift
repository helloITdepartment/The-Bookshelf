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
    
    enum Section {
        case main
        //TODO:- maybe figure out a way to have the rooms where the books might be plus a "lent out" section
    }
    
    var books: [Book] = []
    
    var collectionView: UICollectionView!
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, Book>!
    var listView: UITableView!
    var listViewDataSource: UITableViewDiffableDataSource<Section, Book>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemRed
        
        //TODO:- get rid of this, it's only for testing
//        NetworkManager.shared.getBookTest(for: "idk some isbn") { [weak self] result in
//            guard let self = self else { return }
//
//            switch result{
//
//            case .success(let book):
//                print("Got the book \(book.title)")
//                self.didSubmit(book: book)
//            case .failure(let error):
//                //TODO:- something useful with this error
//                print(error.localizedDescription)
//            }
//        }
        
        configureNavBar()
        loadBooks()
        configureCollectionView()
        showCollectionView()
        configureDiffableDataSources()
        
    }
    
    private func configureNavBar() {
        //In production, should use the one with "listViewButtonTapped" and showCollectionView in the viewDidLoad
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "text.justify"), style: .plain, target: self, action: #selector(listViewButtonTapped))
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid.3x2"), style: .plain, target: self, action: #selector(collectionViewButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
    }
    
    private func loadBooks() {
        
        PersistenceManager.retrieveBooks { [weak self] result in
            
            guard let self = self else { return }
            
            switch result{
            case .success(let books):
                self.books = books
                self.updateDataSources(with: self.books, animated: true)
            case .failure(let error):
                //TODO:- actually do something useful with these errors
                print(error.rawValue)
            }
        }
    }
    
    private func configureDiffableDataSources() {
        
        //CollectionView dataSource
        collectionViewDataSource = UICollectionViewDiffableDataSource<Section, Book>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, book) -> UICollectionViewCell? in
           
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TBCollectionViewCell.reuseID, for: indexPath) as! TBCollectionViewCell
            cell.set(book: book)
            
            return cell
        })
        
        //ListView dataSource
    }
    
    private func showListView() {
        
        view.clear()
        
        //Pull this bit out into a "configureListView" function so it only needs to be called once
        listView = UITableView(frame: view.bounds)
        listView.rowHeight = 60
        listView.dataSource = self
        listView.delegate = self
        listView.register(TBBookCell.self, forCellReuseIdentifier: TBBookCell.reuseID)
        listView.backgroundColor = .systemBackground
        
        view.addSubview(listView)
    }
    
    private func configureCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createNColumnFlowLayout(withNColumns: 3))
        collectionView.delegate = self
        collectionView.register(TBCollectionViewCell.self, forCellWithReuseIdentifier: TBCollectionViewCell.reuseID)
        collectionView.backgroundColor = .systemOrange
        
    }
    
    private func showCollectionView() {
        
        view.clear()
                
        view.addSubview(collectionView)
    }
    
    private func showAddEntryController() {
        print("Pretend the addBookVC just popped up")
        
        let addEntryVC = AddBookTabBarController()
        addEntryVC.addBookDelegate = self
        present(addEntryVC, animated: true)
        
    }
    
    private func createNColumnFlowLayout(withNColumns n: Int) -> UICollectionViewFlowLayout {
        
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10 // smallest amount of space between items
        let numberOfItemSpacings: CGFloat = CGFloat(n-1) // number of times you'll need ^. As in how many spaces that border 2 items.
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * numberOfItemSpacings)
        let itemWidth = availableWidth / CGFloat(n)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
        
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
    
    func updateDataSources(with books: [Book], animated: Bool) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Book>()
        snapshot.appendSections([.main])
        snapshot.appendItems(books)
        
        DispatchQueue.main.async {
            
            //TODO:- figure out if this has some sort of performance/memory penalty, and if it does, keep track of which view is currently up and only update that one
            self.collectionViewDataSource.apply(snapshot, animatingDifferences: animated)
            //self.listViewDataSource.apply(snapshot, animatingDifferences: animated)
        }
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

extension MainVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        print(book.title)
    }
    
}
