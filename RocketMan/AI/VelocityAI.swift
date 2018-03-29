//
//  VelocityAI.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 27.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

let velocityAI = VelocityAI()

class VelocityAI{

     // A singleton class containing AI functions for velocity calculations
    
    //Always returns zero velocity
    func noVelocity(for enemy: Enemy, player: PlayerNode, worldTiles: SKTileMapNode) -> CGPoint{
        return CGPoint.zero
    }
    
    //Moves the enemy towards the player in the x direction if inside view distance 
    func simpleVelocity(for enemy: Enemy, player: PlayerNode, worldTiles: SKTileMapNode) -> CGPoint{
        let playerOffsetX = player.position.x - enemy.position.x
        if(player.physicsFrame.intersects(enemy.physicsFrame)){
            enemy.didHitPlayerLastFrame = true
            return CGPoint(x: 0, y: enemy.velocity.y)
        }
        else if(abs(playerOffsetX) < enemy.viewDistance){
            if(playerOffsetX < 0){ return CGPoint(x: -enemy.speed , y:enemy.velocity.y)}
            else if(playerOffsetX > 0) {return CGPoint(x: enemy.speed, y:enemy.velocity.y)}
        }
        return CGPoint(x: 0, y: enemy.velocity.y)
    }
}
