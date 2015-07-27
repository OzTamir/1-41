//
//  SKUtils.swift
//  OneFourtyOne
//
//  Created by Oz Tamir on 7/27/15.
//  Copyright (c) 2015 Oz Tamir. All rights reserved.
//

import Foundation
import SpriteKit

class SKUtils {
    
    /**
    It adds the passed node in a relative position in the scene
    
    This method accepts a scene, node and a pair of doubles and add the node in the relative position on the scene.
    So, for example, giving xPos and yPos of 0.5 will position the node in the middle of the scene.
    
    :param: scene The scene in which we are operating
    :param: node The node we want to add the the scene
    :param: xPos The realtive x-axis position of the node in the scene (0.0 being leftmost and 1.0 being rightmost)
    :param: yPos The realtive y-axis position of the node in the scene (0.0 being bottom and 1.0 being top)
    
    */
    class func moveToRelativePosition(scene: SKScene, node: SKNode, xPos: Double, yPos: Double) -> () {
        
        let xSize = Double(CGRectGetMaxX(scene.frame))
        let ySize = Double(CGRectGetMaxY(scene.frame))
        let normalizeXPos = xPos//Tools.forceRange(xPos, minValue: 0.0, maxValue: 1.0)
        let normalizeYPos = yPos//Tools.forceRange(yPos, minValue: 0.0, maxValue: 1.0)
        
        let xPosition = abs((xSize * normalizeXPos) - Double(CGRectGetMidX(node.frame)))
        let yPosition = abs((ySize * normalizeYPos) - Double(CGRectGetMidY(node.frame)))
        
        let newPosition = CGPoint(x: xPosition, y: yPosition)
        
        node.runAction(SKAction.moveTo(newPosition, duration: 0.0))
    }
    
    /**
    It adds a node in a position relative to another node
    
    This method accepts a scene, two nodes and a pair of doubles and add the new node in the given offset to the other node.
    For example, passing xOffset of 0.0 and yOffset of -0.1 will put the new node at the same X but 10% lower.
    
    :param: scene The scene in which we are operating
    :param: newNode The node we want to add the the scene
    :param: originalNode The node we want to position relative to
    :param: xOffset The offset of the new node (from the original) on the X-axis
    :param: yOffset The offset of the new node (from the original) on the Y-axis
    
    */
    class func addNodeRelativeToNode(scene: SKScene, newNode: SKNode, originalNode: SKNode, xOffset: Double, yOffset: Double) {
        let xBase = Double(CGRectGetMidX(originalNode.frame))
        let yBase = Double(CGRectGetMidY(originalNode.frame))
        let relativeXOffset = xOffset * Double(CGRectGetMaxX(scene.frame))
        let relativeYOffset = yOffset * Double(CGRectGetMaxY(scene.frame))
        
        let xPosition = abs(max(0, xBase + relativeXOffset) - Double(CGRectGetMidX(newNode.frame)))
        let yPosition = abs(max(0, yBase + relativeYOffset) - Double(CGRectGetMidY(newNode.frame)))
        
        newNode.position = CGPoint(x: xPosition, y: yPosition)
        scene.addChild(newNode)
        
    }
    
}