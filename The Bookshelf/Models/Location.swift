//
//  Location.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 10/26/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import Foundation

struct Location {
    
    typealias Shelf = (row: Int, column: Int)
    
    var name: String
    var shelf: Shelf?
    
    
}

extension Location: Equatable {
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.name == rhs.name
    }
    
}
