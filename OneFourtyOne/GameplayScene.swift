
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
    let colors = ["Green", "Red", "Blue", "Yellow", "White", "Black", "Purple", "Pink", "Brown", "Orange"]
    var nodeColors = [String]()
    var targetColor : String?
    var time : NSTimeInterval?
    var started = false
    var running = true
    var score = 0.0

    // Time before the buttons are revealed
    let thinkTime = 4.0
    var thinkTimeCounter : NSTimeInterval?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        setLabelText("colorLabel", text: "")
        
        setBlocker(false, zPos: 4)
        initDialog()
        initButtons()
    }
    
    func initDialog() -> () {
        // Choose the color for this game
        let arrayKey = Int(arc4random_uniform(UInt32(self.colors.count)))
        self.targetColor = colors[arrayKey]
        
        setLabelText("instructionLabel", text: "Press the button that says \(self.targetColor!)")
    }
    
    func getRandomColor() -> UIColor{
        var randomRed:CGFloat = CGFloat(drand48())
        var randomGreen:CGFloat = CGFloat(drand48())
        var randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    func setLabelText(labelName: String, text: String) -> () {
        let label = childNodeWithName(labelName) as! SKLabelNode
        label.text = text
    }
    
    func getColors() -> ([String]) {
        var localColors = ["Green", "Red", "Blue", "Yellow", "White", "Black", "Purple", "Pink", "Brown", "Orange"]
        var items = [self.targetColor!]
        for var i = 0; i < 3 ; i++ {
            
            // random key from array
            let arrayKey = Int(arc4random_uniform(UInt32(localColors.count)))
            
            // your random number
            items.append(colors[arrayKey])
            
            // make sure the number isnt repeated
            localColors.removeAtIndex(arrayKey)
        }
        
        return items
    }
    
    func initButtons() -> () {
        var items = getColors()
        
        // Init the up-right button/label
        let upRightButton = childNodeWithName("upRightButton")
        upRightButton?.runAction(SKAction.colorizeWithColor(getRandomColor(), colorBlendFactor: 1.0, duration: 0.0))
        setLabelText("upRightLabel", text: items[0])
        self.nodeColors.append(items[0])
        
        // Init the up-left button/label
        let upLeftButton = childNodeWithName("upLeftButton")
        upLeftButton?.runAction(SKAction.colorizeWithColor(getRandomColor(), colorBlendFactor: 1.0, duration: 0.0))
        setLabelText("upLeftLabel", text: items[1])
        self.nodeColors.append(items[1])
        
        // Init the down-right button/label
        let downRightButton = childNodeWithName("downRightButton")
        downRightButton?.runAction(SKAction.colorizeWithColor(getRandomColor(), colorBlendFactor: 1.0, duration: 0.0))
        setLabelText("downRightLabel", text: items[2])
        self.nodeColors.append(items[2])
        
        // Init the down-left button/label
        let downLeftButton = childNodeWithName("downLeftButton")
        downLeftButton?.runAction(SKAction.colorizeWithColor(getRandomColor(), colorBlendFactor: 1.0, duration: 0.0))
        setLabelText("downLeftLabel", text: items[3])
        self.nodeColors.append(items[3])
    }
    
    func setBlocker(hidden: Bool, zPos: Int) -> () {
        let buttonsBlocker = childNodeWithName("buttonsBlocker")
        let instructionLabel = childNodeWithName("instructionLabel") as! SKLabelNode
        
        // Hide the blockers and send 'em to the back
        buttonsBlocker?.hidden = hidden
        buttonsBlocker?.zPosition = CGFloat(zPos - 1)
        instructionLabel.hidden = hidden
        instructionLabel.zPosition = CGFloat(zPos)
    }
    
    override func update(currentTime: NSTimeInterval) {
        // On the first updtae call, set the time variables
        if self.time == nil {
            self.time = currentTime
            self.thinkTimeCounter = self.time?.advancedBy(self.thinkTime)
        }
        
        // If the current game session is running
        if running {
            let timeLabel = childNodeWithName("timeLabel") as! SKLabelNode
            // If the session has started, show the time from start
            if started {
                timeLabel.text = String(format: "%.2f", arguments: [currentTime - self.time!])
            }
            // else show the time until the session will start
            else {
                timeLabel.text = String(format: "%.0f", arguments: [self.thinkTimeCounter! - currentTime])
            }
            
            // When the pre-session screen should disappear
            if (self.thinkTimeCounter! - currentTime) < 0.0 && !started {
                self.started = true
                self.time = currentTime
                setBlocker(true, zPos: 0)
                setLabelText("colorLabel", text: self.targetColor!)
                timeLabel.text = "GO"
            }
        }
        
    }
    
    func checkPress(color: String) -> () {
        let debugLabel = childNodeWithName("debugLabel") as! SKLabelNode
        // If the color of the button pressed is the correct color, stop the game session
        if color == self.targetColor {
            debugLabel.text = "CORRECT!"
            setLabelText("timeLabel", text: "Correct!")
            self.running = false
        }
            
        // else keep it going
        else {
            setLabelText("timeLabel", text: "Correct!")
            debugLabel.text = "FALSE!"
        }
    }
    
    func backToMenu() -> () {
        // TODO: Add "Are You Sure?" dialog
        let transition = SKTransition.pushWithDirection(.Up, duration: 0.75)
        let gameplayScene = MenuScene(fileNamed: "MenuScene")
        self.view?.presentScene(gameplayScene, transition: transition)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        // Get the node that was pressed
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        let debugLabel = childNodeWithName("debugLabel") as! SKLabelNode
        if let name = node.name {
            // Check if it's a button or a label and if it does, check if the press was correct
            switch name {
                case "upRightButton", "upRightLabel":
                    checkPress(self.nodeColors[Buttons.UpRight.rawValue])
                case "upLeftButton", "upLeftLabel":
                    checkPress(self.nodeColors[Buttons.UpRight.rawValue])
                case "downRightButton", "downRightLabel":
                    checkPress(self.nodeColors[Buttons.UpRight.rawValue])
                case "downLeftButton", "downLeftLabel":
                    checkPress(self.nodeColors[Buttons.UpRight.rawValue])
                // case ask to go back
                case "backButton", "backLabel":
                    backToMenu()
                default:
                    debugLabel.text = name
            }
        }
        else {
            debugLabel.text = "NOTHING"
        }
    }
}















