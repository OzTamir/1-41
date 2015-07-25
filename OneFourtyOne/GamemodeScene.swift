//
//  GamemodeScene.swift
//  OneFourtyOne
//
//  Created by Oz Tamir on 7/25/15.
//  Copyright (c) 2015 Oz Tamir. All rights reserved.
//

import UIKit
import SpriteKit

enum GameModes {
    case Speed
    case Arcade
    case Countdown
}

class GamemodeScene: SKScene {
    override func didMoveToView(view: SKView) {
        let arcadeHSLabel = childNodeWithName("arcadeHighScoreLabel") as! SKLabelNode
        arcadeHSLabel.text = "\(ScoreManager.getHighscoreForGameMode(.Arcade))"
        
        let speedHSLabel = childNodeWithName("speedHighScoreLabel") as! SKLabelNode
        speedHSLabel.text = "\(ScoreManager.getHighscoreForGameMode(.Speed))"
        
        let countdownHSLabel = childNodeWithName("speedHighScoreLabel") as! SKLabelNode
        countdownHSLabel.text = "\(ScoreManager.getHighscoreForGameMode(.Countdown))"
    }
    
    func startGame(mode: GameModes) -> () {
        let transition = SKTransition.pushWithDirection(.Right, duration: 0.75)
        let gameplayScene = GameplayScene(fileNamed: "GameplayScene")
        gameplayScene.gameMode = mode
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
                default:
                    break
            }
            
        }
    }
}
