//
//  HashtagConfiguration.swift
//  Hashtags
//
//  Created by Oscar Götting on 6/10/18.
//
import UIKit

open class HashtagConfiguration {
    var paddingLeft: CGFloat = 0.0
    var paddingTop: CGFloat = 0.0
    var paddingRight: CGFloat = 0.0
    var paddingBottom: CGFloat = 0.0
    var removeButtonSize: CGFloat = 0.0
    var removeButtonSpacing: CGFloat = 0.0
    var cornerRadius: CGFloat = 0.0
    var textSize: CGFloat = 0.0
    var textColor = UIColor()
    var backgroundColor = UIColor()
}

extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}

extension UIImage {
    
    func scaledImage(withSize size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    func scaleImageToFitSize(size: CGSize) -> UIImage {
        let aspect = self.size.width / self.size.height
        if size.width / aspect <= size.height {
            return scaledImage(withSize: CGSize(width: size.width, height: size.width / aspect))
        } else {
            return scaledImage(withSize: CGSize(width: size.height * aspect, height: size.height))
        }
    }
}
