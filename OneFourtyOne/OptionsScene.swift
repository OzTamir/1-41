//
//  OptionsScene.swift
//  OneFourtyOne
//
//  Created by Oz Tamir on 7/25/15.
//  Copyright (c) 2015 Oz Tamir. All rights reserved.
//

import UIKit
import SpriteKit


class OptionsScene: SKScene {
    override func didMoveToView(view: SKView) {
        updateGameModeLabel()
    }
    
    func updateGameModeLabel() -> () {
        let gameModeLabel = childNodeWithName("gameModeLabel") as! SKLabelNode
        gameModeLabel.text = GameManager.gameMode!.rawValue.capitalizedString
    }
    
    func resetHighscores() -> () {
        // TODO: Display an "Are you sure?" Screen
        let resetLabel = childNodeWithName("resetLabel") as! SKLabelNode
        let scoreLabel = childNodeWithName("scoreLabel") as! SKLabelNode
        GameManager.resetHighscores()
        let animationSequence = SKAction.sequence([
            SKAction.runBlock() {
                resetLabel.text = "DONE"
                scoreLabel.text = ""
            },
            SKAction.waitForDuration(2.0),
            SKAction.runBlock() {
                resetLabel.text = "RESET"
                scoreLabel.text = "SCORE"
            }
        ])
        resetLabel.runAction(animationSequence)
    }
    
    func changeGameMode() -> () {
        switch GameManager.gameMode! {
            case .Easy:
                GameManager.setGameMode(.Hard)
            case .Hard:
                GameManager.setGameMode(.Countdown)
            case .Countdown:
                GameManager.setGameMode(.Easy)
        }
        updateGameModeLabel()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        // Get the node that was pressed
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        let node = self.nodeAtPoint(location)

        if let name = node.name {
            // Check if it's a button or a label and if it does, check if the press was correct
            switch name {
            case "backButton", "backLabel":
                backToMenu()
            case "resetScoresButton", "resetLabel", "scoreLabel":
                resetHighscores()
            case "modeLabel", "modeButton", "gameModeLabel":
                changeGameMode()
            default:
                break
            }
        }
    }
            
    // Called when the back button is pressed
    func backToMenu() -> () {
        // TODO: Add "Are You Sure?" dialog
        let transition = SKTransition.pushWithDirection(.Down, duration: AppDelegate.animationDuration)
        let menuScene = MenuScene(fileNamed: "MenuScene")
        menuScene.scaleMode = AppDelegate.sceneScaleMode
        self.view?.presentScene(menuScene, transition: transition)
    }
}
