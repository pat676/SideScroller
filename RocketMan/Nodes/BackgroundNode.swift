//
//  BackgroundNode.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 12.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

class BackgroundNode: SKSpriteNode{
    
    //MARK: - Properties
    
    var backgrounds = [SKSpriteNode!](repeating: nil, count: 3)
    
    //MARK: - System
    
    init(size: CGSize){
        super.init(texture: nil, color: .clear, size: size)
        addBackgrounds()
        zPosition = -100;
        anchorPoint = CGPoint.zero
        position = CGPoint.zero
    }
    
    //Adds the backgrounds to the background array
    private func addBackgrounds(){
        backgrounds[0] = SKSpriteNode(texture: SKTexture(imageNamed:"Background"), size: size)
        backgrounds[0].anchorPoint = CGPoint.zero
        
        for i in 1..<backgrounds.count{
            backgrounds[i] = SKSpriteNode(texture: SKTexture(imageNamed:"Background"), size: size)
            backgrounds[i].anchorPoint = CGPoint.zero
            backgrounds[i].position = CGPoint(x:backgrounds[i-1].size.width, y:0)
        }
        backgrounds[0].position = CGPoint.zero
        addChildren(backgrounds)
    }
    
    
    //MARK: - Update
    
    func update(to cameraNode: SKCameraNode, sceneWidth: CGFloat){
        let maxX = convert(backgrounds[0].position, to: cameraNode).x + sceneWidth/2 + backgrounds[0].frame.width
        if(maxX < 0){
            let temp = backgrounds[0]!
            for i in 1..<backgrounds.count{
                backgrounds[i-1] = backgrounds[i]
            }
            backgrounds[backgrounds.count - 1] = temp
            temp.position.x = backgrounds[backgrounds.count - 2].frame.maxX
        }
    }
    
    //MARK: - DataStorage
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
