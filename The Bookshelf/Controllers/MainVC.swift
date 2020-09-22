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

//Just putting this here so there's something to commit
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
        
        configureNavBar()
        configureCollectionView()
        configureListView()
        showCollectionView()
        configureDiffableDataSources()
        loadBooks()
        
    }
    
    private func configureNavBar() {
        
        //In production, should use the one with "listViewButtonTapped" and showCollectionView in the viewDidLoad
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "text.justify")?.withTintColor(Constants.tintColor), style: .plain, target: self, action: #selector(listViewButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = Constants.tintColor
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid.3x2"), style: .plain, target: self, action: #selector(collectionViewButtonTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Constants.tintColor
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
        listViewDataSource = UITableViewDiffableDataSource<Section, Book>(tableView: listView, cellProvider: { (tableView, indexPath, book) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TBBookCell.reuseID) as! TBBookCell
            let book = self.books[indexPath.row]
            cell.set(book: book)
            return cell
            
        })
    }
    
    //MARK:- List view
    private func configureListView() {
        
        listView = UITableView(frame: view.bounds)
        listView.rowHeight = 60
        listView.delegate = self
        listView.register(TBBookCell.self, forCellReuseIdentifier: TBBookCell.reuseID)
        listView.backgroundColor = .systemBackground
        
    }
    
    private func showListView() {
        
        view.clear()
        view.addSubview(listView)
        updateDataSources(with: books, animated: false)

    }
    
    //MARK:- CollectionView
    private func configureCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createNColumnFlowLayout(withNColumns: 3))
        collectionView.delegate = self
        collectionView.register(TBCollectionViewCell.self, forCellWithReuseIdentifier: TBCollectionViewCell.reuseID)
        collectionView.backgroundColor = .systemBackground
        collectionView.tintColor = Constants.tintColor
        
    }
    
    private func showCollectionView() {
        
        view.clear()
        view.addSubview(collectionView)
        updateDataSources(with: books, animated: true)

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
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 60)
        
        return flowLayout
        
    }
    
    private func showAddEntryController() {
//        print("Pretend the addBookVC just popped up")
        
        let addEntryVC = AddBookTabBarController()
        addEntryVC.addBookDelegate = self
        
        let navController = UINavigationController(rootViewController: addEntryVC)
        present(navController, animated: true)
        
    }
    
    func updateDataSources(with books: [Book], animated: Bool) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Book>()
        snapshot.appendSections([.main])
        snapshot.appendItems(books)
        
        if view.subviews.contains(collectionView){
            DispatchQueue.main.async {
                self.collectionViewDataSource.apply(snapshot, animatingDifferences: animated)
            }
        } else if view.subviews.contains(listView) {
            DispatchQueue.main.async {
                self.listViewDataSource.apply(snapshot, animatingDifferences: animated)
            }
        }
    }

    //MARK:- Tap actions
    @objc private func listViewButtonTapped() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid.3x2"), style: .plain, target: self, action: #selector(collectionViewButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = Constants.tintColor

        
        print("Switching to list view")
        
        showListView()
    }
    
    @objc private func collectionViewButtonTapped() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "text.justify"), style: .plain, target: self, action: #selector(listViewButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = Constants.tintColor

        
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

extension MainVC: UITableViewDelegate {}

extension MainVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        print(book)
    }
    
}
