//
//  Extensions.swift
//  WeatherAssistant
//
//  Created by Pooya on 2018-09-28.
//  Copyright © 2018 Pooya. All rights reserved.
//

import UIKit


// Extend String with Two functions for converting Float and Double to string
extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    func toFloat() -> Float {
        return (self as NSString).floatValue
    }
}


// data collection protocol for ViewController
extension ViewController : DataCollectionProtocol {
    
    //pass data to CityScreen from index
    func passData(index: Int) {
        
        let vc =  storyboard?.instantiateViewController(withIdentifier: "CityScreen") as? CityScreenViewController
        if (collectionSource == "Bookmarked") {
            vc?.keyLocationName = bookmarkedArray[index].locationName!
            vc?.keyLat = bookmarkedArray[index].lat!
            vc?.keyLon = bookmarkedArray[index].lon!
        } else {
            vc?.keyLocationName = knownArray[index].locationName!
            vc?.keyLat = knownArray[index].lat!
            vc?.keyLon = knownArray[index].lon!
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    // delete record at index
    func deleteData(index: Int) {
        if (collectionSource == "Bookmarked") {
            bookmarkedArray.remove(at: index)
            bookmarkedTools.deleteDataFromEntity(index: index)
        } else {
            knownArray.remove(at: index)
            knownTools.deleteDataFromEntity(index: index)
        }
        collectionView.reloadData()
    }
}//end of extension  UIButton


// data collection protocol for ViewController
extension UIViewController  {
    
    // get the best option for scaling depend of the current Height or Width
    func bestFrameSize() -> CGFloat {
        let frameHeight = self.view.frame.height
        let frameWidth = self.view.frame.width
        let bestFrameSize = (frameHeight > frameWidth ) ? frameHeight : frameWidth
        
        return bestFrameSize
    }
    
}


//return color from RGB and HEX
extension UIColor {
    
    //few ready colors
    static let lightPink = UIColor(hex: "ffc0cb", alpha: 1)
    static let mistyRose = UIColor(hex: "ffe4e1")
    static let dustyDarkGreen  = UIColor(hex: "008080")
    static let lightlightPink = UIColor(hex: "d3ffce")
    static let lightPurple = UIColor(hex: "e6e6fa")
    
    convenience init(red : Int , green : Int , Blue: Int , alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(Blue) / 255.0,
            alpha : alpha
        )
    }
    
    convenience init(hex : String , alpha: CGFloat = 1.0) {
        
        let index0 = hex.index(hex.startIndex, offsetBy: 0)
        let index1 = hex.index(hex.startIndex, offsetBy: 1)
        let index2 = hex.index(hex.startIndex, offsetBy: 2)
        let index3 = hex.index(hex.startIndex, offsetBy: 3)
        let index4 = hex.index(hex.startIndex, offsetBy: 4)
        let index5 = hex.index(hex.startIndex, offsetBy: 5)
        
        let redHexStr = String(hex[index0...index1])     // "12"
        let greedHexStr = String(hex[index2...index3])     // "34"
        let blueHexStr = String(hex[index4...index5])     // "56"
        
        let red = UInt8(redHexStr, radix: 16)
        let green = UInt8(greedHexStr, radix: 16)
        let blue = UInt8(blueHexStr, radix: 16)
        
        self.init(
            red: CGFloat(red!) / 255.0,
            green: CGFloat(green!) / 255.0,
            blue: CGFloat(blue!) / 255.0,
            alpha : alpha
        )
        
    }
    
    convenience init(hexint: Int , alpha : CGFloat = 1.0) {
        self.init(
            red : (CGFloat((hexint >> 16) & 0xFF)),
            green : (CGFloat((hexint >> 8) & 0xFF)),
            blue : (CGFloat(hexint & 0xFF)),
            alpha : alpha
        )
    }
    
    static func rgb(red: CGFloat , green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    static func hex(hex: Int, alpha : CGFloat = 1.0) -> UIColor {
        return UIColor(
            red : CGFloat((hex >> 16) & 0xFF),
            green : CGFloat((hex >> 8) & 0xFF),
            blue : CGFloat(hex & 0xFF),
            alpha : alpha
        )
    }
}//end of extension  UIColor


//Extention two add customization for buttons
public extension UIButton {
    
    func customizeDelete() {
        let c1GreenColor = (UIColor(red: -0.108958, green: 0.714926, blue: 0.758113, alpha: 1.0))
        let c2GreenColor = (UIColor(red: 0.108958, green: 0.714926, blue: 0.758113, alpha: 1.0))
        self.backgroundColor = UIColor.red
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.layer.cornerRadius = 7
        self.layer.borderWidth = 0.8
        self.layer.borderColor = c1GreenColor.cgColor
        self.layer.shadowColor = c2GreenColor.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 12
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    func shake(horizantaly:CGFloat = 0  , Verticaly:CGFloat = 0) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - horizantaly, y: self.center.y - Verticaly ))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + horizantaly, y: self.center.y + Verticaly ))
        self.layer.add(animation, forKey: "position")
    }
}//end of extension  UIButton


//animation like shake and customization for UITextfield
public extension  UITextField {
    
    func shake(horizantaly:CGFloat = 0  , Verticaly:CGFloat = 0) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - horizantaly, y: self.center.y - Verticaly ))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + horizantaly, y: self.center.y + Verticaly ))
        
        
        self.layer.add(animation, forKey: "position")
        
    }
    
    func customizeTextField() {
        // change UIbutton propertie
        let c1GreenColor = (UIColor(red: -0.108958, green: 0.714926, blue: 0.758113, alpha: 1.0))
        let c2GreenColor = (UIColor(red: 0.108958, green: 0.714926, blue: 0.758113, alpha: 1.0))
        self.backgroundColor = UIColor.yellow
        self.layer.cornerRadius = 7
        self.layer.borderWidth = 0.8
        self.layer.borderColor = c1GreenColor.cgColor
        
        self.layer.shadowColor = c2GreenColor.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 12
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    func uncustomizeTextField(backGroundColor : UIColor ) {
        // change UIbutton propertie
        self.backgroundColor = backGroundColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
}//end of extension  UITextField
