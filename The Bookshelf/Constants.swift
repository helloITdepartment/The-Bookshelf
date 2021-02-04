//
//  Constants.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 8/13/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

struct Constants {
    static let inTestingMode = true
    
    static let entryFormFieldBorderWidth: CGFloat = 2
    static let largeItemCornerRadius: CGFloat = 15
    static let mediumItemCornerRadius: CGFloat = 10
    static let smallItemCornerRadius: CGFloat = 5
    
    static let tintColor: UIColor = .systemTeal
    
    static let imageFileMaxSize = 3000 //Maximum file size for the cover images taken on device. Don't want to be using up gigabyte of RAM if the user has tons of books and the covers are all in full res and taken on the newest phones
}

enum EntryCellType {
    case regular
    case numeric
    case options(OptionEntryCellType)
    case picture
}

enum EntryCellID: String {
    case coverImage = "Cover image"
    case title = "Title"
    case subtitle = "Subtitle"
    case genre = "Genre"
    case author = "Author"
    case location = "Location"
    case lentOutTo = "Lent out to..."
    case isbn = "ISBN"
    case myPage = "I'm on page"
    case numPages = "Number of pages"
}

struct SortingType {
    static let byAuthor = { (lhs: Book, rhs: Book) in
        return lhs.authorString() < rhs.authorString()
    }
}
