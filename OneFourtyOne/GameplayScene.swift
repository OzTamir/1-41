
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
    let colors = ["Green", "Red", "Blue", "Yellow", "White", "Black", "Purple", "Pink", "Brown", "Orange"]
    var nodeColors = [String]()
    var targetColor : String?
    var time : NSTimeInterval?
    var level = 1
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
    
    override func update(currentTime: NSTimeInterval) {
        // On the first updtae call, set the time variables
        if self.time == nil{
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
                timeLabel.text = "GO"
            }
        }
        
    }
    
    func checkPress(color: String) -> () {
        let debugLabel = childNodeWithName("debugLabel") as! SKLabelNode
        // Change the score and the label accordinaly
        if color == self.targetColor {
            debugLabel.text = "CORRECT!"
            setLabelText("timeLabel", text: "Correct!")
            changeScore(5.0, scoreAnimation: 2.0)
            self.level++
            setLabelText("levelCounter", text: "\(self.level)")
        }
        else {
            setLabelText("timeLabel", text: "False!")
            changeScore(-5.0, scoreAnimation: 0.5)
            debugLabel.text = "FALSE!"
        }
        
        // Start a new level
        self.time = nil
        self.thinkTimeCounter = nil
        self.started = false
        initDialog()
        setBlocker(false, zPos: 4)
        initButtons()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        // Get the node that was pressed
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        let debugLabel = childNodeWithName("debugLabel") as! SKLabelNode
        if let name = node.name {
            debugLabel.text = name
            // Check if it's a button or a label and if it does, check if the press was correct
            switch name {
                case "upRightButton", "upRightLabel":
                    checkPress(self.nodeColors[0])
                case "upLeftButton", "upLeftLabel":
                    checkPress(self.nodeColors[1])
                case "downRightButton", "downRightLabel":
                    checkPress(self.nodeColors[2])
                case "downLeftButton", "downLeftLabel":
                    checkPress(self.nodeColors[3])
                // case ask to go back
                case "backButton", "backLabel":
                    backToMenu()
                default:
                    break
            }
        }
        else {
            debugLabel.text = "NOTHING"
        }
    }
}















