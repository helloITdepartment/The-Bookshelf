//
//  ManualEntryVC.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 5/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

protocol HelperVCPresenterDelegate {
    func present(_ vc: UIViewController)
    func presentErrorAlert(for error: TBError)
}

class ManualEntryVC: UIViewController {

    var addBookDelegate: AddBookDelegate!
    
    var book: Book? {
        didSet {
//            fillInCollectionViewFields()
        }
    }
    
    var didConfigureCollectionView = false
    var didFillInCollectionViewFields = false
    
    var collectionView: UICollectionView!
    
    var selectedCell: TBManualEntryCollectionViewCell?
    
    let fields: [(label: String, placeholder: String?, required: Bool, type: EntryCellType)] = [
        ("Cover image", nil, false, .picture),
        ("Title", "The Adventures of Tom Sawyer", true, .regular),
        ("Subtitle", "subtitle", false, .regular),
        ("Genre", "Adventure Fiction", false, .regular),
        ("Author", "Mark Twain", true, .regular),
        ("Location", nil, false, .options),
        ("ISBN", "0451526538", false, .numeric),
        ("I'm on page", "102", false, .numeric),
        ("Number of pages", "340", false, .numeric)
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Be on guard for the keyboard popping up
        setUpKeyboardNotificationObserver()
    }
    
    override func viewWillLayoutSubviews() {

        //viewWillLayoutSubviews can get called multiple times, including every time the view's bounds change, for example on rotations
        //This can lead to the problem of, in this example, the collectionView being put on twice
        //So as a quick fix, I'm putting a flag here to check if it's already been run
        
        if !didConfigureCollectionView {
            //Configure the collectionView
            configureCollectionView()
            
            //configure the Add button
            let addButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addButtonTapped))
            addButton.tintColor = Constants.tintColor
            
            tabBarController!.navigationItem.leftBarButtonItem = addButton
            
