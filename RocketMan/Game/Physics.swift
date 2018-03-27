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
        moveNodes()
        checkNodeWithNodeCollision()
        didUpdatePhysicNodes()
    }
    
    //Calls the willUpdatePhysics() methode in each node
    func willUpdatePhysicNodes(){
        for skNode in children{
            guard let node = skNode as? PhysicsNode else{continue}
            node.willUpdatePhysics()
        }
    }
    
    //Calls the didUpdatePhysics() methode in each node
    func didUpdatePhysicNodes(){
        for skNode in children{
            guard let node = skNode as? PhysicsNode else{continue}
            node.didUpdatePhysics()
        }
    }
    
    //Apllies gravity acceleration and moves the nodes acording to node velocity and dt
    func moveNodes(){
        for skNode in children{
            guard let node = skNode as? PhysicsNode else{continue}
            
            //Apply gravity acceleration
            if(node.isAffectedByGravity){
                node.velocity.y += GRAVITY * CGFloat(dt)
            }
            
            //Move Nodes
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
                    if hasSolidObject(at: point + adjustedMovement){
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
                    if hasSolidObject(at: point + adjustedMovement){
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
        if(direction == .Up){node.hitSolidRoof(at: point)}
        else if(direction == .Down){node.hitSolidGround(at: point)}
        else if(direction == .Right){node.hitSolidRight(at: point)}
        else if(direction == .Left){node.hitSolidLeft(at: point)}
    }
    
    //Checks all physicsNodes for node with node collision
    func checkNodeWithNodeCollision(){
        var currentIndex = 0;
        for child1 in children{
            currentIndex += 1
            guard let node1 = child1 as? PhysicsNode else{continue}
            guard node1.canCollideWithPhysicNodes else {continue}
            var i = currentIndex
            while(i<children.count){
                let child2 = children[i]
                i += 1
                guard let node2 = child2 as? PhysicsNode else{continue}
                guard node1 != node2 else {continue}
                guard node2.canCollideWithPhysicNodes else {continue}
                if(node1.physicsFrame.intersects(node2.physicsFrame)){
                    node1.collided(with: node2)
                    node2.collided(with: node1)
                }
            }
        }
    }
    
    //Returns all physicsNodes colliding with the given rect
    func getPhysicNodesColliding(with rect: CGRect) -> [PhysicsNode]{
        var collidingNodes = [PhysicsNode]()
        for child in children{
            guard let node = child as? PhysicsNode else{continue}
            guard node.canCollideWithPhysicNodes else {continue}
            if(rect.intersects(node.physicsFrame)){
                collidingNodes.append(node)
            }
        }
        return collidingNodes
    }
}
