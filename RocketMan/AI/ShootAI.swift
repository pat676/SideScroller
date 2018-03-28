//
//  ShootAI.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 27.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

let shootAI = ShootAI()

class ShootAI{

     // A singleton class containing AI functions for getting shoot directions
 
    func noShootDirection(for enemy: Enemy, player: PlayerNode, worldTiles: SKTileMapNode) -> CGPoint {
        return CGPoint.zero
    }
}
