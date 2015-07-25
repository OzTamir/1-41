//
//  GamemodeScene.swift
//  OneFourtyOne
//
//  Created by Oz Tamir on 7/25/15.
//  Copyright (c) 2015 Oz Tamir. All rights reserved.
//

import UIKit
import SpriteKit

enum GameModes : String {
    case Speed = "speed"
    case Arcade = "arcade"
    case Countdown = "countdown"
}

class GamemodeScene: SKScene {
    override func didMoveToView(view: SKView) {
        let arcadeHSLabel = childNodeWithName("arcadeHighScoreLabel") as! SKLabelNode
        arcadeHSLabel.text = ScoreManager.formatScore(ScoreManager.getHighscoreForGameMode(.Arcade))
        
        let speedHSLabel = childNodeWithName("speedHighScoreLabel") as! SKLabelNode
        speedHSLabel.text = ScoreManager.formatScore(ScoreManager.getHighscoreForGameMode(.Speed))
        if speedHSLabel.text == ScoreManager.formatScore(1.42) {
            speedHSLabel.text = ScoreManager.formatScore(0.0)
        }
        
        let countdownHSLabel = childNodeWithName("countdownHighScoreLabel") as! SKLabelNode
        countdownHSLabel.text = ScoreManager.formatScore(ScoreManager.getHighscoreForGameMode(.Countdown))
    }
    
    func startGame(mode: GameModes) -> () {
        let transition = SKTransition.pushWithDirection(.Down, duration: 0.75)
        let gameplayScene = GameplayScene(fileNamed: "GameplayScene")
        gameplayScene.gameMode = mode
        self.view?.presentScene(gameplayScene, transition: transition)
    }
    
    // Called when the back button is pressed
    func backToMenu() -> () {
        let transition = SKTransition.pushWithDirection(.Right, duration: 0.75)
        let gameplayScene = MenuScene(fileNamed: "MenuScene")
        self.view?.presentScene(gameplayScene, transition: transition)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        if let name = node.name {
            switch name {
                case "speedModeButton", "speedModeLabel":
                    startGame(.Speed)
                case "arcadeModeButton", "arcadeModeLabel":
                    startGame(.Arcade)
                case "countdownModeButton", "countdownModeLabel":
                    startGame(.Countdown)
                case "backButton", "backLabel":
                    backToMenu()
                default:
                    break
            }
            
        }
    }
}
