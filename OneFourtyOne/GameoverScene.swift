//
//  GameoverScene.swift
//  OneFourtyOne
//
//  Created by Oz Tamir on 7/25/15.
//  Copyright (c) 2015 Oz Tamir. All rights reserved.
//

import UIKit
import SpriteKit

class GameoverScene: SKScene {
    var mode: GameModes?
    var score : Double?
    
    override func didMoveToView(view: SKView) {
        let highScoreLabel = childNodeWithName("highscoreLabel") as! SKLabelNode
        highScoreLabel.hidden = true
        let scoreLabel = childNodeWithName("scoreLabel") as! SKLabelNode
        if let score = self.score {
            scoreLabel.text = ScoreManager.formatScore(score)
        } else {
            scoreLabel.text = "ERROR"
        }
        if let gameMode = self.mode {
            if let score = self.score {
                let modeHighscore = ScoreManager.getHighscoreForGameMode(gameMode)
                switch gameMode {
                    case .Arcade, .Countdown:
                        if score > modeHighscore {
                            ScoreManager.setHighscoreForGameMode(gameMode, newScore: score)
                            highScoreLabel.hidden = false
                        }
                    case .Speed:
                        if score < modeHighscore && score > 0.0 {
                            ScoreManager.setHighscoreForGameMode(gameMode, newScore: score)
                            highScoreLabel.hidden = false
                        }
                }
            }
        }
    }
    
    func newGame() -> () {
        let transition = SKTransition.pushWithDirection(.Right, duration: AppDelegate.animationDuration)
        let gameplayScene = GameplayScene(fileNamed: "GameplayScene")
        gameplayScene.gameMode = .Countdown
        gameplayScene.scaleMode = AppDelegate.sceneScaleMode
        self.view?.presentScene(gameplayScene, transition: transition)
    }
    
    // Called when the back button is pressed
    func backToMenu() -> () {
        let transition = SKTransition.pushWithDirection(.Down, duration: AppDelegate.animationDuration)
        let menuScene = MenuScene(fileNamed: "MenuScene")
        menuScene.scaleMode = AppDelegate.sceneScaleMode
        self.view?.presentScene(menuScene, transition: transition)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        // Get the node that was pressed
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        let debugLabel = childNodeWithName("debugLabel") as! SKLabelNode
        if let name = node.name {
            debugLabel.text = name
            switch name {
                case "newGameButton", "newGameLabel":
                    newGame()
                case "menuButton", "menuLabel":
                    backToMenu()
                default:
                    break
            }
        }
    }
}
