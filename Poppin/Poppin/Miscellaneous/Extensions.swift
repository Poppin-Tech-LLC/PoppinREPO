//
//  Extensions.swift 
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 1/14/20.
//  Copyright © 2020 PoppinREPO. All rights reserved.
//

import UIKit
import SFSafeSymbols // Allows for easy access of Apple Symbols
import MapKit

extension UIFont {
    
    static func dynamicFont(with name: String, style: UIFont.TextStyle) -> UIFont {
        
        let maximumPointSize: CGFloat
        
        switch style {
            
        case .largeTitle: maximumPointSize = .getWidthFitSize(minSize: 37.5, maxSize: 38.5)
        case .title1: maximumPointSize = .getWidthFitSize(minSize: 31.5, maxSize: 32.5)
        case .title2: maximumPointSize = .getWidthFitSize(minSize: 25.5, maxSize: 26.5)
        case .title3: maximumPointSize = .getWidthFitSize(minSize: 23.5, maxSize: 24.5)
        case .headline: maximumPointSize = .getWidthFitSize(minSize: 20.5, maxSize: 21.5)
        case .body: maximumPointSize = .getWidthFitSize(minSize: 20.5, maxSize: 21.5)
        case .callout: maximumPointSize = .getWidthFitSize(minSize: 19.5, maxSize: 20.5)
        case .subheadline: maximumPointSize = .getWidthFitSize(minSize: 18.5, maxSize: 19.5)
        case .footnote: maximumPointSize = .getWidthFitSize(minSize: 16.5, maxSize: 17.5)
        case .caption1: maximumPointSize = .getWidthFitSize(minSize: 15.5, maxSize: 16.5)
        case .caption2: maximumPointSize = .getWidthFitSize(minSize: 14.5, maxSize: 15.5)
        default: maximumPointSize = .getWidthFitSize(minSize: 20.5, maxSize: 21.5)
            
        }
        
        return UIFontMetrics.default.scaledFont(for: UIFont(name: name, size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: style).pointSize)!, maximumPointSize: maximumPointSize)
        
    }
    
}

extension UIColor {
    
    // Main App Colors:
    
    static let mainCREAM = UIColor(named: "mainCREAM")!
    static let mainDARKGRAY = UIColor(named: "mainDARKGRAY")!
    static let mainDARKPURPLE = UIColor(named: "mainDARKPURPLE")!
    
    // Popsicle Colors:
    
    static let poppinDARKGOLD = UIColor(named: "poppinDARKGOLD")!
    static let poppinLIGHTGOLD = UIColor(named: "poppinLIGHTGOLD")!
    static let socialDARKRED = UIColor(named: "socialDARKRED")!
    static let socialLIGHTRED = UIColor(named: "socialLIGHTRED")!
    static let foodDARKORANGE = UIColor(named: "foodDARKORANGE")!
    static let foodLIGHTORANGE = UIColor(named: "foodLIGHTORANGE")!
    static let educationDARKBLUE = UIColor(named: "educationDARKBLUE")!
    static let educationLIGHTBLUE = UIColor(named: "educationLIGHTBLUE")!
    static let sportsDARKGREEN = UIColor(named: "sportsDARKGREEN")!
    static let sportsLIGHTGREEN = UIColor(named: "sportsLIGHTGREEN")!
    static let cultureDARKPURPLE = UIColor(named: "cultureDARKPURPLE")!
    static let cultureLIGHTPURPLE = UIColor(named: "cultureLIGHTPURPLE")!
    
    static func UIColorFromHex(rgbValue: UInt32, alpha: Double = 1.0) -> UIColor {
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
        
    }
    
}

extension UIImage {
    
    // Popsicle Icons
    
    static let defaultPopsicleIcon64 = UIImage(named: "defaultPopsicleIcon64")!
    static let defaultPopsicleIcon128 = UIImage(named: "defaultPopsicleIcon128")!
    static let defaultPopsicleIcon256 = UIImage(named: "defaultPopsicleIcon256")!
    static let defaultPopsicleIcon1024 = UIImage(named: "defaultPopsicleIcon1024")!
    
