//
//  Amunition.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 25.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

enum DamageType: Int{
    case Explosion = 0, Piercing
}

class Amunition: PhysicsNode{
    
    //MARK: - Properties

    var damage:CGFloat = 0;
    var damageType:DamageType = .Piercing
    var damagePushback:CGFloat = 0;
    
    var AOERange = CGPoint.zero //Zero indicates noe AOE
    var AOEDamage:CGFloat = 0;
    var AOEDamageType: DamageType = .Explosion
    var AOEDamagePushback: CGFloat = 0;
    
    //MARK: - System
    
    convenience init(imageNamed: String){
        let texture = SKTexture(imageNamed: imageNamed)
        self.init(texture: texture, color: .clear, size: texture.size())
        
        isAffectedByWorldSolids = true
        isAffectedByPhysicNodes = true
        
        anchorPoint = CGPoint.zero
        zPosition = 10
        
        addAnimations()
        updateAnimation()
    }
    
    //MARK: - Animations
    
    func addAnimations(){}
    func updateAnimation(){}
    
    func hitTarget(){
        if(AOERange != CGPoint.zero){
            doAOEDamage()
        }
        guard let gameScene = scene as? GameScene else {return}
        gameScene.damageTile(at: position, from: self)
        self.removeFromParent()
    }
    
    //MARK: - World Interactions
    
    override func hitSolidRoof(at position: CGPoint){
        super.hitSolidRoof(at: position)
        self.position = position
        hitTarget()
    }
    override func hitSolidLeft(at position: CGPoint) {
        super.hitSolidLeft(at: position)
        self.position = position
        hitTarget()
    }
    override func hitSolidGround(at position: CGPoint) {
        super.hitSolidGround(at: position)
        self.position = position
        hitTarget()
    }
    override func hitSolidRight(at position: CGPoint) {
        super.hitSolidRight(at: position)
        self.position = position
        hitTarget()
    }
    
    //MARK: - PhysicsNode Interaction
    
    override func collided(with node: PhysicsNode) {
        guard !(node is PlayerNode) else {return}
        if let enemy = node as? Enemy{
            enemy.directHit(by: self)
        }
        hitTarget()
    }
    
    func doAOEDamage(){
        let damageRect = CGRect(x: physicsFrame.minX, y: physicsFrame.minY, width: AOERange.x*2, height: AOERange.y*2)
        guard let gameScene = scene as? GameScene else {return}
        let hitNodes = gameScene.getPhysicNodesColliding(with: damageRect)
        for node in hitNodes{
            guard let enemy = node as? Enemy else {continue}
            enemy.AOEHit(by: self)
        }
    }
}
