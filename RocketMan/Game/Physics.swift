//
//  Physics.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 14.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

enum Direction{
    case Up, Down, Left, Right
}

extension GameScene{
    
    func runPhysics(){
        updatePhysicNodes()
        applyGravity()
        moveNodes()
    }
    
    func moveNodes(){
        for skNode in children{
            guard let node = skNode as? PhysicsNode else{continue}
            var movement = node.velocity*CGFloat(dt)
            if(node.isAffectedByWorldSolids){
                movement = adjustMovementForCollisionWithWorld(for: node, with: movement)
            }
            node.position += movement
        }
    }
    
    func applyGravity(){
        for skNode in children{
            guard let node = skNode as? PhysicsNode else{continue}
            if(node.isAffectedByGravity){
                node.velocity.y += GRAVITY * CGFloat(dt)
            }
        }
    }
    
    //Calls the update methode in all PhysicNodes
    func updatePhysicNodes(){
        for skNode in children{
            guard let node = skNode as? PhysicsNode else{continue}
            node.update()
        }
    }
    
    /*
     * Adjusts movement for collision with solid word objects, the maximum valid movement will be returned.
     * If ha solid world object is hit in x or y direction the physicsNode, hitSolidXDirection()/ hitSolidYDirection()
     * functions are called. 
     */
    func adjustMovementForCollisionWithWorld(for node: PhysicsNode, with movement: CGPoint, lineSweepPoints: Int = 10) -> CGPoint{
        
        guard movement != CGPoint.zero else {return movement}
        guard let physicsFrame = node.physicsFrame else {return movement}
        
        let movementStep = movement/CGFloat(lineSweepPoints)
        var adjustedMovement = CGPoint.zero
        var hasHitSolidYDirection = false
        var hasHitSolidXDirection = false
        
        let pointsToCheckY = collisionPointsToCheckY(for: physicsFrame, with: movement)
        let pointsToCheckX = collisionPointsToCheckX(for: physicsFrame, with: movement)
        
        for _ in 0..<lineSweepPoints{
            if(!hasHitSolidYDirection){
                adjustedMovement.y += movementStep.y
                for point in pointsToCheckY{
                    if world.hasSolidObject(at: convert(point + adjustedMovement, to: world)){
                        adjustedMovement.y -= movementStep.y
                        hasHitSolidYDirection = true
                        node.hitSolidYDirection()
                        break
                    }
                }
            }
            
            if(!hasHitSolidXDirection){
                adjustedMovement.x += movementStep.x
                for point in pointsToCheckX{
                    if world.hasSolidObject(at: convert(point + adjustedMovement, to: world)){
                        adjustedMovement.x -= movementStep.x
                        hasHitSolidXDirection = true
                        node.hitSolidXDirection()
                        break
                    }
                }
            }
        }
        return adjustedMovement
    }
    
    /*
     * Returns an array of points on the boundary of physicsBody top or bottom that should be checked for collisions
     * with linear sweep. The points will be spaced with a maximum of TILE_SIZE to ensure the detection of tiles with
     * linear sweep.
     */
    func collisionPointsToCheckY(for physicsFrame: CGRect, with movement: CGPoint) -> [CGPoint]{
        guard movement.y != 0 else {return []}
        var pointsToCheck = [CGPoint]()
        let angle = atan2(movement.y, movement.x)
        
        //Caclulating y-direction points to check
        if(angle < 0){
            //y-Movement is downwards, appending points with a maximum distance of TILE_SIZE on the bottom physicsFrame edge
            pointsToCheck.append(CGPoint(x: physicsFrame.minX, y: physicsFrame.minY))
            while(pointsToCheck.last!.x < physicsFrame.maxX - TILE_SIZE){
                pointsToCheck.append(CGPoint(x: pointsToCheck.last!.x + TILE_SIZE, y: physicsFrame.minY))
            }
            pointsToCheck.append(CGPoint(x: physicsFrame.maxX, y: physicsFrame.minY))
        }
        else{
            //y-movement is upwards, appending points with a maximum distance of TILE_SIZE on the top physicsFrame edge
            pointsToCheck.append(CGPoint(x: physicsFrame.minX, y: physicsFrame.maxX))
            while(pointsToCheck.last!.x < physicsFrame.maxX - TILE_SIZE){
                pointsToCheck.append(CGPoint(x: pointsToCheck.last!.x + TILE_SIZE, y: physicsFrame.maxY))
            }
            pointsToCheck.append(CGPoint(x: physicsFrame.maxX, y: physicsFrame.maxY))
        }
        
        return pointsToCheck
    }
    
    /*
     * Returns an array of points on the boundary of physicsBody left or right that should be checked for collisions
     * with linear sweep. The points will be spaced with a maximum of TILE_SIZE to ensure the detection of tiles with
     * linear sweep.
     */
    func collisionPointsToCheckX(for physicsFrame: CGRect, with movement: CGPoint) -> [CGPoint]{
        guard movement.x != 0 else {return []}
        var pointsToCheck = [CGPoint]()
        let pi = CGFloat(Double.pi)
        let angle = atan2(movement.y, movement.x)
        
        //Calculating x-direction points to check
        if(angle < pi/2 && angle > -pi/2){
            //Moving in right in x-direction, appending points with a maximum distance of TILE_SIZE on the right physicsFrame edge
            pointsToCheck.append(CGPoint(x: physicsFrame.maxX, y: physicsFrame.minY))
            while(pointsToCheck.last!.y < physicsFrame.maxY - TILE_SIZE){
                pointsToCheck.append(CGPoint(x: physicsFrame.maxX, y: pointsToCheck.last!.y + TILE_SIZE))
            }
            pointsToCheck.append(CGPoint(x: physicsFrame.maxX, y: physicsFrame.maxY))
        }
        else{
            //Moving in left in x-direction, appending points with a maximum distance of TILE_SIZE on the left physicsFrame edge
            pointsToCheck.append(CGPoint(x: physicsFrame.minX, y: physicsFrame.minY))
            while(pointsToCheck.last!.y < physicsFrame.maxY - TILE_SIZE){
                pointsToCheck.append(CGPoint(x: physicsFrame.minX, y: pointsToCheck.last!.y + TILE_SIZE))
            }
            pointsToCheck.append(CGPoint(x: physicsFrame.minX, y: physicsFrame.maxY))
        }
        
        return pointsToCheck
    }
}
