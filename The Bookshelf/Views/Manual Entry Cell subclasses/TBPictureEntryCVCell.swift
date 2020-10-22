//
//  TBPictureEntryCVCell.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 10/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class TBPictureEntryCVCell: TBManualEntryCollectionViewCell{
    
    static let reuseID = "PictureEntryCVCell"
    
    var helperVCPresenterDelegate: HelperVCPresenterDelegate!
    var cameraDelegateToPass: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?
    
    var cameraButton: UIButton!
    var photosButton: UIButton!
    var imageView: UIImageView!

    var picture: UIImage? {
        didSet {
            reloadView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(labelText: String) {
        titleLabel.text = labelText
    }
    
    override func configureLowerView() {
        
        lowerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(lowerView)

        if picture != nil {
            
            configureImageView()
            
            NSLayoutConstraint.activate([
                lowerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
                lowerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
                lowerView.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -padding),
                lowerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
            ])
            
        } else {
            
            NSLayoutConstraint.activate([
                lowerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
                lowerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
                lowerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
                lowerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
            ])
            
        }
        
        configureCameraButton()
        configurePhotosButton()
        
    }
    
    private func configureCameraButton() {
        
        //create the button
        cameraButton = UIButton()

        //Style the button (round the corners, set the background color, set the image)
        cameraButton.setImage(UIImage(systemName: "camera.viewfinder"), for: .normal)
        cameraButton.tintColor = Constants.tintColor
        cameraButton.layer.cornerRadius = 10
        cameraButton.backgroundColor = .tertiarySystemBackground

        
        //Attach the action upon tapping the button
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        
        //Add camerabutton to lowerview
        lowerView.addSubview(cameraButton)
        
        //constrain it
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cameraButton.leadingAnchor.constraint(equalTo: lowerView.leadingAnchor),
            cameraButton.topAnchor.constraint(equalTo: lowerView.topAnchor),
            cameraButton.trailingAnchor.constraint(equalTo: lowerView.centerXAnchor, constant: -padding/2),
            cameraButton.bottomAnchor.constraint(equalTo: lowerView.bottomAnchor)
        ])

    }
    
    private func configurePhotosButton() {
        
        //create the button
        photosButton = UIButton()
        
        //Style the button (round the corners, set the background color, set the image)
        photosButton.setImage(UIImage(systemName: "photo.on.rectangle"), for: .normal)
        photosButton.tintColor = Constants.tintColor
        photosButton.layer.cornerRadius = 10
        photosButton.backgroundColor = .tertiarySystemBackground

        
        //Attach the action upon tapping the button
        photosButton.addTarget(self, action: #selector(photosButtonTapped), for: .touchUpInside)
        
        //Add the button to lowerview
        lowerView.addSubview(photosButton)
        
        //constrain it
        photosButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photosButton.leadingAnchor.constraint(equalTo: lowerView.centerXAnchor, constant: padding/2),
            photosButton.topAnchor.constraint(equalTo: lowerView.topAnchor),
            photosButton.trailingAnchor.constraint(equalTo: lowerView.trailingAnchor),
            photosButton.bottomAnchor.constraint(equalTo: lowerView.bottomAnchor)
        ])
    }
    
    private func configureImageView() {
        
        imageView = UIImageView()
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 6/9) //Apparently a standard book has an aspect ration of 6:9
        ])
        
        imageView.image = picture
        imageView.contentMode = .scaleAspectFit
    }
    
    private func reloadView() {
        
        DispatchQueue.main.async {
            self.clear()
            self.configureLabel()
            self.configureLowerView()
            self.layoutIfNeeded()
        }
        
    }
    
    @objc func cameraButtonTapped() {
//        picture = UIImage(named: "testCover")
        
        //Check to see if the camera is available
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            //TODO:- Actually do something with this error
            print(TBError.cameraNotAvailable.rawValue)
            return
        }
        
        //Check if the camera is able to take pictures
        guard UIImagePickerController.availableMediaTypes(for: .camera)!.contains("public.image") else {
            //TODO:- Actually do something with this error
            print(TBError.cameraNotAvailable.rawValue)
            return
        }
        
        //Check if we have permissions
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        
        case .authorized:
            
            //Present the camera
            let cameraVC = UIImagePickerController()
            cameraVC.sourceType = .camera
            cameraVC.mediaTypes = ["public.image"]
            
            if cameraDelegateToPass != nil {
                cameraVC.delegate = cameraDelegateToPass
            } else {
                cameraVC.delegate =  self
            }
            
            helperVCPresenterDelegate.present(cameraVC)
            
        case .notDetermined:
            
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    
                    //Present the camera
                    let cameraVC = UIImagePickerController()
                    cameraVC.sourceType = .camera
                    cameraVC.mediaTypes = ["public.image"]
                    
                    if self.cameraDelegateToPass != nil {
                        cameraVC.delegate = self.cameraDelegateToPass
                    } else {
                        cameraVC.delegate =  self
                    }
                    
                    self.helperVCPresenterDelegate.present(cameraVC)
                    
                }
            }
            
        case .restricted:
            //TODO:- Actually do something with this error
            print(TBError.cameraPermissionRestricted.rawValue)
        case .denied:
            //TODO:- Actually do something with this error
            print(TBError.cameraPermissionDenied.rawValue)
        @unknown default:
            //TODO:- Actually do something with this error
            print(TBError.thisIsAwkward.rawValue)
        }
        
        
    }
    
    @objc func photosButtonTapped() {
        
        //Check to see if the photo picker is available
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            //TODO:- Actually do something with this error
            print(TBError.devicePhotosNotAvailable.rawValue)
            return
        }
        //Check if the pictures are available on this device
        guard UIImagePickerController.availableMediaTypes(for: .photoLibrary)!.contains("public.image") else {
            //TODO:- Actually do something with this error
            print(TBError.devicePhotosNotAvailable.rawValue)
            return
        }
        
        //Check permissions
        if #available(iOS 14, *){
            switch PHPhotoLibrary.authorizationStatus(for: PHAccessLevel.readWrite){
            case .notDetermined:
                
                PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { (authStatus) in
                    if authStatus == .authorized {
                        
                        //Present the photo picker
                        DispatchQueue.main.async {
                            let photoChooserVC = UIImagePickerController()
                            photoChooserVC.sourceType = .photoLibrary
                            photoChooserVC.mediaTypes = ["public.image"]
                            
                            if self.cameraDelegateToPass != nil {
                                photoChooserVC.delegate = self.cameraDelegateToPass
                            } else {
                                photoChooserVC.delegate =  self
                            }
                            
                            self.helperVCPresenterDelegate.present(photoChooserVC)
                        }
                        
                    }
                })
                
            case .restricted:
                //TODO:- Actually do something with this error
                print(TBError.photosPermissionRestricted.rawValue)
            case .denied:
                //TODO:- Actually do something with this error
                print(TBError.photosPermissionDenied.rawValue)
           case .authorized:
                
            //Present the photo picker
            DispatchQueue.main.async {
                let photoChooserVC = UIImagePickerController()
                photoChooserVC.sourceType = .photoLibrary
                photoChooserVC.mediaTypes = ["public.image"]

                if self.cameraDelegateToPass != nil {
                    photoChooserVC.delegate = self.cameraDelegateToPass
                } else {
                    photoChooserVC.delegate =  self
                }

                self.helperVCPresenterDelegate.present(photoChooserVC)
            }
                
            case .limited:
                
                //Present the photo picker
                DispatchQueue.main.async {
                    let photoChooserVC = UIImagePickerController()
                    photoChooserVC.sourceType = .photoLibrary
                    photoChooserVC.mediaTypes = ["public.image"]
                    
                    if self.cameraDelegateToPass != nil {
                        photoChooserVC.delegate = self.cameraDelegateToPass
                    } else {
                        photoChooserVC.delegate =  self
                    }

                    self.helperVCPresenterDelegate.present(photoChooserVC)
                }
            
             @unknown default:
                //TODO:- Actually do something with this error
                print(TBError.thisIsAwkward.rawValue)
            }
        }
    }
    
}

extension TBPictureEntryCVCell: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)

        picture = info[.originalImage] as? UIImage

//        if picture != nil {
////            picture = UIImage(named: "testCover")
//            reloadView()
//        }
    }
}
