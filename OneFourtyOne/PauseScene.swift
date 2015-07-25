//
//  PauseScene.swift
//  OneFourtyOne
//
//  Created by Oz Tamir on 7/25/15.
//  Copyright (c) 2015 Oz Tamir. All rights reserved.
//

import UIKit
import SpriteKit

class PauseScene: SKScene {
    var currentLives : Int?
    var currentScore : Double?
    var currentGameMode : GameModes?
 
    func resumeGame() -> () {
        let transition = SKTransition.pushWithDirection(.Down, duration: AppDelegate.animationDuration)
        let gameplayScene = GameplayScene(fileNamed: "GameplayScene")
        gameplayScene.lives = self.currentLives!
        gameplayScene.score = self.currentScore!
        gameplayScene.gameMode = self.currentGameMode
        gameplayScene.returnedFromPause = true
        self.view?.presentScene(gameplayScene, transition: transition)
    }
    
    // Called when the back button is pressed
    func backToMenu() -> () {
        // TODO: Add "Are You Sure?" dialog
        let transition = SKTransition.pushWithDirection(.Up, duration: AppDelegate.animationDuration)
        let gameplayScene = MenuScene(fileNamed: "MenuScene")
        self.view?.presentScene(gameplayScene, transition: transition)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        // Get the node that was pressed
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        if let name = node.name {
            // Check if it's a button or a label and if it does, check if the press was correct
            switch name {
            case "resumeButton", "resumeLabel":
                resumeGame()
            case "quitButton", "quitLabel":
                backToMenu()
            default:
                break
            }
        }
    }
}