    static let popsicleGroupIcon64 = UIImage(named: "popsicleGroupIcon64")!
    static let popsicleGroupIcon128 = UIImage(named: "popsicleGroupIcon128")!
    static let popsicleGroupIcon256 = UIImage(named: "popsicleGroupIcon256")!
    static let popsicleGroupIcon1024 = UIImage(named: "popsicleGroupIcon1024")!
    
    static let poppinEventPopsicleIcon64 = UIImage(named: "poppinEventPopsicleIcon64")!
    static let poppinEventPopsicleIcon128 = UIImage(named: "poppinEventPopsicleIcon128")!
    static let poppinEventPopsicleIcon256 = UIImage(named: "poppinEventPopsicleIcon256")!
    static let poppinEventPopsicleIcon1024 = UIImage(named: "poppinEventPopsicleIcon1024")!
    
    static let culturePopsicleIcon64 = UIImage(named: "culturePopsicleIcon64")!
    static let culturePopsicleIcon128 = UIImage(named: "culturePopsicleIcon128")!
    static let culturePopsicleIcon256 = UIImage(named: "culturePopsicleIcon256")!
    static let culturePopsicleIcon1024 = UIImage(named: "culturePopsicleIcon1024")!
    
    static let socialPopsicleIcon64 = UIImage(named: "socialPopsicleIcon64")!
    static let socialPopsicleIcon128 = UIImage(named: "socialPopsicleIcon128")!
    static let socialPopsicleIcon256 = UIImage(named: "socialPopsicleIcon256")!
    static let socialPopsicleIcon1024 = UIImage(named: "socialPopsicleIcon1024")!
    
    static let foodPopsicleIcon64 = UIImage(named: "foodPopsicleIcon64")!
    static let foodPopsicleIcon128 = UIImage(named: "foodPopsicleIcon128")!
    static let foodPopsicleIcon256 = UIImage(named: "foodPopsicleIcon256")!
    static let foodPopsicleIcon1024 = UIImage(named: "foodPopsicleIcon1024")!
    
    static let sportsPopsicleIcon64 = UIImage(named: "sportsPopsicleIcon64")!
    static let sportsPopsicleIcon128 = UIImage(named: "sportsPopsicleIcon128")!
    static let sportsPopsicleIcon256 = UIImage(named: "sportsPopsicleIcon256")!
    static let sportsPopsicleIcon1024 = UIImage(named: "sportsPopsicleIcon1024")!
    
    static let educationPopsicleIcon64 = UIImage(named: "educationPopsicleIcon64")!
    static let educationPopsicleIcon128 = UIImage(named: "educationPopsicleIcon128")!
    static let educationPopsicleIcon256 = UIImage(named: "educationPopsicleIcon256")!
    static let educationPopsicleIcon1024 = UIImage(named: "educationPopsicleIcon1024")!
    
    // Map Icons
    
    static let defaultUserPicture64 = UIImage(named: "defaultUserPicture64")!
    static let defaultUserPicture128 = UIImage(named: "defaultUserPicture128")!
    static let defaultUserPicture256 = UIImage(named: "defaultUserPicture256")!
    static let defaultUserPicture1024 = UIImage(named: "defaultUserPicture1024")!
    
    static let moreOptionsIcon64 = UIImage(named: "moreOptionsIcon64")!
    static let moreOptionsIcon128 = UIImage(named: "moreOptionsIcon128")!
    static let moreOptionsIcon256 = UIImage(named: "moreOptionsIcon256")!
    static let moreOptionsIcon1024 = UIImage(named: "moreOptionsIcon1024")!
    
