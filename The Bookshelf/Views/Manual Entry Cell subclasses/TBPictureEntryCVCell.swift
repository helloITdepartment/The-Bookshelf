//
//  TBPictureEntryCVCell.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 10/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

class TBPictureEntryCVCell: TBManualEntryCollectionViewCell {
    
    static let reuseID = "PictureEntryCVCell"

    func set(labelText: String) {
        titleLabel.text = labelText
    }
    
}
