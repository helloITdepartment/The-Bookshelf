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
    var selectedCell: OptionsCVCell? = nil
    
//    let locations = [ "a", "b", "c", "d", "e", "f"]
    let locations = [.lentOut, "Main room", "Guest bedroom", "Downstairs", "test", "one more", "and one just for kicks", "lallalalalalalalalala real long boi"]
//    var selectedLocation: String? = nil
    
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
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(OptionsCVCell.self, forCellWithReuseIdentifier: OptionsCVCell.reuseID)
        
        collectionView.backgroundColor = .tertiarySystemBackground
        collectionView.layer.cornerRadius = Constants.mediumItemCornerRadius
        collectionView.showsHorizontalScrollIndicator = false
        
        lowerView.addSubview(collectionView)
    }
    
//    public func getValue() -> Location? {
//        selectedCell == nil ? nil : Location(name: selectedCell?.getText())
//    }
    
    public func getValue() -> String? {
        selectedCell?.getText()
    }
}

extension TBOptionEntryCVCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        locations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionsCVCell.reuseID, for: indexPath) as! OptionsCVCell
        
        cell.setText(to: locations[indexPath.row])
//        cell.widthAnchor.constraint(equalToConstant: cell.getLabelSize().width).isActive = true
//        print(cell.getLabelSize())
//        print("Cell size", cell.frame.width, cell.frame.height)
        return cell
    }
    
    
}

extension TBOptionEntryCVCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? OptionsCVCell else { return }

        if cell == selectedCell {
            collectionView.deselectItem(at: indexPath, animated: false)
            selectedCell = nil
            cell.removeSelectedIndication()
        } else {
            selectedCell = cell
            cell.indicateSelected()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? OptionsCVCell else { return }

        selectedCell = nil
        cell.removeSelectedIndication()

    }
}
