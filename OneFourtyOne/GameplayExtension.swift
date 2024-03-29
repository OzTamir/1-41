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
    
    // Show a countdown before the actual game starts
    func preGameCountdown() -> () {
        let timeLabel = childNodeWithName("timeLabel") as! SKLabelNode
        let zPos = timeLabel.zPosition
        timeLabel.zPosition = CGFloat(self.foregroundZPosition) + 1
        
        let colorLabel = childNodeWithName("colorLabel") as! SKLabelNode
        let originalColor = colorLabel.text
        colorLabel.text = "???"
        
        let countdownSequence = SKAction.sequence([
            SKAction.runBlock() {
                timeLabel.text = ""
            },
            SKAction.moveToY(384, duration: 0.0),
            SKAction.runBlock() {
                timeLabel.text = "3"
            },
            SKAction.waitForDuration(1.0),
            SKAction.runBlock() {
                timeLabel.text = "2"
            },
            SKAction.waitForDuration(1.0),
            SKAction.runBlock() {
                timeLabel.text = "1"
            },
            SKAction.waitForDuration(1.0),
            SKAction.runBlock() {
                timeLabel.text = "GO!"
            },
            SKAction.waitForDuration(0.5),
            SKAction.moveToY(708, duration: 0.3)
        ])
        
        timeLabel.runAction(countdownSequence, completion: {
            timeLabel.zPosition = zPos
            colorLabel.text = originalColor
            self.countdown = false
            self.initDialog()
            self.initButtons()
        })
    }
    
    // Show a neat animation when the player runs out of time
    func decreaseHeartLabelAnimation() -> () {
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
            SKAction.scaleTo(1.15, duration: 0.2),
            SKAction.waitForDuration(0.3),
            SKAction.scaleTo(1.0, duration: 0.2),
            SKAction.moveToY(708, duration: 0.3),
            SKAction.runBlock() {
                self.decreaseHeart()
            },
            SKAction.waitForDuration(0.25)
            ])
        
        buttonsArea?.runAction(buttonsDisapperAnimation, completion: {
            timeLabel?.zPosition = CGFloat(self.foregroundZPosition) + 1
            timeLabel?.runAction(labelToMiddleAndBackAnimation, completion: {
                timeLabel?.zPosition = zPos!
                self.decreaseHeartLabelAnimationInProgress = false
                self.startNewLevel()
            })
        })
    }
    
    // Decrease the lives GUI and change the score when resuming a game
    func resumeGame() -> () {
        let livesToDecrease = self.maxLives - self.lives
        self.lives = self.maxLives
        for _ in 0..<livesToDecrease {
            decreaseHeart(animate: false)
        }
        setLabelText("scoreCounter", text: GameManager.formatScore(self.score))
        self.returnedFromPause = false
    }
    
    // Present the "Game Over" screen
    func gameover() -> () {
        let transition = SKTransition.pushWithDirection(.Left, duration: 0.25)
        let gameoverScene = GameoverScene(fileNamed: "GameoverScene")
        gameoverScene.score = self.score
        //gameoverScene.mode = self.gameMode
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
        var arrayKey = Int(arc4random_uniform(UInt32(self.colors.count)))
        self.targetColor = colors[arrayKey]
        var targetLabelText : String?
        
        switch GameManager.gameMode! {
            case .Easy:
                targetLabelText = self.targetColor!
            case .Hard:
                arrayKey = Int(arc4random_uniform(UInt32(self.colors.count)))
                targetLabelText = colors[arrayKey]
            case .Countdown:
                /*
                TODO: Decide on what happens in this mode!
                //targetLabelText = self.targetColor!
                For testing purposes:
                */
                arrayKey = Int(arc4random_uniform(UInt32(self.colors.count)))
                targetLabelText = colors[arrayKey]
        }
        
        setLabelText("instructionLabel", text: GameManager.getInstructionText())
        setLabelText("colorLabel", text: targetLabelText!, withColor: ColorManager.colorForName[self.targetColor!])
    }
    
    // Set the text of an SKLabel
    func setLabelText(labelName: String, text: String, withColor: UIColor? = nil) -> () {
        let label = childNodeWithName(labelName) as! SKLabelNode
        label.text = text
        if let fontColor = withColor {
            let borderSize = 1.0
            label.fontColor = fontColor
            if let outlineArray = self.labelOutlines[labelName] {
                for (idx, _) in enumerate(outlineArray) {
                    setLabelText("\(labelName)\(idx)", text: text)
                }
            } else {
                // Add outline labels around the label and add 'em to the dictionary to avoid readding them later
                self.labelOutlines[labelName] = [SKLabelNode]()
                addOutline(label, offsetX: borderSize, offsetY: borderSize, labelName: labelName, idx: 0)
                addOutline(label, offsetX: -borderSize, offsetY: -borderSize, labelName: labelName, idx: 1)
                addOutline(label, offsetX: borderSize, offsetY: -borderSize, labelName: labelName, idx: 2)
                addOutline(label, offsetX: -borderSize, offsetY: borderSize, labelName: labelName, idx: 3)
            }
        }
    }
    
    func addOutline(label : SKLabelNode, offsetX : Double, offsetY : Double, labelName : String, idx : Int) -> () {
        let newLabel = SKLabelNode(text: label.text)
        newLabel.name = "\(labelName)\(idx)"
        newLabel.fontSize = label.fontSize
        newLabel.fontName = label.fontName
        newLabel.horizontalAlignmentMode = .Center
        newLabel.verticalAlignmentMode = .Center
        newLabel.position =
            CGPoint(x: CGRectGetMidX(label.frame) + CGFloat(offsetX), y: CGRectGetMidY(label.frame) + CGFloat(offsetY))
        newLabel.zPosition = label.zPosition - 1
        self.addChild(newLabel)
        
        // Add it to the outlines dictionary
        self.labelOutlines[labelName]?.append(newLabel)
    }
    
    // Initialize the buttons, the labels and the colors
    func initButtons() -> () {
        self.nodeColors = []
        var items = ColorManager.getColorNames(4, withColorName: self.targetColor!)
        
        // Init the up-right button/label
        let upRightButton = childNodeWithName("upRightButton")
        upRightButton?.runAction(SKAction.colorizeWithColor(ColorManager.getRandomColor(), colorBlendFactor: 1.0, duration: 0.0))
        setLabelText("upRightLabel", text: items[0], withColor: ColorManager.getRandomColor(offset: 0.9))
        self.nodeColors.append(items[0])
        
        // Init the up-left button/label
        let upLeftButton = childNodeWithName("upLeftButton")
        upLeftButton?.runAction(SKAction.colorizeWithColor(ColorManager.getRandomColor(), colorBlendFactor: 1.0, duration: 0.0))
        setLabelText("upLeftLabel", text: items[1], withColor: ColorManager.getRandomColor(offset: 0.9))
        self.nodeColors.append(items[1])
        
        // Init the down-right button/label
        let downRightButton = childNodeWithName("downRightButton")
        downRightButton?.runAction(SKAction.colorizeWithColor(ColorManager.getRandomColor(), colorBlendFactor: 1.0, duration: 0.0))
        setLabelText("downRightLabel", text: items[2], withColor: ColorManager.getRandomColor(offset: 0.9))
        self.nodeColors.append(items[2])
        
        // Init the down-left button/label
        let downLeftButton = childNodeWithName("downLeftButton")
        downLeftButton?.runAction(SKAction.colorizeWithColor(ColorManager.getRandomColor(), colorBlendFactor: 1.0, duration: 0.0))
        setLabelText("downLeftLabel", text: items[3], withColor: ColorManager.getRandomColor(offset: 0.6))
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
        //pauseScene.currentGameMode = self.gameMode
        pauseScene.currentLives = self.lives
        pauseScene.currentScore = self.score
        pauseScene.scaleMode = AppDelegate.sceneScaleMode
        self.view?.presentScene(pauseScene, transition: transition)
    }
    
    // Animate a change in the score
    func updateScore() -> () {
        let animationScale = 2.0
        let scoreAnimation = SKAction.scaleTo(CGFloat(animationScale), duration: 0.25)
        let newScore = GameManager.calculateScore(
            self.score,
            currentTime: self.currentTime,
            startTime: self.time
        )
        if newScore == self.score {
            return
        }
        self.score = newScore
        let changeText = SKAction.runBlock() { self.setLabelText("scoreCounter", text: GameManager.formatScore(newScore)) }
        let revertAnimation = SKAction.scaleTo(CGFloat(1), duration: 0.25)
        let completeAction = SKAction.sequence([scoreAnimation, changeText, revertAnimation])
        
        childNodeWithName("scoreCounter")?.runAction(completeAction)
    }
}