//
//  TBError.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 8/13/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import Foundation

enum TBError: String, Error {
    
    case invalidURL = "Invalid URL. Please try again later."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data returned from the server was invalid. Please try again."
    case unableToSaveBooks = "There was an error storing your Bookshelf."
    case unableToRetrieveBooks = "There was an error retrieving your books."
    case unableToDownloadCover = "There was an error loading the cover image fo this book"
    case bookAlreadySaved = "Looks like you already have that book :)"
    
}
