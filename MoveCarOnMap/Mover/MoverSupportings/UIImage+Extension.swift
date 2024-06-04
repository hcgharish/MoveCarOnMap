//
//  UIImage+Extension.swift
//  MoveCarOnMap
//
//  Created by Apple Care on 29/05/24.
//

import Foundation
import UIKit

extension UIImage {
    func resize(_ wth: CGFloat) -> UIImage {
        let scale = wth / self.size.width
        let newHeight = self.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: wth, height: newHeight))
        
        self.draw(in: CGRect(x: 0,
                             y: 0,
                             width: wth,
                             height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func base64 (_ quality: CGFloat) -> String {
        let imageData: NSData = self.pngData()! as NSData
        let bytes = Double(imageData.length)/8.0
        let kbb = bytes/1024.0
        let mbb = kbb/1024.0
        
        print("imageData size -> KB[\(kbb)],MB[\(mbb)]")
        
        let profilePicture = imageData.base64EncodedString(options: .lineLength64Characters)
        return profilePicture
    }
    
    func roundedRectImageFromImage(image:UIImage, imageSize:CGSize, cornerRadius:CGFloat)->UIImage{
        UIGraphicsBeginImageContextWithOptions(imageSize,false,0.0)
        
        let bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: imageSize)
        
        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).addClip()
        image.draw(in: bounds)

        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage!
    }
    
    func mapImage(imageSize: Int) -> UIImage {
        let img = resize(CGFloat(imageSize))
        
        let sz = img.size
        
        var rds = sz.height
        
        if sz.width < sz.height {
            rds = sz.width
        }
        
        return img.roundedRectImageFromImage(image: img, imageSize: sz, cornerRadius: rds/2)
    }
}
