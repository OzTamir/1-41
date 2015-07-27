//
//  GameplayExtension.swift
//  OneFourtyOne
//
//  Created by Oz Tamir on 7/24/15.
//  Copyright (c) 2015 Oz Tamir. All rights reserved.
//

/*
GameplayExtension.swift
-----------------
Everything that should be a part of the GameplayScene class but isn't a part of the game logic is placed here.
This includes:
    - UI changes
    - Utility Functions
    - etc.
*/

import UIKit
import SpriteKit

extension GameplayScene {
    
    // Show a neat animation when the player runs out of time
    func outOfTime() -> () {
        let buttonsArea = childNodeWithName("buttonsArea")
        let timeLabel = childNodeWithName("timeLabel")
        let zPos = timeLabel?.zPosition
        
        let buttonsDisapperAnimation = SKAction.sequence([
            SKAction.fadeOutWithDuration(0.0),
            SKAction.runBlock() { buttonsArea?.zPosition = CGFloat(self.foregroundZPosition) },
            SKAction.fadeInWithDuration(0.3)
            ])
        
        let labelToMiddleAndBackAnimation = SKAction.sequence([
            SKAction.moveToY(384, duration: 0.2),
            SKAction.scaleTo(1.25, duration: 0.2),
            SKAction.waitForDuration(0.3),
            SKAction.scaleTo(1.0, duration: 0.2),
            SKAction.moveToY(708, duration: 0.3),
            SKAction.runBlock() {
                self.decreaseHeart()
            },
            SKAction.waitForDuration(0.25)
            ])
        
        buttonsArea?.runAction(buttonsDisapperAnimation, completion: {
            timeLabel?.zPosition = CGFloat(self.foregroundZPosition)
            timeLabel?.runAction(labelToMiddleAndBackAnimation, completion: {
                timeLabel?.zPosition = zPos!
                self.overtime = false
                self.startNewLevel()
            })
        })
    }
    
    // Decrease the lives GUI and change the score when resuming a game
    func resumeGame() -> () {
        var livesToDecrease = self.maxLives - self.lives
        self.lives = self.maxLives
        for _ in 0..<livesToDecrease {
            decreaseHeart(animate: false)
        }
        setLabelText("scoreCounter", text: ScoreManager.formatScore(self.score))
        self.returnedFromPause = false
    }
    
    // Present the "Game Over" screen
    func gameover() -> () {
        let transition = SKTransition.pushWithDirection(.Left, duration: 0.25)
        let gameoverScene = GameoverScene(fileNamed: "GameoverScene")
        gameoverScene.score = self.score
        gameoverScene.mode = self.gameMode
        gameoverScene.scaleMode = AppDelegate.sceneScaleMode
        self.view?.presentScene(gameoverScene, transition: transition)
    }
    
    // Change a full heart to an empty heart
    func decreaseHeart(animate: Bool = true) -> () {
        let heart = childNodeWithName("heart\(self.lives)")
        let shrinkAnimation = SKAction.scaleTo(0.5, duration: 0.25)
        let changeTexture = SKAction.setTexture(SKTexture(imageNamed: "heart_icon_empty_80px"), resize: false)
        let revertAnimation = SKAction.scaleTo(1.0, duration: 0.25)
        let animationSequence = SKAction.sequence([
            shrinkAnimation,
            changeTexture,
            revertAnimation
        ])
        if animate {
            heart?.runAction(animationSequence)
        } else {
            heart?.runAction(changeTexture)
        }
        
        if self.lives == 1 {
            gameover()
        }
        self.lives -= 1
        
    }
    
    // Setup a new game session
    func initDialog() -> () {
        // Choose the color for this game
        let arrayKey = Int(arc4random_uniform(UInt32(self.colors.count)))
        self.targetColor = colors[arrayKey]
        
        setLabelText("instructionLabel", text: "Press the button that says")
        setLabelText("colorLabel", text: self.targetColor!)
    }
    
    // Get a random color
    func getRandomColor() -> UIColor{
        var randomRed:CGFloat = CGFloat(drand48())
        var randomGreen:CGFloat = CGFloat(drand48())
        var randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    // Set the text of an SKLabel
    func setLabelText(labelName: String, text: String) -> () {
        let label = childNodeWithName(labelName) as! SKLabelNode
        label.text = text
    }
    
    // Get an array with names of colors
    func getColors() -> ([String]) {
        var localColors = ["Green", "Red", "Blue", "Yellow", "White", "Black", "Purple", "Pink", "Brown", "Orange"]
        var items = [String]()
        var targetInArray = false
        for _ in 0..<4 {
            
            // random key from array
            let arrayKey = Int(arc4random_uniform(UInt32(localColors.count)))
            
            if self.targetColor! == localColors[arrayKey] {
                targetInArray = true
            }
            // your random number
            items.append(localColors[arrayKey])
            
            // make sure the number isnt repeated
            localColors.removeAtIndex(arrayKey)
        }
        if !targetInArray {
            items[Int(arc4random_uniform(UInt32(items.count)))] = self.targetColor!
        }
        return items
    }
    
    // Initialize the buttons, the labels and the colors
    func initButtons() -> () {
        self.nodeColors = []
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
    
    // Show/Hide the "Press the button..." dialog
    func setBlocker(hidden: Bool, zPos: Int) -> () {
        let buttonsArea = childNodeWithName("buttonsArea")
        
        // Hide the blockers and send 'em to the back
        buttonsArea?.zPosition = CGFloat(zPos - 1)
    }
    
    func pauseGame() -> () {
        let transition = SKTransition.pushWithDirection(.Up, duration: AppDelegate.animationDuration)
        let pauseScene = PauseScene(fileNamed: "PauseScene")
        pauseScene.currentGameMode = self.gameMode
        pauseScene.currentLives = self.lives
        pauseScene.currentScore = self.score
        pauseScene.scaleMode = AppDelegate.sceneScaleMode
        self.view?.presentScene(pauseScene, transition: transition)
    }
    
    // Animate a change in the score
    func updateScore() -> () {
        let animationScale = 2.0
        let scoreAnimation = SKAction.scaleTo(CGFloat(animationScale), duration: 0.25)
        let newScore = ScoreManager.calculateScoreForGameMode(
            self.gameMode,
            currentScore: self.score,
            currentTime: self.currentTime,
            startTime: self.time
        )
        if newScore == self.score {
            return
        }
        self.score = newScore
        let changeText = SKAction.runBlock() { self.setLabelText("scoreCounter", text: ScoreManager.formatScore(newScore)) }
        let revertAnimation = SKAction.scaleTo(CGFloat(1), duration: 0.25)
        let completeAction = SKAction.sequence([scoreAnimation, changeText, revertAnimation])
        
        childNodeWithName("scoreCounter")?.runAction(completeAction)
    }
}