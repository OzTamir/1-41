
//
//  GameplayScene.swift
//  OneFourtyOne
//
//  Created by Oz Tamir on 7/24/15.
//  Copyright (c) 2015 Oz Tamir. All rights reserved.
//

import UIKit
import SpriteKit

class GameplayScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        var nums = [
            (SKColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0) ,"Red"),
            (SKColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0) ,"Green"),
            (SKColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0) ,"Blue"),
            (SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) ,"White")
        ]
        var items = [(SKColor, String)]()
        for var i = 0; i < 4 ; i++ {
            
            // random key from array
            let arrayKey = Int(arc4random_uniform(UInt32(nums.count)))
            
            // your random number
            items.append(nums[arrayKey])
            
            // make sure the number isnt repeated
            nums.removeAtIndex(arrayKey)
        }
        
        let upRightButton = childNodeWithName("upRightButton")
        upRightButton?.runAction(SKAction.colorizeWithColor(items[0].0, colorBlendFactor: 1.0, duration: 0.0))
        let upRightLabel = childNodeWithName("upRightLabel") as! SKLabelNode
        upRightLabel.text = items[0].1
        
        let upLeftButton = childNodeWithName("upLeftButton")
        upLeftButton?.runAction(SKAction.colorizeWithColor(items[1].0, colorBlendFactor: 1.0, duration: 0.0))
        let upLeftLabel = childNodeWithName("upLeftLabel") as! SKLabelNode
        upLeftLabel.text = items[1].1
        
        let downRightButton = childNodeWithName("downRightButton")
        downRightButton?.runAction(SKAction.colorizeWithColor(items[2].0, colorBlendFactor: 1.0, duration: 0.0))
        let downRightLabel = childNodeWithName("downRightLabel") as! SKLabelNode
        downRightLabel.text = items[2].1
        
        let downLeftButton = childNodeWithName("downLeftButton")
        downLeftButton?.runAction(SKAction.colorizeWithColor(items[3].0, colorBlendFactor: 1.0, duration: 0.0))
        let downLeftLabel = childNodeWithName("downLeftLabel") as! SKLabelNode
        downLeftLabel.text = items[3].1
    }
}
