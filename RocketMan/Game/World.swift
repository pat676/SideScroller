//
//  World.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 14.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

extension GameScene{
    
    func initWorld(){
        guard let tileMap = childNode(withName: "World") as? SKTileMapNode else {fatalError("Could not find World tile map")}
        self.tileMap = tileMap
        tileMap.anchorPoint = CGPoint.zero
        tileMap.position = CGPoint(x: 0, y: playableRect.minY)
        addTileMapHealth()
    }
    
    //Adds 2d matricies with inital value 100 to keep track of the tiles health
    private func addTileMapHealth(){
        tileMapsHealth = Array(repeating: Array(repeating: 100, count: tileMap!.numberOfColumns), count: tileMap!.numberOfRows)
    }
    
    //MARK: - Sprite Interaction
    
    //Called by physics engine if a tile is hit by a Physics Node
    func tileWasHit(by node: PhysicsNode, at position: CGPoint){}
    
    //Damages the tile at position and deals AOE damage if Amunition has AOE != CGPoint.zero
    func damageTile(at position: CGPoint, from node: Amunition){
        guard tileMap!.frame.contains(position) else {return}
        let localPos = convert(position, to: tileMap!)
        guard let row = tileMap?.tileRowIndex(fromPosition: localPos) else {return}
        guard let col = tileMap?.tileColumnIndex(fromPosition: localPos) else {return}

        damageSingleTile(row: row, column: col, damage: node.damage)
        damageAOE(row: row, column: col, damage: node.AOEDamage, position: localPos, AOE: node.AOERange)
    }
    
    //Does damage to a single tile, no AOE
    func damageSingleTile(row: Int, column: Int, damage: CGFloat){
        guard hasSolidObject(row: row, column: column) else {return}
        guard hasDestructibleObject(row: row, column: column) else {return}
        guard tileMapsHealth[row][column] > 0 else {return}
        
        tileMapsHealth[row][column] -= damage
        if(tileMapsHealth[row][column] <= 0){
            destroyTile(row: row, column: column)
        }
    }
    

    //Does AOE damage to world tiles. The AOE is a rectangle, where the width and height is described with AOE:CGPoint
    func damageAOE(row: Int, column: Int, damage: CGFloat, position: CGPoint, AOE: CGPoint){
        
        let leftmostColumn = Int(position.x - AOE.x)/Int(TILE_SIZE)
        let rightmostColumn = Int(position.x + AOE.x)/Int(TILE_SIZE)
        let bottomRow = Int(position.y - AOE.y)/Int(TILE_SIZE)
        let topRow = Int(position.y + AOE.y)/Int(TILE_SIZE)
        
        for column in leftmostColumn...rightmostColumn{
            for row in bottomRow...topRow{
                
                //Not in tilemap...
                if((row < 0) || (row >= tileMap!.numberOfRows) || (column < 0) || (column >= tileMap!.numberOfColumns)){ continue }
                
                guard hasSolidObject(row: row, column: column) else {continue}
                guard hasDestructibleObject(row: row, column: column) else {continue}
                guard tileMapsHealth[row][column] > 0 else {continue}
                
                tileMapsHealth[row][column] -= damage
                if(tileMapsHealth[row][column] <= 0){
                    destroyTile(row: row, column: column)
                }
            }
        }
    }
    
    //Removes tiles and replaces them with NUM_DESTROYED_TILES that will fall out of scene
    func destroyTile(row: Int, column: Int){
        tileMap!.removeTile(row: row, column: column)
        guard let tileCenter = tileMap!.getTileCenterInScene(row: row, column: column) else {return}
        
        //Add "small tiles" falling down
        for _ in 0..<DESTROYED_TILES_NUMBER{
            let tile = DestroyedTileNode.dequeReusableNode()
            tile.position = tileCenter
            addChild(tile)
        }
    
        //Add dust clode emitter
        guard let dustBrown = newDustBrown() else {return}
        dustBrown.position = tileCenter
        addChild(dustBrown)
    }
    
    //Same function as above, but with position instead of row / column
    func destroyTile(at point: CGPoint){
        tileMap!.removeTile(at: point)
        guard let tileCenter = tileMap!.getTileCenterInScene(at: point) else {return}
        
        //Add "small tiles" falling down
        for _ in 0..<DESTROYED_TILES_NUMBER{
            let tile = DestroyedTileNode.dequeReusableNode()
            tile.position = tileCenter
            addChild(tile)
        }
        
        //Add dust clode emitter
        guard let dustBrown = newDustBrown() else {return}
        dustBrown.position = tileCenter
        addChild(dustBrown)
    }
    
    //MARK: - Tile Properties
    
    //Returns true if the tile at the given position is marked as solid
    func hasSolidObject(at position: CGPoint) -> Bool{
        guard tileMap!.frame.contains(position) else {return false}
        let localPos = convert(position, to: tileMap!)
        if let tileDefinition = tileMap?.getTileDefinition(at: localPos){
            if(tileDefinition.userData?["isSolid"] != nil){
                return true
            }
        }
        return false
    }
    
    //Does the same as the previous function but with row and column indexes instead of position
    func hasSolidObject(row: Int, column: Int) -> Bool{
        if let tileDefinition = tileMap!.getTileDefinition(row: row, column: column){
            if(tileDefinition.userData?["isSolid"] != nil){
                return true
            }
        }
        return false
    }
    
    //Returns true if the tile is destructible
    func hasDestructibleObject(row: Int, column: Int) -> Bool{
        if let tileDefinition = tileMap!.getTileDefinition(row: row, column: column){
            let isDestructible: Bool? = tileDefinition.userData?["isDestructible"] as? Bool
            if(isDestructible != nil && isDestructible == true){
                return true
            }
        }
        return false
    }
    
    //Returns the bounds of the tile frame containing the position.
    func getTileFrame(for position: CGPoint) -> CGRect{
        let minX = CGFloat(Int(position.x)/Int(TILE_SIZE)) * TILE_SIZE
        let minY = CGFloat(Int(position.y)/Int(TILE_SIZE)) * TILE_SIZE
        let width = TILE_SIZE
        let height = TILE_SIZE
        return CGRect(x: minX, y: minY, width: width, height: height)
    }
}
