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
     * Creates a SKAction animation from textureAtlast with timePerFrame between each frame. The can only contain images used in this animation.
     * For atlases with unrealeted textures, use the createAnimtaion(with:animationNmae:timePrFrame) instead.
     * All names used in the animation should start with animationName and end with #.png, where # is the frame number.
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
    
    /*
     * Creates an animation from the given texture atlas.
     * All names used in the animation should start with animationName and end with #.png, where # is the frame number.
     */
    static func createAnimation(from textureAtlas: SKTextureAtlas, animationName: String, timePerFrame: TimeInterval) -> SKAction{
        
        //Count the number of frames belonging to animation name
        var textureCount = 0;
        let name = "\(animationName)_"
        for textureName in textureAtlas.textureNames{
            if textureName.hasPrefix(name){
                textureCount += 1
            }
        }
        if(textureCount == 0){fatalError("Could not load animation: \(animationName)")}
        
        //Create animation
        var animationFrames: [SKTexture] = []
        for i in 1...textureCount{
            let textureName = "\(name)\(i)"
            animationFrames.append(textureAtlas.textureNamed(textureName))
        }
        return SKAction.animate(with: animationFrames, timePerFrame: timePerFrame, resize: false, restore: true)
    }
}
