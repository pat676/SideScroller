//
//  CameraNode.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 13.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit


extension SKCameraNode{
    
    convenience init(position: CGPoint){
        self.init()
        self.position = position
    }
    
    func update(dt: TimeInterval){
        position.x += CAMERA_VELOCITY * CGFloat(dt)
    }
}
