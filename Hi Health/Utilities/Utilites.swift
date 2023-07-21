//
//  Utilites.swift
//  Hi Health
//
//  Created by k2 tam on 16/07/2023.
//

import Foundation
import UIKit

class Utilites {
    static var shared = Utilites()
    
    private init() {}
    
    func createCircularImage(image: UIImage) -> UIImage? {
        let imageSize = image.size
        let scale = UIScreen.main.scale

        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        let imageFrame = CGRect(origin: .zero, size: imageSize)

        let path = UIBezierPath(ovalIn: imageFrame)
        path.addClip()

        image.draw(in: imageFrame)

        let circularImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return circularImage
    }
}
