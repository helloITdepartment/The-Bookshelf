//
//  PersistenceManager.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 8/13/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import Foundation

enum PersistenceActionType {
    case add
    case delete
    case move
}

enum PersistenceManager {
    enum Keys {
        static let books = "books"
    }
    
    static private let defaults = UserDefaults.standard
    
    //MARK:- Book stuff
    static func retrieveBooks(completed: @escaping (Result<[Book], TBError>) -> Void) {
        
        //Have to make sure there's even something in there for "books"
        guard let booksObject = defaults.value(forKey: Keys.books) else {
            completed(.success([]))
            return
        }
        
        //Have to make sure what's there is even understandable Data
        guard let encodedBooks = booksObject as? Data else {
            completed(.failure(.unableToRetrieveBooks))
            return
        }
        
        //Try to pull the books out of the data
        do{
            let decoder = JSONDecoder()
            let books = try decoder.decode([Book].self, from: encodedBooks)
            completed(.success(books))
        } catch {
            completed(.failure(.unableToRetrieveBooks))
        }
    }
    
    static func saveBooks(books: [Book]) -> TBError? {
        
        do{
            let encoder = JSONEncoder()
            let encodedBooks = try encoder.encode(books)
            defaults.set(encodedBooks, forKey: Keys.books)
            //We made it this far, and nothing went horribly wrong. Sending back word that there are no errors.
            return nil
        }catch{
            //Something went wrong somewhere while trying to save
            return .unableToSaveBooks
        }

    }
    
    static func updateBooks(_ actionType: PersistenceActionType, book: Book, completed: @escaping (TBError?) -> Void) {
        
        retrieveBooks { result in
            switch result {
                
            case .success(let books):
                //make an editable version of the list of books
                var mutableBooks = books
                
                //Decide what edit needs to be made and make it
                switch actionType {
                case .add:
                    
                    //check to make sure the books isn't already in there
                    guard !mutableBooks.contains(book) else {
                        completed(.bookAlreadySaved)
                        return
                    }
                    
                    mutableBooks.append(book)
                    
                case .delete:
                    //TODO:- implement this
                    return
                case .move:
                    //TODO:- implement this
                    return
                }
                
                //Store the result of the editing over the old list of books
                completed(saveBooks(books: mutableBooks))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    //MARK:- Cover stuff
}
