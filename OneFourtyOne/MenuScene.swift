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
        
        if let name = node.name {
            switch name {
                case "startButton", "startLabel":
                    let transition = SKTransition.pushWithDirection(.Left, duration: AppDelegate.animationDuration)
                    let gamemodeScene = GamemodeScene(fileNamed: "GamemodeScene")
                    gamemodeScene.scaleMode = AppDelegate.sceneScaleMode
                    self.view?.presentScene(gamemodeScene, transition: transition)
                case "optionsButton", "optionsLabel":
                    let transition = SKTransition.pushWithDirection(.Up, duration: AppDelegate.animationDuration)
                    let optionsScene = OptionsScene(fileNamed: "OptionsScene")
                    optionsScene.scaleMode = AppDelegate.sceneScaleMode
                    self.view?.presentScene(optionsScene, transition: transition)
                case "titleLabel":
                    animateTitleOnTouch()
                default:
                    break
            }
        }
        
    }
   
    func animateTitleOnTouch() -> () {
        let title = childNodeWithName("titleLabel")
        let growAnimation = SKAction.scaleTo(1.5, duration: 0.25)
        let shrinkAnimation = SKAction.scaleTo(1.0, duration: 0.25)
        let animationSequence = SKAction.sequence([growAnimation, shrinkAnimation])
        title?.runAction(animationSequence)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
