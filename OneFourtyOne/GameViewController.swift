//
//  GameViewController.swift
//  OneFourtyOne
//
//  Created by Oz Tamir on 7/24/15.
//  Copyright (c) 2015 Oz Tamir. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! MenuScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pauseGame", name: "PauseGameScene", object: nil)
        if let scene = MenuScene.unarchiveFromFile("MenuScene") as? MenuScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false//true
            skView.showsNodeCount = false//true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = AppDelegate.sceneScaleMode
            
            skView.presentScene(scene)
        }
    }

    @objc func pauseGame() -> () {
        let skView = self.view as! SKView
        if let gameplayScene = skView.scene as? GameplayScene {
            let transition = SKTransition.pushWithDirection(.Up, duration: 0.0)
            let pauseScene = PauseScene(fileNamed: "PauseScene")
            //pauseScene.currentGameMode = gameplayScene.gameMode
            pauseScene.currentLives = gameplayScene.lives
            pauseScene.currentScore = gameplayScene.score
            pauseScene.scaleMode = AppDelegate.sceneScaleMode
            gameplayScene.view?.presentScene(pauseScene, transition: transition)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        // TODO: NOTE WE HAVE A FALSE AND HERE
        if false && UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
