//
//  AlternativeMovementCollision.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 22.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import Foundation

/*
/*
 * Adjusts movement for collision with solid word objects, the maximum valid movement will be returned.
 * If ha solid world object is hit in x or y direction the physicsNode, hitSolidXDirection()/ hitSolidYDirection()
 * functions are called.
 */
func adjustMovementForCollisionWithWorld(for node: PhysicsNode, with movement: CGPoint){
    
    
    var remainingMovement = movement
    remainingMovement.x = abs(remainingMovement.x) < MOVE_TOL ? 0 : remainingMovement.x
    remainingMovement.y = abs(remainingMovement.y) < MOVE_TOL ? 0 : remainingMovement.y
    
    let directionX:Direction = movement.x < 0 ? .Left : .Right
    let directionY:Direction = movement.y < 0 ? .Down : .Up
    while(remainingMovement.x > 0 || remainingMovement.y > 0){
        
        let sensorPointsX = directionX == .Left ? node.getLeftSensorPoints() : node.getRightSensorPoints();
        let sensorPointsY = directionY == .Down ? node.getBottomSensorPoints() : node.getTopSensorPoints();
        
        if(collisionHappend(for: sensorPointsX)){
            node.hitSolidXDirection()
            if directionX == .Left {node.hitSolidLeft = true}
            else {node.hitSolidRight = true}
            remainingMovement.x = 0;
        }
        if(collisionHappend(for: sensorPointsY)){
            node.hitSolidYDirection()
            if directionY == .Down {node.hitSolidGround = true}
            else {node.hitSolidRoof = true}
            remainingMovement.y = 0;
        }
        
        if(abs(remainingMovement.x) < MOVE_TOL && abs(remainingMovement.y) < MOVE_TOL){break}
        
        remainingMovement = moveNextStep(for: remainingMovement, node: node, sensorPointsX: sensorPointsX, sensorPointsY: sensorPointsY, directionX: directionX, directionY: directionY)
        remainingMovement.x = abs(remainingMovement.x) < MOVE_TOL ? 0 : remainingMovement.x
        remainingMovement.y = abs(remainingMovement.y) < MOVE_TOL ? 0 : remainingMovement.y
    }
    
}

//TODO: Fix initial nextXBoundary and nextYBoundary (Movement can be zero)
//Moves the node until tilegrid boundary is hit or all movement is done
func moveNextStep(for movement: CGPoint, node: PhysicsNode, sensorPointsX: [CGPoint], sensorPointsY: [CGPoint], directionX: Direction, directionY: Direction) -> CGPoint{
    guard let commonSensorPoint = getCommonSensorPoint(sensorPointsX: sensorPointsX, sensorPointsY: sensorPointsY) else{
        fatalError("No common sensor point found! sensorPointsX = \(sensorPointsX), sensorPointsY = \(sensorPointsY)")
    }
    
    let tileFrame = world.getTileFrame(for: commonSensorPoint)
    //Calculate the position of the next x and y tile grid boundaries
    let nextXBoundary = directionX == .Left ? tileFrame.minX : tileFrame.maxX
    let nextYBoundary = directionY == .Down ? tileFrame.minY : tileFrame.maxY
    
    //Start by setting the next y and y position to the boundaries
    var nextXPosition = nextXBoundary
    var nextYPosition = nextYBoundary
    
    //Calculate the movement amount to reach this bounday
    let moveAmountToNextXBoundary = nextXBoundary - commonSensorPoint.x
    let moveAmountToNextYBoundary = nextYBoundary - commonSensorPoint.y
    
    //If the amount to reach the boundaries exceedes the remaining movement, calculate next position from movement
    if(abs(moveAmountToNextXBoundary) > abs(movement.x)){
        nextXPosition = commonSensorPoint.x + movement.x
    }
    if(abs(moveAmountToNextYBoundary) > abs(movement.y)){
        nextYPosition = commonSensorPoint.y + movement.y
    }
    
    //Calculate the amount used of the remaining movement in x and y directions
    let xMoveOfTotal = movement.x == 0 ? 1.1 : (nextXPosition - commonSensorPoint.x)/movement.x
    let yMoveOfTotal = movement.y == 0 ? 1.1 : (nextYPosition - commonSensorPoint.y)/movement.y
    
    //Adjust the movement direction with largest amount to the one with smallest
    if(xMoveOfTotal < yMoveOfTotal){
        nextYPosition = commonSensorPoint.y + (xMoveOfTotal * movement.y)
    }
    else if(yMoveOfTotal < xMoveOfTotal){
        nextXPosition = commonSensorPoint.x + (yMoveOfTotal * movement.y)
    }
    
    //Make sure that zero movent actually is zero
    if(abs(movement.x) < MOVE_TOL) {nextXPosition = commonSensorPoint.x}
    if(abs(movement.y) < MOVE_TOL) {nextYPosition = commonSensorPoint.y}
    
    
    //Subtract the moves from movement to calculate remaining movement
    var remainingMovement = CGPoint.zero
    remainingMovement.x = movement.x - (nextXPosition - commonSensorPoint.x)
    remainingMovement.y = movement.y - (nextYPosition - commonSensorPoint.y)
    
    //Movement until now has been in relation to the common sensor point, adjust this to fit with node physics frame
    nextXPosition = directionX == .Left ? nextXPosition : nextXPosition - node.physicsFrame.width
    nextYPosition = directionY == .Down ? nextYPosition : nextYPosition - node.physicsFrame.height
    
    //Move the node
    node.moveRelativeToPhysicsFrame(to: CGPoint(x: nextXPosition, y: nextYPosition))
    
    return remainingMovement
}

//Returns true if one of the given points is in a tile containing a solid object
func collisionHappend(for sensorPoints: [CGPoint]) -> Bool{
    for point in sensorPoints{
        if(world.hasSolidObject(at: convert(point, to: world))){
            return true
        }
    }
    return false
}

// Returns the sensor point that is equal in both arrays. Returns nil if no points are equal
func getCommonSensorPoint(sensorPointsX: [CGPoint], sensorPointsY: [CGPoint]) -> CGPoint?{
    for pointX in sensorPointsX {
        for pointY in sensorPointsY{
            if(pointX == pointY){return pointX}
        }
    }
    return nil
}
*/


/*
 * Adjusts the movement to collisions.
 *
 * Does a line sweep along the movement each sensor point applicable to the movement. (Uses sensor points on the top or
 * bottom edge and left or right edge corresponding to the movement direction). Scans lineSweepPoints times evenly
 * distributed along the sensor points movement to detect collision. X and Y direction are done seperatly and the last
 * non-colliding movement is used in each direction.
 */
/*
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
                    if(directionY == .Down){adjustedMovement.y = ceil(adjustedMovement.y)}
                    else{adjustedMovement.y = floor(adjustedMovement.y)}
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
                    if(directionX == .Left){adjustedMovement.x = ceil(adjustedMovement.x)}
                    else{adjustedMovement.x = floor(adjustedMovement.x)}
                    hasHitSolidXDirection = true
                    break
                }
            }
        }
    }
    return adjustedMovement
}
*/
