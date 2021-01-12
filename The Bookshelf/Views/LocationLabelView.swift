//
//  LocationLabelView.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 12/22/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

class LocationLabelView: UIView {

    private let locationSymbol = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
    private let locationLabel = UILabel()

    init() {
        super.init(frame: .zero)
        
//        backgroundColor = .systemGreen
        
        configureLocationSymbol()
        configureLocationLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLocationSymbol() {
        
        locationSymbol.tintColor = Constants.tintColor
        
        //Add the image view
        addSubview(locationSymbol)
        
        //Constrain it
        locationSymbol.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationSymbol.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            locationSymbol.topAnchor.constraint(equalTo: self.topAnchor),
            locationSymbol.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            locationSymbol.widthAnchor.constraint(equalTo: locationSymbol.heightAnchor)
        ])
    }
    
    private func configureLocationLabel() {
        //Add the label
        addSubview(locationLabel)
        
        //Constrain it
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabel.leadingAnchor.constraint(equalTo: locationSymbol.trailingAnchor, constant: locationSymbol.frame.height/4),
            locationLabel.topAnchor.constraint(equalTo: self.topAnchor),
            locationLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    public func set(labelText: String) {
        locationLabel.text = labelText
    }
}
