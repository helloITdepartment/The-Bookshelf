//
//  ManualEntryVC.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 5/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

class ManualEntryVC: UIViewController {

    var addBookDelegate: AddBookDelegate!
    
    var collectionView: UICollectionView!
    
    var selectedCell: TBManualEntryCollectionViewCell?
    
    let fields: [(label: String, placeholder: String, required: Bool, type: EntryCellType)] = [
        ("Title", "The Adventures of Tom Sawyer", true, .regular),
        ("Subtitle", "subtitle", false, .regular),
        ("Genre", "Adventure Fiction", false, .regular),
        ("Author", "Mark Twain", true, .regular),
        ("ISBN", "0451526538", false, .numeric),
        ("I'm on page", "102", false, .numeric),
        ("Number of pages", "340", false, .numeric),
        ]

    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO:- Make sure the fields aren't hidden behind the keyboard
        
        //Be on guard for the keyboard popping up
        setUpKeyboardNotificationObserver()
    }
    
    
    override func viewWillLayoutSubviews() {
        
        //Configure the collectionView
        configureCollectionView()
        
        //configure the Add button
        let addButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = Constants.tintColor
        
        tabBarController!.navigationItem.leftBarButtonItem = addButton
        
    }
    
    func setUpKeyboardNotificationObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillRise), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    private func configureCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TBManualEntryCollectionViewCell.self, forCellWithReuseIdentifier: TBManualEntryCollectionViewCell.reuseID)
        collectionView.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
    }
    
    private func createFlowLayout() -> UICollectionViewFlowLayout {
        
        let width = view.bounds.width
        let padding: CGFloat = 12
        let itemWidth = width - (padding * 2)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth/4)
        
        return flowLayout
        
    }
    
    @objc func addButtonTapped() {
        print("add Button tapped")
        
        //Checks if any field which is marked required doesn't have text in it
        for i in 0..<fields.count {
            let indexPath = IndexPath(item: i, section: 0)
            if fields[i].required { //Put this check first to avoid assignment of cell if it's unnecessary
                let cell = collectionView.cellForItem(at: indexPath) as! TBManualEntryCollectionViewCell
                if cell.getTextFieldValue() == "" {
                    collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                    cell.flashRed()
                    return
                }
            }
        }
        
        //TODO:- make this not horrible
        let bookTitle = (collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! TBManualEntryCollectionViewCell).getTextFieldValue()
        let subtitle = (collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as! TBManualEntryCollectionViewCell).getTextFieldValue()
        let genre = (collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as! TBManualEntryCollectionViewCell).getTextFieldValue()
        let author = (collectionView.cellForItem(at: IndexPath(item: 3, section: 0)) as! TBManualEntryCollectionViewCell).getTextFieldValue()
        let isbn = (collectionView.cellForItem(at: IndexPath(item: 4, section: 0)) as! TBManualEntryCollectionViewCell).getTextFieldValue()
        
        let book = Book(title: bookTitle!, subtitle: subtitle, authors: [author!], isbn: isbn, coverUrl: nil, numberOfPages: nil)
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TBManualEntryCollectionViewCell.reuseID, for: indexPath) as! TBManualEntryCollectionViewCell
        let fieldTuple = fields[indexPath.row]
        cell.set(labelText: fieldTuple.label, textFieldPlaceholderText: fieldTuple.placeholder, type: fieldTuple.type)
        
        return cell
    }
    
}

extension ManualEntryVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO:- Grow, make text field primary
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? TBManualEntryCollectionViewCell else { return }
        
        selectedCell = cell
        cell.grow()
        cell.makeTextFieldPrimary()
        
        //Make sure cell isn't hidden behind the keyboard
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? TBManualEntryCollectionViewCell else { return }
//        print("deselected cell for \(fields[indexPath.row].label)")
        cell.shrink()
    }
}