    static let refreshPopsiclesIcon64 = UIImage(named: "refreshPopsiclesIcon64")!
    static let refreshPopsiclesIcon128 = UIImage(named: "refreshPopsiclesIcon128")!
    static let refreshPopsiclesIcon256 = UIImage(named: "refreshPopsiclesIcon256")!
    static let refreshPopsiclesIcon1024 = UIImage(named: "refreshPopsiclesIcon1024")!
    
    // App Background
    
    static let appBackground = UIImage(named: "appBackground")!

}

extension UIView {
    
    public func addShadowAndRoundCorners(cornerRadius: CGFloat? = nil, shadowColor: UIColor? = nil, shadowOffset: CGSize? = nil, shadowOpacity: Float? = nil, shadowRadius: CGFloat? = nil, topRightMask: Bool = true, topLeftMask: Bool = true, bottomRightMask: Bool = true, bottomLeftMask: Bool = true) {
            
        layer.masksToBounds = false
        layer.cornerRadius = 10.0
        layer.cornerCurve = .continuous
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0) // Shifts shadow
        layer.shadowOpacity = 0.3 // Higher value means more opaque
        layer.shadowRadius = 8.0 // Higher value means more blurry
        var maskedCorners = CACornerMask()
        
        if let cr = cornerRadius { layer.cornerRadius = cr }
        if let sc = shadowColor { layer.shadowColor = sc.cgColor }
        if let sof = shadowOffset { layer.shadowOffset = sof }
        if let sop = shadowOpacity { layer.shadowOpacity = sop }
        if let sr = shadowRadius { layer.shadowRadius = sr }
        
        if topRightMask { maskedCorners.insert(.layerMaxXMinYCorner) }
        if topLeftMask { maskedCorners.insert(.layerMinXMinYCorner) }
        if bottomRightMask { maskedCorners.insert(.layerMaxXMaxYCorner) }
        if bottomLeftMask { maskedCorners.insert(.layerMinXMaxYCorner) }
        if !maskedCorners.isEmpty { layer.maskedCorners = maskedCorners }
        
    }
    
    public func getCornerRadiusFit(percentage: CGFloat) -> CGFloat {
        
        return (CGFloat(abs(percentage))/100)*0.5*min(frame.height, frame.width)
        
    }
    
    public enum ShimmerDirection: Int {
        
        case topToBottom = 0
        case bottomToTop
        case leftToRight
        case rightToLeft
        case diagonal
        
    }
    
    public func shimmer(animationSpeed: Float = 2.0, direction: ShimmerDirection = .diagonal, repeatCount: Float = 1) {
        
        // Create color  ->2
        let lightColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1).cgColor
        let blackColor = UIColor.black.cgColor
        
        // Create a CAGradientLayer  ->3
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [blackColor, lightColor, blackColor]
        gradientLayer.frame = CGRect(x: -self.bounds.size.width, y: -self.bounds.size.height, width: 3 * self.bounds.size.width, height: 3 * self.bounds.size.height)
        
        switch direction {
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
        case .rightToLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
            
        case .diagonal:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        }
        
        gradientLayer.locations =  [0.35, 0.50, 0.65] //[0.4, 0.6]
        self.layer.mask = gradientLayer
        
        // Add animation over gradient Layer  ->4
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = CFTimeInterval(animationSpeed)
        animation.repeatCount = repeatCount
        CATransaction.setCompletionBlock { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.layer.mask = nil
        }
        gradientLayer.add(animation, forKey: "shimmerAnimation")
        CATransaction.commit()
        
    }
    
    public func stopShimmeringAnimation() {
        
        self.layer.mask = nil
        
    }
    
}

extension UITextField {
    
    public func setBottomBorder() { self.setBottomBorder(color: UIColor.mainDARKPURPLE, height: 1.0) }
    
    public func setBottomBorder(color: UIColor, height: CGFloat) {
        
      self.borderStyle = .none
      self.layer.backgroundColor = UIColor.white.cgColor
      self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
      self.layer.shadowOffset = CGSize(width: 0.0, height: height)
      self.layer.shadowOpacity = 1.0
      self.layer.shadowRadius = 0.0
        
    }
    
}

