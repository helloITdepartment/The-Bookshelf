//
//  Book.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 5/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

struct Book: Codable, Hashable {
    
    var title: String
    var subtitle: String?
    var genres: [String]?
    var authors: [String]
    //For now location will just be the string, but in the future it will be the Location type, once I have the energy to make that Codable
//    var location: Location?
    var location: String?
    var lentOutTo: String?
    var isbn: String?
//    var identifiers: [String : [String]]?
    var coverImageData: Data?
    var coverUrl: String?
    var currentPage: Int?
    var numberOfPages: Int?
    var dateAdded: Date
    //TODO:_ add something to hold how many pages have been read so far, and genre
    //TODO:- Maybe add a notes section?
    
    init(title: String, subtitle: String?, genres: [String]?, authors: [String], location: String?, lentOutTo: String?, isbn: String?, coverImageData: Data?, coverUrl: String?, currentPage: Int?, numberOfPages: Int?, dateAdded: Date) {
        self.title = title
        self.subtitle = subtitle
        self.genres = genres
        self.authors = authors
        self.location = location
        self.lentOutTo = lentOutTo
        self.isbn = isbn
        self.coverImageData = coverImageData
        self.coverUrl = coverUrl
        self.currentPage = currentPage
        self.numberOfPages = numberOfPages
        self.dateAdded = dateAdded
    }
    
    init(from serverBook: ServerBook) {
        title = serverBook.title
        subtitle = serverBook.subtitle
        
        authors = []
        for authorDictionary in serverBook.authors {
            if let author = authorDictionary["name"] {
                authors.append(author)
            }
        }
        
        if let identifiers = serverBook.identifiers {
            if let isbn13 = identifiers["isbn_13"] {
                isbn = isbn13[0]
            } else if let isbn10 = identifiers["isbn_10"] {
                isbn = isbn10[0]
            }
        }
        
        if let covers = serverBook.cover {
            if let largeCoverUrl = covers["large"] {
                coverUrl = largeCoverUrl
            } else if let mediumCoverUrl = covers["medium"] {
                coverUrl = mediumCoverUrl
            } else if let smallCoverUrl = covers["small"] {
                coverUrl = smallCoverUrl
            }
        }
        
        numberOfPages = serverBook.numberOfPages
        dateAdded = Date()
    }
    
    public func authorString() -> String {
        
        if authors.count == 1 {
            return authors[0]
        } else {
            var mutableAuthors = authors
            let last = mutableAuthors.popLast()!
            return (mutableAuthors.joined(separator: ", ") + " and \(last)")
        }
    }
    
    public func coverImage() -> UIImage? {
        
        //If a picture was taken
        if let data = coverImageData {
            if let image = UIImage(data: data) {
                return image
            }
        }
        
        return nil
        
    }
    
    public func shouldMatchSearchString(_ searchString: String) -> Bool {
        if title.containsCaseInsensitive(searchString) { return true }
        if subtitle != nil && subtitle!.containsCaseInsensitive(searchString) { return true }
        
        //Can't return true from within the foreach since it's expecting a void function
        var shouldReturnTrue = false
        authors.forEach { (author) in
            if author.containsCaseInsensitive(searchString) {
                shouldReturnTrue = true
            }
        }
        if shouldReturnTrue { return true }
        
        if genres != nil {
            genres!.forEach { (genre) in
                if genre.containsCaseInsensitive(searchString) {
                    shouldReturnTrue = true
                }
            }
            if shouldReturnTrue { return true }
        }
        
        if location != nil && location!.containsCaseInsensitive(searchString) { return true }
        if lentOutTo != nil && lentOutTo!.containsCaseInsensitive(searchString) { return true }
        if isbn != nil && isbn!.containsCaseInsensitive(searchString) { return true }
        
        return false
    }
}

extension Book: Equatable { //TODO:- also add Comparable
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        if lhs.title.lowercased() == rhs.title.lowercased() {
            return true
        } else {
            return lhs.isbn == rhs.isbn
        }
    }
}
