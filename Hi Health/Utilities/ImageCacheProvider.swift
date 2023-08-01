//
//  ImageCacheProvider.swift
//  Hi Health
//
//  Created by k2 tam on 15/07/2023.
//

import Foundation
import UIKit

class ImageCacheProvider {
    static let shared = ImageCacheProvider()
    private let cache = NSCache<NSString,UIImage>()
    
    private init() {}
    
    func fetchImage(imgUrlString: String, completion: @escaping (UIImage?) -> Void) {
        
        if let image = cache.object(forKey: "image") {
            completion(image)
            return
        }
        
        guard let imgUrl = URL(string: imgUrlString) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: imgUrl) {[weak self] data, _, error in

            guard let data = data, error == nil else {
                print("error in fetching data")
                return
            }
            
            
            guard let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                self?.cache.setObject(image, forKey: "image")
                
                completion(image)
                
            }
  
        }
        
        task.resume()
    }
    
}
