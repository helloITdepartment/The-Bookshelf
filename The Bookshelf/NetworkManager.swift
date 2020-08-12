//
//  NetworkManager.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 5/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func getBook(for isbn: String, completed: @escaping (Result<Book, Error>) -> Void) {
        
        let endpointString = "https://openlibrary.org/api/books?bibkeys=ISBN:\(isbn)&format=json&jscmd=data"
        
        guard let url = URL(string: endpointString) else {
//            completed(.failure())
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if response.statusCode != 200 {
                print("Status code: \(response.statusCode)")
            }
            
            guard let data = data else {
                print("Invalid data1")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let book = try decoder.decode(Book.self, from: data)
                completed(.success(book))
            } catch {
                print("Invalid data2")
                return
            }
        }
        
        task.resume()
        
    }
    
    func getBookTest(for isbn: String, completed: @escaping (Result<Book, Error>) -> Void) {
        
        do {
            let data = try Data(contentsOf: Bundle.main.url(forResource: "TestData", withExtension: "json")!)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let book = try decoder.decode(Book.self, from: data)
            completed(.success(book))
        } catch {
            print("Invalid data2")
            return
        }
        
    }
        
    func getISBNObject(for isbn: String, completed: @escaping (Result<ISBN, Error>) -> Void) {
            
            let endpointString = "https://openlibrary.org/api/books?bibkeys=ISBN:\(isbn)&format=json&jscmd=data"
            
            guard let url = URL(string: endpointString) else {
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }
                
                if response.statusCode != 200 {
                    print("Status code: \(response.statusCode)")
                }
                
                guard let data = data else {
                    print("Invalid data1")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .custom { keys in
//                        return AnyKey(stringValue: "book")!
//                    }
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let isbnobj = try decoder.decode(ISBN.self, from: data)
                    completed(.success(isbnobj))
                } catch {
                    print("Invalid data2")
                    return
                }
            }
            
            task.resume()
            
        }
}
