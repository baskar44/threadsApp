//
//  ImageView+ext.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 18/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject> ()

extension UIImage {
    
    func cacheImage(imageName: String?){
        if let cachedImage = imageCache.object(forKey: imageName as AnyObject) as? UIImage {
         
        }
        
        if let imageName = imageName {
            imageCache.setObject(self, forKey: imageName as AnyObject)
        }
        
    }
    
}

extension UIImageView {
    
    func loadImageUsingCacheWithURLString(imageURL: String?, completion: @escaping (Bool, Error?) -> Void){
        guard imageURL != nil else {return}
        let imageURL = imageURL!
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: imageURL as AnyObject) as? UIImage {
            DispatchQueue.main.async {
                self.image = cachedImage
                completion(true, nil)
                return
            }
            
        }else {
            
            if imageURL != Constants.sharedInstance._emptyString {
                let url = URL(string: imageURL)
                
                
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if error != nil {
                        completion(false, error)
                    }else {
                        if let imageData = data {
                            if let downloadedImage = UIImage(data: imageData) {
                                DispatchQueue.main.async {
                                    imageCache.setObject(downloadedImage, forKey: imageURL as AnyObject)
                                    self.image = downloadedImage
                                    completion(true, nil)
                                }
                            }else {
                                completion(false, nil)
                            }
                        }else {
                            completion(false, nil)
                        }
                    }
                }).resume()
            }
            
           
        }
        
    }
}


