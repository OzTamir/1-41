//
//  ColorManager.swift
//  OneFourtyOne
//
//  Created by Oz Tamir on 7/30/15.
//  Copyright (c) 2015 Oz Tamir. All rights reserved.
//

import UIKit

class ColorManager {
    
    static let colorNames = ["Green", "Red", "Blue", "Yellow", "White", "Black", "Purple", "Pink", "Brown", "Orange"]
    static let colorForName = [
        "Green" : UIColor(red:0.09, green:0.77, blue:0.24, alpha:1.0),
        "Red" : UIColor(red:0.77, green:0.09, blue:0.09, alpha:1.0),
        "Blue" : UIColor(red:0.09, green:0.44, blue:0.77, alpha:1.0),
        "Yellow" : UIColor(red:0.78, green:0.89, blue:0.10, alpha:1.0),
        "White" : UIColor.whiteColor(),
        "Black" : UIColor.blackColor(),
        "Purple" : UIColor(red:0.72, green:0.22, blue:0.80, alpha:1.0),
        "Pink" : UIColor(red:0.89, green:0.08, blue:0.91, alpha:1.0),
        "Brown" : UIColor(red:0.65, green:0.43, blue:0.16, alpha:1.0),
        "Orange" : UIColor(red:1.00, green:0.62, blue:0.04, alpha:1.0)
    ]
    
    class func getNotSoRandomColor() -> UIColor {
        // Choose a random color from the array
        let randomColorName = colorNames[Int(arc4random_uniform(UInt32(ColorManager.colorNames.count)))]
        return ColorManager.colorForName[randomColorName]!
    }
    
//    class func getColorPairs(number: Int, withColorName: String) -> ([])
    
    // Get an array with names of colors
    class func getColorNames(number: Int, withColorName: String) -> ([String]) {
        var items = [String]()
        var targetInArray = false
        // Arguments are constants
        var counter = number
        while counter > 0 {
            // random key from array
            let arrayKey = Int(arc4random_uniform(UInt32(ColorManager.colorNames.count)))
            if contains(items, ColorManager.colorNames[arrayKey]) {
                continue
            }
            
            if withColorName == ColorManager.colorNames[arrayKey] {
                targetInArray = true
            }
            items.append(ColorManager.colorNames[arrayKey])
            counter -= 1
        }
        
        if !targetInArray {
            items[Int(arc4random_uniform(UInt32(items.count)))] = withColorName
        }
        
        return items
    }
    
    // Get a random color
    class func getRandomColor(offset : Double = 1.0) -> UIColor{
        var randomRed:CGFloat = CGFloat(max(0.0, min(1.0, drand48() * offset)))
        var randomGreen:CGFloat = CGFloat(max(0.0, min(1.0, drand48() * offset)))
        var randomBlue:CGFloat = CGFloat(max(0.0, min(1.0, drand48() * offset)))
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
}
