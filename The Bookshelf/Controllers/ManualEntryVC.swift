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
    
    let fields: [(label: String, placeholder: String)] = [("Title", "The Adventures of Tom Sawyer"), ("Author", "Mark Twain"), ("ISBN", "0451526538")]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Configure the collectionView
        configureCollectionView()
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
        
        cell.grow()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //TODO:- Shrink
    }
}
