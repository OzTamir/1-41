
//
//  GameplayScene.swift
//  OneFourtyOne
//
//  Created by Oz Tamir on 7/24/15.
//  Copyright (c) 2015 Oz Tamir. All rights reserved.
//

import UIKit
import SpriteKit

enum Buttons : Int {
    case UpRight = 0
    case UpLeft = 1
    case DownRight = 2
    case DownLeft = 3
}

class GameplayScene: SKScene {
    let colors = ["Green", "Red", "Blue", "Yellow", "White"]
    var nodeColors = [String]()
    var targetColor : String?
    var time : NSTimeInterval?
    var started = false
    var running = true
    
    // Time before the buttons are revealed
    let thinkTime = 3.0
    var thinkTimeCounter : NSTimeInterval?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        initDialog()
        initButtons()
    }
    
    func initDialog() -> () {
        let arrayKey = Int(arc4random_uniform(UInt32(self.colors.count)))
        self.targetColor = colors[arrayKey]
        
        let instructionLabel = childNodeWithName("instructionLabel") as! SKLabelNode
        instructionLabel.text = "Press the button that says \(self.targetColor!)"
    }
    
    func getRandomColor() -> UIColor{
        var randomRed:CGFloat = CGFloat(drand48())
        var randomGreen:CGFloat = CGFloat(drand48())
        var randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
    func initButtons() -> () {
        var items = [self.targetColor!]
        for var i = 0; i < 3 ; i++ {
            
            // random key from array
            let arrayKey = Int(arc4random_uniform(UInt32(colors.count)))
            
            // your random number
            items.append(colors[arrayKey])
            
            // make sure the number isnt repeated
            //nums.removeAtIndex(arrayKey)
        }
        
        let upRightButton = childNodeWithName("upRightButton")
        upRightButton?.runAction(SKAction.colorizeWithColor(getRandomColor(), colorBlendFactor: 1.0, duration: 0.0))
        let upRightLabel = childNodeWithName("upRightLabel") as! SKLabelNode
        upRightLabel.text = items[0]
        self.nodeColors.append(items[0])
        
        let upLeftButton = childNodeWithName("upLeftButton")
        upLeftButton?.runAction(SKAction.colorizeWithColor(getRandomColor(), colorBlendFactor: 1.0, duration: 0.0))
        let upLeftLabel = childNodeWithName("upLeftLabel") as! SKLabelNode
        upLeftLabel.text = items[1]
        self.nodeColors.append(items[1])
        
        let downRightButton = childNodeWithName("downRightButton")
        downRightButton?.runAction(SKAction.colorizeWithColor(getRandomColor(), colorBlendFactor: 1.0, duration: 0.0))
        let downRightLabel = childNodeWithName("downRightLabel") as! SKLabelNode
        downRightLabel.text = items[2]
        self.nodeColors.append(items[2])
        
        let downLeftButton = childNodeWithName("downLeftButton")
        downLeftButton?.runAction(SKAction.colorizeWithColor(getRandomColor(), colorBlendFactor: 1.0, duration: 0.0))
        let downLeftLabel = childNodeWithName("downLeftLabel") as! SKLabelNode
        downLeftLabel.text = items[3]
        self.nodeColors.append(items[3])
    }
    
    func setBlocker(hidden: Bool, zPos: Int) -> () {
        let buttonsBlocker = childNodeWithName("buttonsBlocker")
        let instructionLabel = childNodeWithName("instructionLabel") as! SKLabelNode
        
        buttonsBlocker?.hidden = hidden
        buttonsBlocker?.zPosition = CGFloat(zPos - 1)
        instructionLabel.hidden = hidden
        instructionLabel.zPosition = CGFloat(zPos)
    }
    
    override func update(currentTime: NSTimeInterval) {
        if self.time == nil {
            self.time = currentTime
            self.thinkTimeCounter = self.time?.advancedBy(self.thinkTime)
        }
        
        if running {
            let timeLabel = childNodeWithName("timeLabel") as! SKLabelNode
            if started {
                timeLabel.text = String(format: "%.2f", arguments: [currentTime - self.time!])
            }
            else {
                timeLabel.text = String(format: "%.0f", arguments: [self.thinkTimeCounter! - currentTime])
            }

            if (self.thinkTimeCounter! - currentTime) < 0.0 && !started {
                self.started = true
                self.time = currentTime
                setBlocker(true, zPos: 0)
                timeLabel.text = "GO"
            }
        }
        
    }
    
    func checkPress(color: String) -> () {
        let debugLabel = childNodeWithName("debugLabel") as! SKLabelNode
        if color == self.targetColor {
            debugLabel.text = "CORRECT!"
            self.running = false
        }
        else {
            debugLabel.text = "FALSE!"
            self.running = true
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        let debugLabel = childNodeWithName("debugLabel") as! SKLabelNode
        if let name = node.name {
            switch name {
                case "upRightButton", "upRightLabel":
                    checkPress(self.nodeColors[Buttons.UpRight.rawValue])
                case "upLeftButton", "upLeftLabel":
                    checkPress(self.nodeColors[Buttons.UpRight.rawValue])
                case "downRightButton", "downRightLabel":
                    checkPress(self.nodeColors[Buttons.UpRight.rawValue])
                case "downLeftButton", "downLeftLabel":
                    checkPress(self.nodeColors[Buttons.UpRight.rawValue])
                default:
                    debugLabel.text = name
            }
        }
        else {
            debugLabel.text = "NOTHING"
        }
    }
}















