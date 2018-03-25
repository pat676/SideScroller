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
    
    //Runs the physics loop
    func runPhysics(){
        willUpdatePhysicNodes()
        applyGravity()
        moveNodes()
        didUpdatePhysicNodes()
    }
    
    //Calls the willUpdatePhysics() methode in each node
    func willUpdatePhysicNodes(){
        for skNode in children{
            guard let node = skNode as? PhysicsNode else{continue}
            node.willUpdatePhysics()
        }
    }
    
    //Adjuts the velocity of every physics node with isAffectedByGravity=true
    func applyGravity(){
        for skNode in children{
            guard let node = skNode as? PhysicsNode else{continue}
            if(node.isAffectedByGravity){
                node.velocity.y += GRAVITY * CGFloat(dt)
            }
        }
    }
    
    //Calls the didUpdatePhysics() methode in each node
    func didUpdatePhysicNodes(){
        for skNode in children{
            guard let node = skNode as? PhysicsNode else{continue}
            node.didUpdatePhysics()
        }
    }
    
    //Moves the nodes acording to node velocity and dt
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
    
    /*
     * Adjusts the movement to collisions.
     *
     * Does a line sweep along the movement each sensor point applicable to the movement. (Uses sensor points on the top or
     * bottom edge and left or right edge corresponding to the movement direction). Scans linwSweepPoints times evenly
     * distributed along the sensor points movement to detect collision. X and Y direction are done seperatly and the last
     * non-colliding movement is used in each direction.
     */

    func adjustMovementForCollisionWithWorld(for node: PhysicsNode, with movement: CGPoint, lineSweepPoints: Int = 10) -> CGPoint{
        
        guard movement != CGPoint.zero else {return movement}
        
        let movementStep = movement/CGFloat(lineSweepPoints)
        var adjustedMovement = CGPoint.zero
        var hasHitSolidYDirection = false
        var hasHitSolidXDirection = false
        
        let directionX:Direction = movement.x < 0 ? .Left : .Right
        let directionY:Direction = movement.y < 0 ? .Down : .Up
        
        let pointsToCheckX = directionX == .Left ? node.getLeftSensorPoints() : node.getRightSensorPoints();
        let pointsToCheckY = directionY == .Down ? node.getBottomSensorPoints() : node.getTopSensorPoints();
        
        for _ in 0..<lineSweepPoints{
            if(!hasHitSolidYDirection){
                adjustedMovement.y += movementStep.y
                for point in pointsToCheckY{
                    if world.hasSolidObject(at: convert(point + adjustedMovement, to: world)){
                        nodeHitWorld(node, at: point + adjustedMovement, direction: directionY)
                        adjustedMovement.y -= movementStep.y
                        hasHitSolidYDirection = true
                        break
                    }
                }
            }
            
            if(!hasHitSolidXDirection){
                adjustedMovement.x += movementStep.x
                for point in pointsToCheckX{
                    if world.hasSolidObject(at: convert(point + adjustedMovement, to: world)){
                        nodeHitWorld(node, at: point + adjustedMovement, direction: directionX)
                        adjustedMovement.x -= movementStep.x
                        hasHitSolidXDirection = true
                        break
                    }
                }
            }
        }
        return adjustedMovement
    }
    
    func nodeHitWorld(_ node: PhysicsNode, at point: CGPoint, direction: Direction){
        if(direction == .Up){node.hitSolidRoof(in: world, at: convert(point, to: world))}
        else if(direction == .Down){node.hitSolidGround(in: world, at: convert(point, to: world))}
        else if(direction == .Right){node.hitSolidRight(in: world, at: convert(point, to: world))}
        else if(direction == .Left){node.hitSolidLeft(in: world, at: convert(point, to: world))}
        world.tileWasHit(by: node, at: convert(point, to: world))
    }
}
