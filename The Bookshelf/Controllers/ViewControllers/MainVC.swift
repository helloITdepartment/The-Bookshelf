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

protocol DeleteBookDelegate {
    func didRequestToDelete(book: Book)
}

class MainVC: UIViewController {
    
    enum Section {
        case main
        //TODO:- maybe figure out a way to have the rooms where the books might be plus a "lent out" section
    }
    
    var books: [Book] = []
    var filteredBooks: [Book] = []
    var isUsingFilteredBooks = false
    
    var collectionView: UICollectionView!
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, Book>!
    var listView: UITableView!
    var listViewDataSource: TBTableViewDiffableDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemRed
        
        configureNavBar()
        configureCollectionView()
        configureListView()
        showCollectionView()
        configureDiffableDataSources()
        configureSearchController()
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
                print(error.rawValue)
                self.presentErrorAlert(for: error)
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
        listViewDataSource = TBTableViewDiffableDataSource(tableView: listView, cellProvider: { (tableView, indexPath, book) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TBBookCell.reuseID) as! TBBookCell
            let book = self.books[indexPath.row]
            cell.set(book: book)
            return cell
            
        })
        listViewDataSource.deleteBookDelegate = self
        
        
    }
    
    private func configureSearchController() {
        
        let searchController = UISearchController()
        searchController.searchBar.tintColor = Constants.tintColor
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
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
    
    //TODO: this isn't very DRY
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

//MARK:- Extensions
extension MainVC: AddBookDelegate {
    
    func didSubmit(book: Book) {
        
        PersistenceManager.updateBooks(.add, book: book) { error in
            if let error = error {
                //TODO:- something useful with this error
                print(error.rawValue)
                self.presentErrorAlert(for: error)
            }
        }
        
        loadBooks()
    }
    
}

extension MainVC: DeleteBookDelegate{
    
    func didRequestToDelete(book: Book) {
        PersistenceManager.updateBooks(.delete, book: book) { (error) in
            
            if let error = error{
                self.presentErrorAlert(for: error)
            }
            
        }
        
        books.removeAll { (bookUnderConsideration) -> Bool in
            bookUnderConsideration == book
        }
        
        updateDataSources(with: books, animated: true)
    }
    
}

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = isUsingFilteredBooks ? filteredBooks[indexPath.row] : books[indexPath.row]
        print(book)
    }
}

extension MainVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = isUsingFilteredBooks ? filteredBooks[indexPath.row] : books[indexPath.row]
        print(book)
    }
    
}

extension MainVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchString = searchController.searchBar.text else {
            updateDataSources(with: books, animated: true)
            return
        }
        
        guard !searchString.isEmpty else {
            updateDataSources(with: books, animated: true)
            return
        }
        
        filteredBooks = books.filter({ book -> Bool in
            book.shouldMatchSearchString(searchString)
        })
        isUsingFilteredBooks = true
        
        updateDataSources(with: filteredBooks, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        isUsingFilteredBooks = false
        updateDataSources(with: books, animated: true)
        
    }
    
}
