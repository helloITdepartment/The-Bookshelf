//
//  TBError.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 8/13/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import Foundation

enum TBError: String, Error {
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data returned from the server was invalid. Please try again."

}
