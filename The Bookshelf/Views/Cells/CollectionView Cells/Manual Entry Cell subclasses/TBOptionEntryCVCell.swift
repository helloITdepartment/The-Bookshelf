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
    
    var locations: [String] = []
    
    var submitButtonForAddOptionAlertController: UIAlertAction!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        PersistenceManager.retrieveLocations { (result) in
            switch result {
            case .success(let tempLocations):
                self.locations = tempLocations
                print(tempLocations)
            case .failure(let error):
                self.helperVCPresenterDelegate.presentErrorAlert(for: error)
            }
        }
        configureAddButton()
    }

    override func configureLowerView() {
        super.configureLowerView()
        
        DispatchQueue.main.async {
            self.configureCollectionView()
        }
    }
    
    private func configureAddButton() {
        let addButton = UIButton()
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addButton.tintColor = Constants.tintColor
        
        addButton.translatesAutoresizingMaskIntoConstraints = false

        addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            addButton.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            addButton.widthAnchor.constraint(equalTo: addButton.heightAnchor)
        ])
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(labelText: String) {
        titleLabel.text = labelText
    }
        
//    public func getValue() -> Location? {
//        selectedCell == nil ? nil : Location(name: selectedCell?.getText())
//    }
    
    public func getValue() -> String? {
        selectedCell?.getText()
    }
    
    @objc private func addButtonTapped() {
        print("add button tapped")
        selectedCell?.removeSelectedIndication()
        selectedCell = nil
        
        let ac = UIAlertController(title: "Add a location", message: nil, preferredStyle: .alert)
        
        ac.addTextField { (textField) in
            textField.placeholder = "Living room"
            textField.autocapitalizationType = .sentences
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(textField:)), for: .editingChanged)
        }
        
        submitButtonForAddOptionAlertController = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let text = ac.textFields?[0].text else { return }
            self.locations.insert(text, at: 1)
            PersistenceManager.updateLocations(.add, location: text) { (error) in
                if let error = error {
                    print(error)
                }
            }
            //TODO:- find a way to make the newly added location be selected when this alert controller goes away
            self.collectionView.reloadData()
            //In case the user has swiped away from the front of the list, this will snap it back so they see the location they just added
            self.collectionView.selectItem(at: IndexPath(item: 1, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
        submitButtonForAddOptionAlertController.isEnabled = false
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(submitButtonForAddOptionAlertController)
        ac.addAction(cancelButton)
        
        //This gives it a nice bold look, as well as makes it the action taken on the enter button
        ac.preferredAction = submitButtonForAddOptionAlertController

        helperVCPresenterDelegate.present(ac)
    }
    
    @objc func alertTextFieldDidChange(textField: UITextField) {
        submitButtonForAddOptionAlertController.isEnabled = !(textField.text?.isEmpty ?? true)
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

        print(cell.getText())
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
