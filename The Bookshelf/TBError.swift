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
    case bookNotYetSaved = "Couldn't find that book in your list"
    case cameraNotAvailable = "The camera is not available"
    case cameraPermissionDenied = "It looks like you've decided not to grant permission to your camera, which is fine. Everyone is entitled to their privacy.\nBut to use the camera, you'll need to enable permissions. This can be done by going to Settings > The Bookshelf and making sure the camera toggle is on."
    case cameraPermissionRestricted = "Looks like the cemara can't be accessed because of restrictions."
    case thisIsAwkward = "This is awkward. This shouldn't ever really come up unless something's wrong. Pplease contact the developer so he can fix it."
}
