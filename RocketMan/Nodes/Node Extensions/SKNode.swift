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
    
    //MARK: - Animations
    
    /*
     * Creates a SKAction animation from textureAtlast with timePerFrame between each frame.
     * textureAtlasName should be the same for the atlas and the png, but the pngs should ha numbers appended from 1 to
     * the number of frames.
     */
    static func createAnimation(from textureAtlastName: String, timePerFrame: TimeInterval) -> SKAction{
        let atlas = SKTextureAtlas(named: textureAtlastName)
        guard atlas.textureNames.count != 0 else {fatalError ("could not load atlas \(textureAtlastName)")}
        var animationFrames: [SKTexture] = []
        for i in 1...atlas.textureNames.count{
            let textureName = "\(textureAtlastName)\(i)"
            animationFrames.append(atlas.textureNamed(textureName))
        }
        return SKAction.animate(with: animationFrames, timePerFrame: timePerFrame, resize: false, restore: true)
    }
}
