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
    
    func fetchImage(imgUrlString: String) async -> UIImage? {
        
        
        if let image = cache.object(forKey: "image") {
            print("Using cache")
            return image
        }
        

        guard let imgUrl = URL(string: imgUrlString) else {return nil}
            
        
        do{
            let (data,_) = try await URLSession.shared.data(from: imgUrl)
            let img = UIImage(data: data)
            
            guard let img = img else {
                print("error fetching img")
                return nil
            }
            
            self.cache.setObject(img, forKey: "image")
            return img
        }catch {
            print(error.localizedDescription)
            return nil
        }
        
        
        
//        let task = session.dataTask(with: imgUrl) {[weak self] data, _, error in
//
//            guard let error = error else {
//                return
//            }
//
//            guard let data = data else {
//                print("error in fetching data")
//                return
//            }
//
//                let image = UIImage(data: data)
//
//                guard let image = image else {
//                    completion(nil)
//                    return
//                }
//
//                self?.cache.setObject(image, forKey: "image")
//
//
//
//                completion(image)
//
//        }
//
//        task.resume()
    }
    
}
