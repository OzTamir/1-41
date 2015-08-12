//
//  GameoverScene.swift
//  OneFourtyOne
//
//  Created by Oz Tamir on 7/25/15.
//  Copyright (c) 2015 Oz Tamir. All rights reserved.
//

import UIKit
import SpriteKit
import Social

class GameoverScene: SKScene {
    var mode: GameModes?
    var score : Double?
    
    override func didMoveToView(view: SKView) {
        let highScoreLabel = childNodeWithName("highscoreLabel") as! SKLabelNode
        highScoreLabel.hidden = true
        
        let scoreLabel = childNodeWithName("scoreLabel") as! SKLabelNode
        if let score = self.score {
            scoreLabel.text = GameManager.formatScore(score)
        } else {
            scoreLabel.text = "ERROR"
        }
        
        if let score = self.score {
            let modeHighscore = GameManager.getHighscore()
            if score > modeHighscore {
                GameManager.setHighscore(score)
                highScoreLabel.hidden = false
            }
        }
    }
    
    func newGame() -> () {
        let transition = SKTransition.pushWithDirection(.Right, duration: AppDelegate.animationDuration)
        let gameplayScene = GameplayScene(fileNamed: "GameplayScene")
        //gameplayScene.gameMode = GameManager.gameMode
        gameplayScene.scaleMode = AppDelegate.sceneScaleMode
        self.view?.presentScene(gameplayScene, transition: transition)
    }
    
    func shareScoreWithService(serviceName: String) -> () {
        let shareSheet = SLComposeViewController(forServiceType: serviceName)
        
        shareSheet.completionHandler = {result in
            switch result as SLComposeViewControllerResult {
                case .Cancelled:
                    break
                case .Done:
                    break
            }
        }
        
        shareSheet.setInitialText("I scored \(self.score!) on 1:41! I challange you to beat my score!")
            
//        //  Adds an image to the Tweet.  Image named image.png
//        if (![tweetSheet addImage:[UIImage imageNamed:@"image.png"]]) {
//            NSLog(@"Error: Unable to add image");
//        }
//        //  Add an URL to the Tweet.  You can add multiple URLs.
//        if (![tweetSheet addURL:[NSURL URLWithString:@"http://twitter.com/"]]){
//            NSLog(@"Error: Unable to URL");
//        }
        
        let controller = self.view?.window?.rootViewController
        controller?.presentViewController(shareSheet, animated: true, completion: nil)
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

        if let name = node.name {
            switch name {
                case "newGameButton", "newGameLabel":
                    newGame()
                case "menuButton", "menuLabel":
                    backToMenu()
                case "tweetScoreButton", "tweetScoreLabel":
                    shareScoreWithService(SLServiceTypeTwitter)
                case "facebbokScoreButton", "facebookScoreLabel":
                    shareScoreWithService(SLServiceTypeFacebook)
                default:
                    break
            }
        }
    }
}
