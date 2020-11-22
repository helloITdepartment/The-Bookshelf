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
        static let locations = "locations"
        static let people = "people"
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
                    
                    //Make sure the new one is at the beginning
                    mutableBooks.insert(book, at: 0)
                    
                case .delete:
                    //TODO:- implement this
                    guard mutableBooks.contains(book) else {
                        completed(.bookNotYetSaved)
                        return
                    }
                    
                    mutableBooks.removeAll { (bookUnderConsideration) -> Bool in
                        bookUnderConsideration == book
                    }
                    
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
    
    //MARK:- Location stuff
    static func retrieveLocations(completed: @escaping (Result<[String], TBError>) -> Void) {
        
        //Check if there's anything there. If not, it's new, pass back an empty array with the "lent out" option pre inserted
        guard let locationsObject = defaults.value(forKey: Keys.locations) else {
            completed(.success([.lentOut]))
            return
        }
        
        //Check that what we got back makes sense
        guard let encodedLocations = locationsObject as? Data else {
            completed(.failure(.unableToRetrieveLocations))
            return
        }
        
        //Try and get the locations array from the Data
        do {
            let decoder = JSONDecoder()
            var locations = try decoder.decode([String].self, from: encodedLocations)
            if !locations.contains(.lentOut) {
                locations.insert(.lentOut, at: 0)
            }
            completed(.success(locations))
        } catch {
            completed(.failure(.unableToRetrieveLocations))
        }
    }
    
    static func saveLocations(locations: [String]) -> TBError? {
        do {
            let encoder = JSONEncoder()
            let encodedLocations = try encoder.encode(locations)
            defaults.setValue(encodedLocations, forKey: Keys.locations)
            return nil //Because nothing went wrong, no errors to report
        } catch {
            //Uh oh
            return .unableToSaveLocations
        }
    }
    
    static func updateLocations(_ actionType: PersistenceActionType, location: String, completed: @escaping (TBError?) -> Void) {
        
        retrieveLocations { result in
            switch result {
                
            case .success(let locations):
                //make an editable version of the list of locations
                var mutableLocations = locations
                
                //Decide what edit needs to be made and make it
                switch actionType {
                case .add:
                    
                    //check to make sure the location isn't already in there
                    guard !mutableLocations.contains(location) else {
                        completed(.locationAlreadySaved)
                        return
                    }
                    
                    //Make sure the new one is at the beginning
                    mutableLocations.insert(location, at: 1)
                    
                case .delete:
                    //TODO:- implement this
                    guard mutableLocations.contains(location) else {
                        completed(.locationNotYetSaved)
                        return
                    }
                    
                    mutableLocations.removeAll { (locationUnderConsideration) -> Bool in
                        locationUnderConsideration == location
                    }
                    
                case .move:
                    //TODO:- implement this
                    return
                }
                
                if !mutableLocations.contains(.lentOut) {
                    mutableLocations.insert(.lentOut, at: 0)
                }
                
                //Store the result of the editing over the old list of locations
                completed(saveLocations(locations: mutableLocations))
                
                
                
            case .failure(let error):
                completed(error)
            }
        }
    }

    //Mark:- People stuff
    static func retrievePeople(completed: @escaping (Result<[String], TBError>) -> Void) {
        
        //Have to make sure there's even something in there for "people"
        guard let peopleObject = defaults.value(forKey: Keys.people) else {
            //Otherwise, it's new, so pass back an empty array
            completed(.success([]))
            return
        }
        
        //Have to make sure what's there is even understandable Data
        guard let encodedPeople = peopleObject as? Data else {
            //TODO:- change this to .unable to retrieve people
            completed(.failure(.unableToRetrievePeople))
            return
        }
        
        //Try to pull the books out of the data
        do{
            let decoder = JSONDecoder()
            let people = try decoder.decode([String].self, from: encodedPeople)
            completed(.success(people))
        } catch {
            completed(.failure(.unableToRetrievePeople))
        }
        
    }
    
    static func savePeople(people: [String]) -> TBError? {
        do {
            let encoder = JSONEncoder()
            let encodedPeople = try encoder.encode(people)
            defaults.setValue(encodedPeople, forKey: Keys.people)
            return nil //Because nothing went wrong, no errors to report
        } catch {
            //Uh oh
            return .unableToSavePeople
        }
    }
    
    static func updatePeople(_ actionType: PersistenceActionType, person: String, completed: @escaping (TBError?) -> Void) {
        
        retrievePeople { result in
            switch result {
                
            case .success(let people):
                //make an editable version of the list of people
                var mutablePeople = people
                
                //Decide what edit needs to be made and make it
                switch actionType {
                case .add:
                    
                    //check to make sure the person isn't already in there
                    guard !mutablePeople.contains(person) else {
                        completed(.personAlreadySaved)
                        return
                    }
                    
                    //Make sure the new one is at the beginning
                    mutablePeople.insert(person, at: 0)
                    
                case .delete:
                    //TODO:- implement this
                    guard mutablePeople.contains(person) else {
                        completed(.personNotYetSaved)
                        return
                    }
                    
                    mutablePeople.removeAll { (personUnderConsideration) -> Bool in
                        personUnderConsideration == person
                    }
                    
                case .move:
                    //TODO:- implement this
                    return
                }
                
                //Store the result of the editing over the old list of locations
                completed(savePeople(people: mutablePeople))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    //MARK:- Cover stuff
}
