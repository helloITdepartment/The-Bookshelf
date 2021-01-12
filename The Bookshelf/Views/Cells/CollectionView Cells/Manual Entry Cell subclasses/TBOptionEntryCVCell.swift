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
    
    var manualEntryController: ManualEntryController!
    
    static let lentOutOptionSelected =  Notification.Name("lentOutOptionSelected")
    static let lentOutOptionDeselected =  Notification.Name("lentOutOptionDeselected")

    var helperVCPresenterDelegate: HelperVCPresenterDelegate!
    var type: OptionEntryCellType! {
        didSet {
            switch type {
            
            case .none:
    //            fatalError("OptionCell type was not set")
               print("OptionCell type was not set")
            case .location:
                
                PersistenceManager.retrieveLocations { [weak self] (result) in
                    guard let self = self else { return }
                    switch result {
                    case .success(let locations):
                        self.options = locations
                    case .failure(let error):
                        self.helperVCPresenterDelegate.presentErrorAlert(for: error)
                    }
                }
                
            case .people:
                
                PersistenceManager.retrievePeople { (result) in
                    switch result {
                    case .success(let people):
                        self.options = people
//                        print(people)
                    case .failure(let error):
                        self.helperVCPresenterDelegate.presentErrorAlert(for: error)
                    }
                }
                
            }
        }
    }

    var collectionView: UICollectionView!
    var selectedCell: OptionsCVCell? = nil {
        didSet {
            guard oldValue?.getText() != selectedCell?.getText() else { return } //Make sure something has actually changed
            if selectedCell?.getText() == .lentOut {
                manualEntryController.lentOutOptionSelected()
            } else if oldValue?.getText() == .lentOut && selectedCell?.getText() != .lentOut{ //Listen, I know that the second half is redundant based on the fact that a) we're in the else of an if that checked the opposite, and that b) the guard above is ensuring that this value can't be the same as the old value, so if the first half of the conditional is true, the second half must be, but I just needed to put this in to make myself feel better and this is my app, so
                manualEntryController.lentOutOptionDeselected()
            }
        }
    }
    var optionToSelect: String? = nil
    
    var options: [String] = []
    
    var submitButtonForAddOptionAlertController: UIAlertAction!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
//
//        guard (optionToSelect != nil) else { return }
//
//        selectOption(withName: optionToSelect!)
        
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
    
    public func selectOption(withName name: String) {

        guard let indexOfOptionToSelect = options.firstIndex(of: name) else { return }

        guard let optionToSelect = collectionView.cellForItem(at: IndexPath(item: indexOfOptionToSelect, section: 0)) as? OptionsCVCell else { return }
        selectedCell = optionToSelect
        optionToSelect.indicateSelected()

        //Make sure the option we're selection is even int he Location picker, otherwise it should have no bearing on whether "lent out..." was selected or deselected
        guard type == .location else { return }

        if optionToSelect.getText() == .lentOut { //TODO:- add check that we're in the Location picker, and that someone didn't just and "lent out..." as an option in the people picker
            NotificationCenter.default.post(name: TBOptionEntryCVCell.lentOutOptionSelected, object: nil)
        } else {
            NotificationCenter.default.post(name: TBOptionEntryCVCell.lentOutOptionDeselected, object: nil)
        }

//        collectionView.selectItem(at: IndexPath(item: indexOfOptionToSelect, section: 0), animated: false, scrollPosition: .centeredHorizontally)
//        print("found \(name) at", indexOfOptionToSelect)


    }

    @objc private func addButtonTapped() {
        print("add button tapped")
        selectedCell?.removeSelectedIndication()
        selectedCell = nil
        
        let alertControllerTitle = (type == .people ? "Add a person" : "Add a location")
        let ac = UIAlertController(title: alertControllerTitle, message: nil, preferredStyle: .alert)
        
        ac.addTextField { (textField) in
            textField.placeholder = (self.type == .people ? "Aunt Marge" : "Living room")
            textField.autocapitalizationType = (self.type == .people ? .words : .sentences)
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(textField:)), for: .editingChanged)
        }
        
        submitButtonForAddOptionAlertController = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let text = ac.textFields?[0].text else { return }
            
            switch self.type {
            
            case .none:
                fatalError("OptionCell type was not set")
            case .location:
                self.options.insert(text, at: 1)
                
                PersistenceManager.updateLocations(.add, location: text) { (error) in
                    if let error = error {
                        print(error)
                    }
                }
                
                //TODO:- find a way to make the newly added location be selected when this alert controller goes away
                self.collectionView.reloadData()
                NotificationCenter.default.post(name: TBOptionEntryCVCell.lentOutOptionDeselected, object: nil)
                //In case the user has swiped away from the front of the list, this will snap it back so they see the location they just added
                self.collectionView.selectItem(at: IndexPath(item: 1, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                
            case .people:
                self.options.insert(text, at: 0)

                
                PersistenceManager.updatePeople(.add, person: text) { (error) in
                    if let error = error {
                        print(error)
                    }
                }
                
                //TODO:- find a way to make the newly added location be selected when this alert controller goes away
                self.collectionView.reloadData()
                //In case the user has swiped away from the front of the list, this will snap it back so they see the location they just added
                self.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                
            }
            
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
        options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionsCVCell.reuseID, for: indexPath) as! OptionsCVCell
        
        let text = options[indexPath.row]
        cell.setText(to: text)
        if text == optionToSelect {
            cell.indicateSelected()
            self.selectedCell = cell
        }
//        cell.widthAnchor.constraint(equalToConstant: cell.getLabelSize().width).isActive = true
//        print(cell.getLabelSize())
//        print("Cell size", cell.frame.width, cell.frame.height)
        return cell
    }
    
    
}

extension TBOptionEntryCVCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? OptionsCVCell else { return }

//        print(cell.getText())
        if cell == selectedCell {
            collectionView.deselectItem(at: indexPath, animated: false)
            selectedCell = nil
            cell.removeSelectedIndication()
            
        } else {
            if selectedCell != nil { //Data was prefilled
                if let indexPathToDeselect = collectionView.indexPath(for: selectedCell!){
                    collectionView.deselectItem(at: indexPathToDeselect, animated: false)
                    selectedCell?.removeSelectedIndication()
                }
            }
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

enum OptionEntryCellType {
    case location
    case people
}
