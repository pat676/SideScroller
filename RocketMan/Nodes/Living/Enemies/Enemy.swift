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
    
    var getVelocity = velocityAI.noVelocity //AI function for calculating velocity
    var viewDistance:CGFloat = 0 //Maximum distance the Zombie can detect the player
    var hasCloseAttack = false
    var didHitPlayerLastFrame = false
    
    var damage:CGFloat = 1
    var pushback:CGFloat = 0
    
    //MARK: - Update
    
    func update(worldTiles: SKTileMapNode, player: PlayerNode){
        guard currentAction != .Dying else {return}
        runAI(worldTiles: worldTiles, player: player)
        updateAction()
        didHitPlayerLastFrame = false
    }
    
    func runAI(worldTiles: SKTileMapNode, player: PlayerNode){
        velocity = getVelocity(self, player, worldTiles)
    }
    
    func updateAction(){
        if(isDead){
            currentAction = .Dying
        }
        else if(didHitPlayerLastFrame && hasCloseAttack){
            currentAction = .CloseAttack
        }
        else if(velocity == CGPoint.zero){
            currentAction = .Idle
        }
        else{
            currentAction = .Moving
        }
    }
    
    //MARK: - PhysicsNode interactions
    
    override func collided(with node: PhysicsNode){
        guard !isDead else {return}
        if let player = node as? PlayerNode{
            guard !player.isDead else {return}
            let forceDirection = (player.position - self.position).normalized()
            player.applyDamage(damage, pushback: pushback, forceDirection: forceDirection)
        }
    }
    
    func directHit(by ammo: Amunition){
        let damage = ammo.damage
        let pushback = ammo.damagePushback
        let direction = (self.position - ammo.position).normalized()
        applyDamage(damage, pushback: pushback, direction: direction)
    }
    
    func AOEHit(by ammo: Amunition){
        let damage = ammo.AOEDamage
        let pushback = ammo.AOEDamagePushback
        let direction = (self.position - ammo.position).normalized()
        applyDamage(damage, pushback: pushback, direction: direction)
    }
    
    //MARK: - Apply Damage and Killed
    
    private func applyDamage(_ damage: CGFloat, pushback: CGFloat, direction: CGPoint){
        guard health > 0 else {return}
        health -= damage
        if(health <= 0){
            killed(with: pushback, forceDirection: direction)
        }
    }
}
