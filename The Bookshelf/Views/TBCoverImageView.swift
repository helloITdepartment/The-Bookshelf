//
//  TBCoverImageView.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 8/14/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

class TBCoverImageView: UIImageView {

    let placeholderImage = UIImage(systemName: "book.fill")
    let cache = NetworkManager.shared.cache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = Constants.smallItemCornerRadius
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
    }
    
    func setImage(fromUrl urlString: String) {
        
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            self.image = image
            return
        }
        
        
        NetworkManager.shared.getCoverImage(from: urlString) { result in
            switch result {
                
            case .success(let image):
                self.cache.setObject(image, forKey: cacheKey)
                DispatchQueue.main.async {
                    self.image = image
                }
            case .failure(let error):
                //TODO:- actually do something useful with these errors
                print(error.rawValue)
            }
        }
    }
    
}
