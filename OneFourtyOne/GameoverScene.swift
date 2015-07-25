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
    var score : Double?
    
    override func didMoveToView(view: SKView) {
        let scoreLabel = childNodeWithName("scoreLabel") as! SKLabelNode
        if let score = self.score {
            scoreLabel.text = "\(score)"
        } else {
            scoreLabel.text = "ERROR"
        }
    }
    
    func newGame() -> () {
        let transition = SKTransition.pushWithDirection(.Right, duration: 0.75)
        let gamemodeScene = GamemodeScene(fileNamed: "GamemodeScene")
        self.view?.presentScene(gamemodeScene, transition: transition)
    }
    
    // Called when the back button is pressed
    func backToMenu() -> () {
        let transition = SKTransition.pushWithDirection(.Down, duration: 0.75)
        let menuScreen = MenuScene(fileNamed: "MenuScene")
        self.view?.presentScene(menuScreen, transition: transition)
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
