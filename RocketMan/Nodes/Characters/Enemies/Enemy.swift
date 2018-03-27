//
//  Enemy.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 27.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit


class Enemy: Living{
    
    //MARK: - Properties
    
    var health: CGFloat = 1;
    var getVelocity = velocityAI.noVelocity //AI function for calculating velocity
    var viewDistance:CGFloat = 0 //Maximum distance the Zombie can detect the player
    var isDead:Bool{
        get{
            return health < 0
        }
    }
    
    //MARK: - Update
    
    func update(worldTiles: SKTileMapNode, player: PlayerNode){
        runAI(worldTiles: worldTiles, player: player)
        updateAction()
    }
    
    func runAI(worldTiles: SKTileMapNode, player: PlayerNode){
        velocity = getVelocity(self, player, worldTiles)
    }
    
    func updateAction(){
        if(velocity == CGPoint.zero){
            currentAction = .Idle
        }
        else{
            currentAction = .Moving
        }
    }
    
    //MARK: - PhysicsNode interactions
    
    func directHit(by ammo: Amunition){
        health -= ammo.damage
        if(health < 0){
            killed(by: ammo)
        }
    }
    
    func AOEHit(by ammo: Amunition){
        health -= ammo.AOEDamage
        if(health < 0){
            killed(by: ammo)
        }
    }
    
    func killed(by ammo: Amunition){
        super.removeFromParent()
    }
}
