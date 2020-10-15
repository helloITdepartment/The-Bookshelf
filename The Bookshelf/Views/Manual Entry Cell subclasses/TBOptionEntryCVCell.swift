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

    func set(labelText: String) {
        titleLabel.text = labelText
    }
}
