//
//  CGRect.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 15.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

extension CGRect{
    
    func scale(_ factor: CGFloat) -> CGRect{
        return CGRect(x: minX+width*(1-factor)/2, y: minY+height*(1-factor)/2, width: width*factor, height: height*factor)
    }
    
    func scale(_ factor: CGPoint) -> CGRect{
        return CGRect(x: minX+width*(1-factor.x)/2, y: minY+height*(1-factor.y)/2, width: width*factor.x, height: height*factor.y)
    }
}
