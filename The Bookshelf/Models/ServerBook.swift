//
//  ServerBook.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 8/13/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import Foundation

class ServerBook: Codable {
    var title: String
    var subtitle: String?
    var authors: [[String : String]]
//    var isbn: String?
    var identifiers: [String : [String]]?
    var cover: [String : String]?
    var numberOfPages: Int?
}
