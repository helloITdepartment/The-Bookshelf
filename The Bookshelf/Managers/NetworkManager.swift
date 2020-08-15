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
    let cache = NSCache<NSString, UIImage>()
    
    func getISBNObject(for isbn: String, completed: @escaping (Result<ISBN, TBError>) -> Void) {
        
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
                decoder.keyDecodingStrategy = .custom { keys in
                    if(keys.last!.stringValue.contains("ISBN")){
                        return AnyKey(stringValue: "serverBook")!
                    } else {
                        return keys.last!
                    }
                }
                let isbnobj = try decoder.decode(ISBN.self, from: data)
                completed(.success(isbnobj))
            } catch {
                print("Invalid data2")
                return
            }
        }
        
        task.resume()
        
    }
    
    func getBook(for isbn: String, completed: @escaping (Result<Book, TBError>) -> Void) {
        
        getISBNObject(for: isbn) { result in
            
            switch result {
                
            case .success(let isbnObject):
                let serverBook = isbnObject.serverBook
                let book = Book(from: serverBook)
                completed(.success(book))
            case .failure(let error):
                completed(.failure(error))
                
            }
            
        }
        
    }
    
    func getCoverImage(from urlString: String, completed: @escaping (Result<UIImage, TBError>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            guard let self = self else { return }
            
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completed(.failure(.invalidData))
                return
            }
            
            completed(.success(image))
            
        }
        
        task.resume()
    }
    
    func getBookTest(for isbn: String, completed: @escaping (Result<Book, TBError>) -> Void) {
        
        do {
            let data = try Data(contentsOf: Bundle.main.url(forResource: "TestData", withExtension: "json")!)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let serverBook = try decoder.decode(ServerBook.self, from: data)
            let book = Book(from: serverBook)
            completed(.success(book))
        } catch {
            print("getBookTest failed")
            return
        }
        
    }
        
    
}
