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
    
    override func hitSolidRoof(in world: WorldNodes, at worldPosition: CGPoint){
        super.hitSolidRoof(in: world, at: worldPosition)
        world.damageTile(at: worldPosition, from: self)
    }
    override func hitSolidLeft(in world: WorldNodes, at worldPosition: CGPoint) {
        super.hitSolidLeft(in: world, at: worldPosition)
        world.damageTile(at: worldPosition, from: self)
    }
    override func hitSolidGround(in world: WorldNodes, at worldPosition: CGPoint) {
        super.hitSolidGround(in: world, at: worldPosition)
        world.damageTile(at: worldPosition, from: self)
    }
    override func hitSolidRight(in world: WorldNodes, at worldPosition: CGPoint) {
        super.hitSolidRight(in: world, at: worldPosition)
        world.damageTile(at: worldPosition, from: self)
    }
}