extension UITextView {
    
    public func setBottomBorder() { self.setBottomBorder(color: UIColor.mainDARKPURPLE, height: 1.0) }
    
    public func setBottomBorder(color: UIColor, height: CGFloat) {

      self.layer.backgroundColor = UIColor.white.cgColor
      self.layer.masksToBounds = false
      self.layer.shadowColor = color.cgColor
      self.layer.shadowOffset = CGSize(width: 0.0, height: height)
      self.layer.shadowOpacity = 1.0
      self.layer.shadowRadius = 0.0
        
    }
    
}

extension CGPoint {
    
    static func random(_ range: Float) -> CGPoint {
        
        let x = Int(-range + (Float(arc4random_uniform(1000)) / 1000.0) * 2.0 * range)
        let y = Int(-range + (Float(arc4random_uniform(1000)) / 1000.0) * 2.0 * range)
        return CGPoint(x: x, y: y)
        
    }
    
}

extension CGFloat {
    
    public static func getWidthFitSize (minSize: CGFloat, maxSize: CGFloat) -> CGFloat {
        
        return CGSize.currentIphoneSize.width*(((minSize/CGSize.smallestIphoneSize.width) + (maxSize/CGSize.largestIphoneSize.width))/2)
        
    }
    
    public static func getHeightFitSize (minSize: CGFloat, maxSize: CGFloat) -> CGFloat {
        
        return CGSize.currentIphoneSize.height*(((minSize/CGSize.smallestIphoneSize.height) + (maxSize/CGSize.largestIphoneSize.height))/2)
        
    }
    
    public static func getPercentageWidth(percentage: CGFloat) -> CGFloat {
        
        return (CGFloat(abs(percentage))/100)*CGSize.currentIphoneSize.width
        
    }
    
    public static func getPercentageHeight(percentage: CGFloat) -> CGFloat {
        
        return (CGFloat(abs(percentage))/100)*CGSize.currentIphoneSize.height
        
    }
    
    public static func getPercentageWidthFit(minPercentage: CGFloat, maxPercentage: CGFloat) -> CGFloat {
        
        return (getPercentageWidth(percentage: minPercentage) + getPercentageWidth(percentage: maxPercentage))/2
        
    }
    
    public static func getPercentageHeightFit(minPercentage: CGFloat, maxPercentage: CGFloat) -> CGFloat {
        
        return (getPercentageHeight(percentage: minPercentage) + getPercentageHeight(percentage: maxPercentage))/2
        
    }
    
}

extension CGSize {
    
    static let currentIphoneSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    static let smallestIphoneSize = CGSize(width: 320.0, height: 568.0) // Iphone SE
    static let largestIphoneSize = CGSize(width: 414.0, height: 896.0) // Iphone 11 Pro Max
    
    public static func getBestFitSize (minSize: CGSize, maxSize: CGSize) -> CGSize {
        
        let widthFit = CGFloat.getWidthFitSize(minSize: minSize.width, maxSize: maxSize.width)
        let heightFit = CGFloat.getHeightFitSize(minSize: minSize.height, maxSize: maxSize.height)
        
        return CGSize(width: widthFit, height: heightFit)
        
    }
    
    public static func getPercentageSize(percentage: CGFloat) -> CGSize {
        
        return CGSize(width: CGFloat.getPercentageWidth(percentage: percentage), height: CGFloat.getPercentageHeight(percentage: percentage))
        
    }
    
    public static func getPercentageBestFit(minPercentage: CGFloat, maxPercentage: CGFloat) -> CGSize {
        
        return CGSize(width: CGFloat.getPercentageWidthFit(minPercentage: minPercentage, maxPercentage: maxPercentage), height: CGFloat.getPercentageHeightFit(minPercentage: minPercentage, maxPercentage: maxPercentage))
        
    }
    
}
