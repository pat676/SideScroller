//
//  Amunition.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 25.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

class Amunition: PhysicsNode{
    
    var AOERange = CGPoint.zero //Zero indicates noe AOE
    
    func getWorldDamage() -> CGFloat{
        return 0;
    }
    
    override func hitSolidRoof(at position: CGPoint){
        super.hitSolidRoof(at: position)
        guard let gameScene = scene as? GameScene else {return}
        gameScene.damageTile(at: position, from: self)
    }
    override func hitSolidLeft(at position: CGPoint) {
        super.hitSolidLeft(at: position)
        guard let gameScene = scene as? GameScene else {return}
        gameScene.damageTile(at: position, from: self)
    }
    override func hitSolidGround(at position: CGPoint) {
        super.hitSolidGround(at: position)
        guard let gameScene = scene as? GameScene else {return}
        gameScene.damageTile(at: position, from: self)
    }
    override func hitSolidRight(at position: CGPoint) {
        super.hitSolidRight(at: position)
        guard let gameScene = scene as? GameScene else {return}
        gameScene.damageTile(at: position, from: self)
    }
}
