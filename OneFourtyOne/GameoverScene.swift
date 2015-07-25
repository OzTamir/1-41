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
        let gamemodeScene = GamemodeScene(fileNamed: "GamemodeScene")!
        gamemodeScene.scaleMode = SKSceneScaleMode.Fill
        self.view?.presentScene(gamemodeScene, transition: transition)
    }
    
    // Called when the back button is pressed
    func backToMenu() -> () {
        let transition = SKTransition.pushWithDirection(.Down, duration: AppDelegate.animationDuration)
        let menuScreen = MenuScene(fileNamed: "MenuScene")!
        menuScreen.scaleMode = SKSceneScaleMode.Fill
        self.view?.presentScene(menuScreen, transition: transition)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Get the node that was pressed
        let touch = touches.first!
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
