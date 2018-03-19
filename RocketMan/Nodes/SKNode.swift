//
//  SKNode.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 14.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

extension SKNode{
    
    func addChildren(_ nodes: [SKNode]){
        for node in nodes{
            addChild(node)
        }
    }
}
