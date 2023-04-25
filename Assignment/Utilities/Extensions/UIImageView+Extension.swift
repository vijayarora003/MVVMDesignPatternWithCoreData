//
//  UIImageView+Extension.swift
//  Assignment
//
//  Created by Vijay Arora on 21/01/23.
//  Copyright © 2023 Vijay Arora. All rights reserved.

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func downloadImage(_ url: String?, placeholder: String = "placeholder") {
        let placeHolderImage = UIImage(named: placeholder)
        guard let url = url, let encodedURLString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imageURL = URL(string: encodedURLString) else {
            self.image = placeHolderImage
            return
        }
        
        if let image = imageCache.object(forKey: imageURL as AnyObject) as? UIImage {
            self.image = image
        } else {
           let dataTask = URLSession.shared.dataTask(with: URLRequest(url: imageURL)) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        imageCache.setObject(image, forKey: imageURL as AnyObject)
                        self.image = image
                    }
                }
            }
            dataTask.resume()
        }
    }
}
