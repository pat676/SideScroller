//
//  Emitters.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 25.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit


func newExplosionFire() -> SKEmitterNode?{
    guard let explosionFire = SKEmitterNode(fileNamed: "ExplosionFire.sks") else {return nil}
    let waitAction = SKAction.wait(forDuration: 0.2)
    let alphaAction = SKAction.fadeAlpha(to: 0, duration: 0.4)
    let removeAction = SKAction.removeFromParent()
    let sequenceAction = SKAction.sequence([waitAction,alphaAction,removeAction])
    explosionFire.run(sequenceAction)
    return explosionFire
}

func newExplosionSmoke() -> SKEmitterNode?{
    guard let explosionSmoke = SKEmitterNode(fileNamed: "ExplosionSmoke.sks") else {return nil}
    let waitAction = SKAction.wait(forDuration: 0.4)
    let alphaAction = SKAction.fadeAlpha(to: 0, duration: 1)
    let removeAction = SKAction.removeFromParent()
    let sequenceAction = SKAction.sequence([waitAction,alphaAction,removeAction])
    explosionSmoke.run(sequenceAction)
    return explosionSmoke
}

func newDustBrown() -> SKEmitterNode?{
    guard let dustBrown = SKEmitterNode(fileNamed: "DustBrown.sks") else {return nil}
    let alphaAction = SKAction.fadeAlpha(to: 0, duration: 1)
    let removeAction = SKAction.removeFromParent()
    let sequenceAction = SKAction.sequence([alphaAction,removeAction])
    dustBrown.run(sequenceAction)
    return dustBrown
}

func newBloodEmitter() -> SKEmitterNode?{
    guard let blood = SKEmitterNode(fileNamed: "Blood.sks") else {return nil}
    return blood
}

