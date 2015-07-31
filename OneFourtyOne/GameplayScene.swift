
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
    /* -- Color managment properties -- */
    let colors = ["Green", "Red", "Blue", "Yellow", "White", "Black", "Purple", "Pink", "Brown", "Orange"]
    var labelOutlines = [String: [SKLabelNode]]()
    var nodeColors = [String]()
    var targetColor : String?
    
    /* -- Timer Properties -- */
    var time : NSTimeInterval?
    var currentTime : NSTimeInterval?
    var timeDelta : Double? {
        get {
            if let current = self.currentTime {
                if let start = self.time {
                    return current - start
                }
            }
            return nil
        }
    }
    // Whether the actual game has started
    var started = false
    // Time before the buttons are revealed
    let thinkTime = 1.41
    var thinkTimeCounter : NSTimeInterval?
    // Whether we are animating the label and should ignore touches
    var decreaseHeartLabelAnimationInProgress = false
    var countdown = false
    
    /* -- Game settings properties -- */
    let goalTime = 1.41
    var score = 0.0
    let maxLives = 3
    var lives = 3
    var returnedFromPause = false
    var gameMode : GameModes?
    let foregroundZPosition = 4
    
    override func didMoveToView(view: SKView) {
        if self.returnedFromPause {
            self.resumeGame()
        }
        
        if !countdown {
            self.countdown = true
            self.preGameCountdown()
        }
        
        /* Setup your scene here */
        self.setLabelText("colorLabel", text: "")
        
        self.setBlocker(false, zPos: 4)
    }
    
    override func update(currentTime: NSTimeInterval) {
        if decreaseHeartLabelAnimationInProgress || countdown {
            return
        }
        
        // Set the object's currentTime property
        self.currentTime = currentTime
        // On the first updtae call, set the time variables
        if self.time == nil{
            self.time = currentTime
            self.thinkTimeCounter = self.time?.advancedBy(self.thinkTime)
        }
        
        let timeLabel = childNodeWithName("timeLabel") as! SKLabelNode
        // If the session has started, show the time from start
        if started {
            let timeRemaining = self.goalTime - (currentTime - self.time!)
            if timeRemaining < 0.0 {
                timeLabel.text = "Too Late!"
                if self.gameMode == .Countdown {
                    self.decreaseHeartLabelAnimationInProgress = true
                    decreaseHeartLabelAnimation()
                    return
                }
            } else {
                timeLabel.text = String(format: "%.2f", arguments: [timeRemaining])
            }
        } else {
            // else show the time until the session will start
            timeLabel.text = String(format: "%.2f", arguments: [self.thinkTimeCounter! - currentTime])
        }
        
        // When the pre-session screen should disappear
        if (self.thinkTimeCounter! - currentTime) < 0.0 && !started && !self.decreaseHeartLabelAnimationInProgress{
            self.started = true
            self.time = currentTime
            setBlocker(true, zPos: 0)
            timeLabel.text = "GO"
        }
        
    }
    
    func startNewLevel() -> () {
        // Start a new level
        self.time = nil
        self.thinkTimeCounter = nil
        self.started = false
        initDialog()
        setBlocker(false, zPos: self.foregroundZPosition)
        initButtons()
    }
    
    func checkPress(color: String) -> () {
        // Ignore presses if the player is out of time
        if self.decreaseHeartLabelAnimationInProgress || self.countdown {
            return
        }
        
        let debugLabel = childNodeWithName("debugLabel") as! SKLabelNode
        
        // Change the score and the label accordinaly
        if self.timeDelta! > ScoreManager.goalTime  && self.gameMode! == .Countdown{
            setLabelText("timeLabel", text: "Too late!")
            decreaseHeart()
            debugLabel.text = "Time: \(self.timeDelta)"
        }
        else if color == self.targetColor {
            debugLabel.text = "CORRECT!"
            setLabelText("timeLabel", text: "Correct!")
            updateScore()
        } else {
            setLabelText("timeLabel", text: "Wrong!")
            self.decreaseHeartLabelAnimationInProgress = true
            decreaseHeartLabelAnimation()
            debugLabel.text = "FALSE!"
        }
        if !self.decreaseHeartLabelAnimationInProgress {
            startNewLevel()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Get the node that was pressed
        let touch = touches.first!
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
                case "pauseButton", "pauseLabel":
                    pauseGame()
                default:
                    break
            }
        } else {
            debugLabel.text = "NOTHING"
        }
    }
}















