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
    
    let fields: [(label: String, placeholder: String)] = [
        ("Title", "The Adventures of Tom Sawyer"),
        ("Genre", "Adventure Fiction"),
        ("Author", "Mark Twain"),
        ("ISBN", "0451526538") ]

    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO:- Make sure the fields aren't hidden behind the keyboard
        
        //Be on guard for the keyboard popping up
        setUpKeyboardNotificationObserver()
        //Configure the collectionView
        configureCollectionView()
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
    
    @objc func keyboardWillRise() {
        print("he has risen")
        
    }
    
    @objc func keyboardWillHide() {
        print("he has unrisen")
    }
    
}

extension ManualEntryVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fields.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TBManualEntryCollectionViewCell.reuseID, for: indexPath) as! TBManualEntryCollectionViewCell
        let fieldTuple = fields[indexPath.row]
        cell.set(labelText: fieldTuple.label, textFieldPlaceholderText: fieldTuple.placeholder)
        
        return cell
    }
    
    
}

extension ManualEntryVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO:- Grow, make text field primary
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? TBManualEntryCollectionViewCell else { return }
//        print("selected cell for \(fields[indexPath.row].label)")
        //Make sure cell isn't hidden behind the keyboard
        
        cell.grow()
        cell.makeTextFieldPrimary()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? TBManualEntryCollectionViewCell else { return }
//        print("deselected cell for \(fields[indexPath.row].label)")
        cell.shrink()
    }
}
