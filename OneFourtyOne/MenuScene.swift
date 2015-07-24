//
//  GameScene.swift
//  OneFourtyOne
//
//  Created by Oz Tamir on 7/24/15.
//  Copyright (c) 2015 Oz Tamir. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!";
//        myLabel.fontSize = 65;
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
//        
//        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        if node.name == "startButton" || node.name == "startLabel" {
            let transition = SKTransition.pushWithDirection(.Down, duration: 0.75)
            let gameplayScene = GameplayScene(fileNamed: "GameplayScene")
            self.view?.presentScene(gameplayScene, transition: transition)
        }
        
        
//        let welcomeNode = childNodeWithName("welcomeNode")
//        
//        if (welcomeNode != nil) {
//            let fadeAway = SKAction.fadeOutWithDuration(1.0)
//            
//            welcomeNode?.runAction(fadeAway, completion: {
//                let doors = SKTransition.doorwayWithDuration(1.0)
//                let archeryScene = GameplayScene(fileNamed: "GameplayScene")
//                self.view?.presentScene(archeryScene, transition: doors)
//            })
//        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
