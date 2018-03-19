//
//  Character.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 15.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

class PhysicsNode: SKSpriteNode{
    
    //MARK: - Game properties
    
    var physicsFrame: CGRect!
    var velocity = CGPoint.zero
    var isOnSolidGround = false

    //MARK: - Settings properties
    
    var physicsFrameScale:CGPoint = CGPoint(x: 1, y: 1)
    var isAffectedByGravity = false;
    var isAffectedByWorldSolids = true
    
    //MARK: - System
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(imageNamed: String){
        let texture = SKTexture(imageNamed: imageNamed)
        self.init(texture: texture, color: .clear, size: texture.size())
        physicsFrame = frame.scale(physicsFrameScale)
    }
    
    //MARK: Animations
    
    //MARK: - Update
    
    func update(){
        physicsFrame = frame.scale(physicsFrameScale)
        isOnSolidGround = false
    }
    
    //MARK: - World Interactions
    
    func hitSolidXDirection(){}
    
    func hitSolidYDirection(){
        isOnSolidGround = true
    }
    
    //MARK: - Animations
    
    func createAnimation(from textureAtlastName: String, timePerFrame: TimeInterval) -> SKAction{
        let atlas = SKTextureAtlas(named: textureAtlastName)
        guard atlas.textureNames.count != 0 else {fatalError ("could not load atlas \(textureAtlastName)")}
        var animationFrames: [SKTexture] = []
        for i in 1...atlas.textureNames.count{
            let textureName = "\(textureAtlastName)\(i)"
            animationFrames.append(atlas.textureNamed(textureName))
        }
        return SKAction.animate(with: animationFrames, timePerFrame: timePerFrame, resize: false, restore: true)
    }
    
    //Draws the frame of the current node
    private var _lastFrameNode: SKShapeNode?
    func drawFrame(){
        _lastFrameNode?.removeFromParent()
        _lastFrameNode = SKShapeNode(rect: frame)
        scene?.addChild(_lastFrameNode!)
    }
    
    //MARK: - Data Storage
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
