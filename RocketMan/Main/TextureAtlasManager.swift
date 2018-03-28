//
//  TextureAtlasManager.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 28.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

let textureAtlasManager = TextureAtlasManager()

class TextureAtlasManager{
    
    let level1Atlases: [SKTextureAtlas]
    
    var playerAtlas: SKTextureAtlas = SKTextureAtlas(named: "Player@2x")
    var zombieAtlas: SKTextureAtlas = SKTextureAtlas(named: "Zombie@2x")
    
    init(){
        level1Atlases = [playerAtlas]
    }
}
