//
//  ISBNEntryVC.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 5/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit
//import AVFoundation
import Vision

class ISBNEntryVC: UIViewController {

    var addBookDelegate: AddBookDelegate!

    var collectionView: UICollectionView!
    var entryField: TBNumericEntryCVCell!
    var goButton: UIButton!
    
    var loadingSpinnerOverlay: UIView!
    
    let padding: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureCollectionView()
//        configureEntryField()
//        configureGoButton()
        //configureAddButton
    }
        
    //MARK:- Configuring UI layout
    private func configureCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionView.createFlowLayout(for: view.frame.width))
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //Register the different types
        collectionView.register(TBNumericEntryCVCell.self, forCellWithReuseIdentifier: TBNumericEntryCVCell.reuseID)
//        collectionView.register(TBBarcodeEntryCVCell.self, forCellWithReuseIdentifier: TBBarcodeEntryCVCell.reuseID)
        collectionView.register(TBPictureEntryCVCell.self, forCellWithReuseIdentifier: TBPictureEntryCVCell.reuseID)
        
        collectionView.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
    }
    
//    private func configureEntryField() {
//        entryField.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(entryField)
//
//        entryField.set(labelText: "ISBN", textFieldPlaceholderText: "123456789")
//
//        NSLayoutConstraint.activate([
//            entryField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
//            entryField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
//            entryField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
//            entryField.heightAnchor.constraint(equalToConstant: 100)
//        ])
//
//    }
    
    private func configureGoButton(under cell: UICollectionViewCell) {
        
        goButton = UIButton()
        goButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(goButton)
        
        goButton.setTitle("Search", for: .normal)
        goButton.setTitleColor(.secondaryLabel, for: .normal)
        goButton.tintColor = Constants.tintColor
        goButton.backgroundColor = .secondarySystemBackground
        goButton.layer.cornerRadius = 15
                    
        entryField = (cell as! TBNumericEntryCVCell)
        
        NSLayoutConstraint.activate([
            goButton.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            goButton.topAnchor.constraint(equalTo: cell.bottomAnchor, constant: padding),
            goButton.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            goButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        goButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    //MARK:- Button taps
    @objc private func searchButtonTapped() {
        
        guard let isbn = entryField.getTextFieldValue() else { return }
        search(for: isbn)
    }
    
    private func search(for isbn: String) {
        
        //start spinner
        startLoadingSpinner()
        NetworkManager.shared.getBook(for: isbn) { result in
            
            //Stop spinner
            self.stopLoadingSpinner()
            
            switch result {
            case .success(let book):
                print(book)
                
                DispatchQueue.main.async {
                    let authorString = book.authorString()
                    let ac = UIAlertController(title: "Here's what we found, is this right?", message: "\(book.title) by \(authorString)", preferredStyle: .alert)
                    
                    let correctButton = UIAlertAction(title: "Looks great, let's add it!", style: .default) { (alertAction) in
                        self.correctButtonTapped(book: book)
                    }
                    let correctEditButton = UIAlertAction(title: "Close, but let me edit some things", style: .default) { (alertAction) in
                        self.correctEditButtonTapped(book: book)
                    }
                    let incorrectButton = UIAlertAction(title: "Hmm that doesn't look right", style: .destructive) { (alertAction) in
                        self.incorrectButtonTapped()
                    }
                    
                    ac.addAction(correctButton)
                    ac.addAction(correctEditButton)
                    ac.addAction(incorrectButton)
                    
                    self.present(ac, animated: true)
                }
                
            case .failure(let error):
                //TODO:- actually do something useful with these errors
                print(error.localizedDescription)
            }
        }
        
    }
    
    private func correctButtonTapped(book: Book) {
        print("Correct, let's add it")
        addBookDelegate.didSubmit(book: book)
        dismiss(animated: true)
    }
    
    private func correctEditButtonTapped(book: Book) { 
        print("Correct, but let's change some things")
    }
    
    private func incorrectButtonTapped() {
        print("Incorrect")
        dismiss(animated: true)
    }
    
    private func process(_ observations: [VNDetectedObjectObservation]) {
        
        guard let bestGuess = (observations.first as? VNBarcodeObservation), let isbn = bestGuess.payloadStringValue else {
            
            let ac = UIAlertController(title: "Hmm...", message: "It looks like something went wrong. Please try again, or, if you prefer, just type the ISBN in.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Got it", style: .default))
            present(ac, animated: true)
            return
        }
        
        search(for: isbn)
//        print(bestGuess.payloadStringValue)
    }
    
    private func startLoadingSpinner() {
        loadingSpinnerOverlay = UIView(frame: view.bounds)
        view.addSubview(loadingSpinnerOverlay)
        loadingSpinnerOverlay.backgroundColor = .systemBackground
        loadingSpinnerOverlay.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            self.loadingSpinnerOverlay.alpha = 0.8
        }
        
        let loadingSpinner = UIActivityIndicatorView(style: .large)
        loadingSpinnerOverlay.addSubview(loadingSpinner)
        
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        loadingSpinner.startAnimating()
    }
    
    private func stopLoadingSpinner() {
        DispatchQueue.main.async {
            self.loadingSpinnerOverlay.removeFromSuperview()
            self.loadingSpinnerOverlay = nil
        }
    }
}
//MARK:- Extensions

//MARK:- CollectionViewDataSource
extension ISBNEntryVC: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TBBarcodeEntryCVCell.reuseID, for: indexPath) as! TBBarcodeEntryCVCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TBPictureEntryCVCell.reuseID, for: indexPath) as! TBPictureEntryCVCell
            cell.helperVCPresenterDelegate = self
            cell.cameraDelegateToPass = self
            cell.set(labelText: "Scan a barcode")
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TBNumericEntryCVCell.reuseID, for: indexPath) as! TBNumericEntryCVCell
            cell.set(labelText: "ISBN", textFieldPlaceholderText: "123456789")
            
            return cell
        }
    }
    
    
}

//MARK:- CollectionViewDelegate
extension ISBNEntryVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == 1 {
            configureGoButton(under: cell)
        }
    }
}

//MARK:- PresenterDelegate
extension ISBNEntryVC: HelperVCPresenterDelegate {
    
    func present(_ vc: UIViewController) {
        present(vc, animated: true)
    }
}

//MARK:- CameraVC Delegate
extension ISBNEntryVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)

        let picture = info[.originalImage] as? UIImage
        guard let cgImage = picture?.cgImage else { return }
        
        let request = VNDetectBarcodesRequest { (request, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let observations = request.results as? [VNDetectedObjectObservation] else { return }
//            print("observations are:", observations)
            self.process(observations)
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try requestHandler.perform([request])
        } catch {
            print(error)
        }
    }
}

//extension ISBNEntryVC: AVCaptureMetadataOutputObjectsDelegate {
//
//}
