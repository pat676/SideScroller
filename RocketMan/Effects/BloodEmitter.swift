//
//  BloodEmitter.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 01.04.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

class BloodEmitter{
    
    //MARK: - Reusable Nodes
    
    private static var _reusableNodes = ReusableNodes<SKEmitterNode>(label: "BloodEmitterNodeQueue")
    
    static func resetReusableNodes(){
        _reusableNodes.reset()
    }
    
    static func dequeReusableNode() -> SKEmitterNode?{
        var node: SKEmitterNode? = _reusableNodes.deque()
        if(node == nil || node!.parent != nil){
            node = SKEmitterNode(fileNamed: "Blood.sks")
        }
        node?.resetSimulation()
        node?.isPaused = false
        return node
    }
    
    static func queueReusableNode(_ node: SKEmitterNode){
        node.removeAllActions()
        _reusableNodes.queue(node)
    }
    
    static func preloadReusableNodes(amount: Int){
        for _ in 0..<amount{
            if let node = SKEmitterNode(fileNamed: "Blood.sks"){
                node.isPaused = true
                node.resetSimulation()
                queueReusableNode(node)
            }
        }
    }
    
    static func removeNode(node: SKEmitterNode){
        BloodEmitter.queueReusableNode(node)
        node.removeFromParent()
    }
}
