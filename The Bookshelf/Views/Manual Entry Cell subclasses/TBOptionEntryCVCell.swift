//
//  TBOptionEntryCVCell.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 10/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

class TBOptionEntryCVCell: TBManualEntryCollectionViewCell {
    
    static let reuseID = "OptionEntryCVCell"

    var helperVCPresenterDelegate: HelperVCPresenterDelegate!

    var collectionView: UICollectionView!
    
    let locations = [nil, "Main room", "Guest bedroom", "Downstairs"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func configureLowerView() {
        super.configureLowerView()
        
        DispatchQueue.main.async {
            self.configureCollectionView()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(labelText: String) {
        titleLabel.text = labelText
    }
    
    private func configureCollectionView() {
    
        collectionView = UICollectionView(frame: lowerView.bounds, collectionViewLayout: UICollectionView.createHorizontalFlowLayout(for: lowerView.frame.height))
        collectionView.backgroundColor = .tertiarySystemBackground
        collectionView.layer.cornerRadius = Constants.smallItemCornerRadius
        lowerView.addSubview(collectionView)
    }
}

extension TBOptionEntryCVCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        locations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}
