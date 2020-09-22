//
//  Book.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 5/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import Foundation

struct Book: Codable, Hashable {
    var title: String
    var subtitle: String?
    var authors: [String]
    var isbn: String?
//    var identifiers: [String : [String]]?
    var coverUrl: String?
    var numberOfPages: Int?
    //TODO:- Maybe add a notes section?
    
    init(title: String, subtitle: String?, authors: [String], isbn: String?, coverUrl: String?, numberOfPages: Int?) {
        self.title = title
        self.subtitle = subtitle
        self.authors = authors
        self.isbn = isbn
        self.coverUrl = coverUrl
        self.numberOfPages = numberOfPages
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
            if let isbn10 = identifiers["isbn_10"] {
                isbn = isbn10[0]
            } else if let isbn13 = identifiers["isbn_13"] {
                isbn = isbn13[0]
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
    }
    
    public func authorString() -> String {
        
        if authors.count == 1 {
            return authors[0]
        } else {
            var mutableAuthors = authors
            let last = mutableAuthors.popLast()!
            return (mutableAuthors.joined(separator: ", ") + "and \(last)")
        }
    }
}

extension Book: Equatable {
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.isbn == rhs.isbn
    }
}