            didConfigureCollectionView = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fillInCollectionViewFields()
    }
    
    func setUpKeyboardNotificationObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillRise), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    private func configureCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionView.createVerticalFlowLayout(for: view.frame.width))
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //Register the different types
        collectionView.register(TBTextEntryCVCell.self, forCellWithReuseIdentifier: TBTextEntryCVCell.reuseID)
        collectionView.register(TBNumericEntryCVCell.self, forCellWithReuseIdentifier: TBNumericEntryCVCell.reuseID)
        collectionView.register(TBOptionEntryCVCell.self, forCellWithReuseIdentifier: TBOptionEntryCVCell.reuseID)
        collectionView.register(TBPictureEntryCVCell.self, forCellWithReuseIdentifier: TBPictureEntryCVCell.reuseID)

        collectionView.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
    }
    
    public func fillInCollectionViewFields() {
        
        guard book != nil else {
            print("Book was nil")
            return
        }
        guard collectionView != nil else {
            print("Collection view was nil")
            return
        }
        
        //Fill in the cover
        if let coverURL = book?.coverUrl {
            NetworkManager.shared.getCoverImage(from: coverURL) { (result) in
                switch result {
                
                case .success(let image):
                    
                    DispatchQueue.main.async {
                        
                        guard let coverImageCell = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? TBPictureEntryCVCell else {
                            print("Couldn't find cover image cell")
                            return
                        }
                        
                        coverImageCell.picture = image
                    }
                    
                case .failure(let error):
                    print(error.rawValue)
                    self.presentErrorAlert(for: error)
                }
            }
        }
        
        //Fill in the title
        if let title = book?.title {
            guard let titleCell = self.collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? TBTextEntryCVCell else {
                print("Couldn't find title cell")
                return
            }
            
            titleCell.setTextFieldValue(to: title)
        }
        
        //Fill in the subtitle
        if let subtitle = book?.subtitle {
            guard let subtitleCell = self.collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as? TBTextEntryCVCell else {
                print("Couldn't find subtitle cell")
                return
            }
            
            subtitleCell.setTextFieldValue(to: subtitle)
        }
        
        //Fill in the authors
        if let authors = book?.authors {
            guard let authorsCell = self.collectionView.cellForItem(at: IndexPath(item: 4, section: 0)) as? TBTextEntryCVCell else {
                print("Couldn't find authors cell")
                return
            }
            
            let commaSeparatedAuthors = authors.joined(separator: ", ")
            authorsCell.setTextFieldValue(to: commaSeparatedAuthors)
        }
        
        //Fill in the ISBN
        if let isbn = book?.isbn {
            guard let isbnCell = self.collectionView.cellForItem(at: IndexPath(item: 6, section: 0)) as? TBNumericEntryCVCell else {
                print("Couldn't find isbn cell")
                return
            }
            
            isbnCell.setTextFieldValue(to: isbn)
        }
        
        //Fill in the number of pages
        if let numPages = book?.numberOfPages {
            guard let pagesCell = self.collectionView.cellForItem(at: IndexPath(item: 8, section: 0)) as? TBNumericEntryCVCell else {
                print("Couldn't find the pages cell")
                return
            }
            
            pagesCell.setTextFieldValue(to: String(numPages))
        }
        
        //If it made it this far, that means none of the fields weren't found, and so
        didFillInCollectionViewFields = true
    }
    
    @objc func addButtonTapped() {
        print("add Button tapped")
        
        //Checks if any field which is marked required doesn't have text in it
        for i in 0..<fields.count {
            let indexPath = IndexPath(item: i, section: 0)
            if fields[i].required { //Put this check first to avoid assignment of cell if it's unnecessary
                if let cell = collectionView.cellForItem(at: indexPath) as? TBManualEntryCollectionViewCell {
                    if cell.isEmpty(){
                        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                        cell.flashRed()
                        return
                    }
                }
            }
        }
        
        //TODO:- make this not horrible
        let bookTitle = (collectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as! TBTextEntryCVCell).getTextFieldValue()
        let subtitle = (collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as! TBTextEntryCVCell).getTextFieldValue()
        let genre = (collectionView.cellForItem(at: IndexPath(item: 3, section: 0)) as! TBTextEntryCVCell).getTextFieldValue()
        let author = (collectionView.cellForItem(at: IndexPath(item: 4, section: 0)) as! TBTextEntryCVCell).getTextFieldValue()
        let location = (collectionView.cellForItem(at: IndexPath(item: 5, section: 0)) as! TBOptionEntryCVCell).getValue()
        let isbn = (collectionView.cellForItem(at: IndexPath(item: 6, section: 0)) as! TBNumericEntryCVCell).getTextFieldValue()
        let numPages = (collectionView.cellForItem(at: IndexPath(item: 8, section: 0)) as! TBNumericEntryCVCell).getTextFieldValue()
        
        let book = Book(title: bookTitle!, subtitle: subtitle, authors: [author!], location: location, isbn: isbn, coverUrl: nil, numberOfPages: nil)
        addBookDelegate.didSubmit(book: book)

        dismiss(animated: true)
    }
    
    @objc func keyboardWillRise(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        guard let keyb = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyb.cgRectValue
        
        guard let collectionView = collectionView else { return }
        //I'll be honest, I don't know *why* three quarters of the height of the keyboard is the perfect height, I just know that it is
        collectionView.contentInset.bottom = (keyboardFrame.height * 0.75)
    }
    
    @objc func keyboardWillHide() {
        print("he has unrisen")
        
        guard let collectionView = collectionView else { return }
        collectionView.contentInset.bottom = 0
    }
    
    
}

extension ManualEntryVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fields.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let fieldTuple = fields[indexPath.row]
        let labelText = fieldTuple.label + (fieldTuple.required ? " (required)" : "")
        
        switch fieldTuple.type {
        case .regular:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TBTextEntryCVCell.reuseID, for: indexPath) as! TBTextEntryCVCell
            cell.set(labelText: labelText, textFieldPlaceholderText: fieldTuple.placeholder ?? "")
            
            return cell
            
        case .numeric:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TBNumericEntryCVCell.reuseID, for: indexPath) as! TBNumericEntryCVCell
            cell.set(labelText: labelText, textFieldPlaceholderText: fieldTuple.placeholder ?? "")
            
            return cell
            
        case .options:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TBOptionEntryCVCell.reuseID, for: indexPath) as! TBOptionEntryCVCell
            cell.helperVCPresenterDelegate = self
            cell.set(labelText: labelText)
            
            return cell
            
        case .picture:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TBPictureEntryCVCell.reuseID, for: indexPath) as! TBPictureEntryCVCell
            cell.helperVCPresenterDelegate = self
            cell.set(labelText: labelText)
            
            return cell
        }
    }
    
}

extension ManualEntryVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO:- Grow, make text field primary
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? TBTextEntryCVCell else { return }
        
        selectedCell = cell
        cell.grow()
        cell.makeTextFieldPrimary()
        
        //Make sure cell isn't hidden behind the keyboard
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? TBTextEntryCVCell else { return }
//        print("deselected cell for \(fields[indexPath.row].label)")
        cell.shrink()
    }
    
}

extension ManualEntryVC: HelperVCPresenterDelegate {

    func present(_ vc: UIViewController) {
        present(vc, animated: true)
    }
}
