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
        
    }
    
    func resetHighscores() -> () {
        // TODO: Display an "Are you sure?" Screen
        let resetLabel = childNodeWithName("resetScoresLabel") as! SKLabelNode
        ScoreManager.resetHighscores()
        let animationSequence = SKAction.sequence([
            SKAction.runBlock() {
                resetLabel.text = "Done!"
            },
            SKAction.waitForDuration(2.0),
            SKAction.runBlock() { resetLabel.text = "Reset Scores" }
        ])
        resetLabel.runAction(animationSequence)
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
            case "resetScoresButton", "resetScoresLabel":
                resetHighscores()
            default:
                break
            }
        }
    }
            
    // Called when the back button is pressed
    func backToMenu() -> () {
        // TODO: Add "Are You Sure?" dialog
        let transition = SKTransition.pushWithDirection(.Down, duration: AppDelegate.animationDuration)
        let gameplayScene = MenuScene(fileNamed: "MenuScene")
        self.view?.presentScene(gameplayScene, transition: transition)
    }
}
