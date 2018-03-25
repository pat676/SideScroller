//
//  World.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 14.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

class WorldNodes: SKTileMapNode{
    
    var tileMaps = [SKTileMapNode!](repeating: nil, count: 3)
    var tileMapsHealth = Array(repeating: [[CGFloat]](), count: 3)
    
    //MARK: - System
    
    init(playableRect: CGRect){
        super.init()
        addTileMaps()
        anchorPoint = CGPoint.zero
        position = CGPoint(x: 0, y: playableRect.minY)
    }
    
    //Adds the initial 3 tile maps
    private func addTileMaps(){
        tileMaps[0] = loadTileMap()
        addTileMapHealth(for: tileMaps[0], at: 0)
        for i in 1..<tileMaps.count{
            tileMaps[i] = loadTileMap();
            tileMaps[i].position.x = tileMaps[i-1].frame.maxX
            addTileMapHealth(for: tileMaps[i], at: i)
        }
        addChildren(tileMaps)
    }
    
    //Adds 2d matricies with inital value 100 to keep track of the tiles health
    private func addTileMapHealth(for tileMap: SKTileMapNode, at index: Int){
        let rows = tileMap.numberOfRows
        let columns = tileMap.numberOfColumns
        tileMapsHealth[index] = Array(repeating: Array(repeating: 100, count: columns), count: rows)

    }
    
    //MARK: - Update
    
    //Removes tile maps out of view and adds new tile maps to the far left
    func update(to cameraNode: SKCameraNode, sceneWidth: CGFloat){
        let maxX = convert(tileMaps[0].position, to: cameraNode).x + sceneWidth/2 + tileMaps[0].frame.width
        if(maxX < 0){
            tileMaps[0].removeFromParent()
            for i in 1..<tileMaps.count{
                tileMaps[i-1] = tileMaps[i]
                tileMapsHealth[i-1] = tileMapsHealth[i]
            }
            tileMaps[tileMaps.count - 1] = loadTileMap()
            tileMaps[tileMaps.count - 1].position.x = tileMaps[tileMaps.count - 2].frame.maxX
            addChild(tileMaps.last!)
            addTileMapHealth(for: tileMaps[tileMaps.count-1], at: tileMaps.count-1)
        }
    }
    
    //MARK: - Sprite Interaction
    
    //Called by physics engine if a tile is hit by a Physics Node
    func tileWasHit(by node: PhysicsNode, at position: CGPoint){
    }
    
    //Damages the tile at position and deals AOE damage if Amunition has AOE != CGPoint.zero
    func damageTile(at position: CGPoint, from node: Amunition){
        for i in 0..<tileMaps.count{
            let tileMap = tileMaps[i]
            guard tileMap!.frame.contains(position) else {continue}
            let localPos = convert(position, to: tileMap!)
            guard let row = tileMap?.tileRowIndex(fromPosition: localPos) else {return}
            guard let col = tileMap?.tileColumnIndex(fromPosition: localPos) else {return}
            if(node.AOERange == CGPoint.zero){
                damageSingleTile(index: i, row: row, column: col, damage: node.getWorldDamage())
            }
            else{
                damageAOE(index: i, row: row, column: col, damage: node.getWorldDamage(), position: localPos, AOE: node.AOERange)
            }
        }
    }
    
    //Does damage to a single tile, no AOE
    func damageSingleTile(index: Int, row: Int, column: Int, damage: CGFloat){
        guard hasSolidObject(in: tileMaps[index], row: row, column: column) else {return}
        guard hasDestructibleObject(in: tileMaps[index], row: row, column: column) else {return}
        guard tileMapsHealth[index][row][column] > 0 else {return}
        
        tileMapsHealth[index][row][column] -= damage
        if(tileMapsHealth[index][row][column] <= 0){
            destroyTile(in: tileMaps[index]!, row: row, column: column)
        }
    }
    

    //Does AOE damage to world tiles. The AOE is a rectangle, where the width and height is described with AOE:CGPoint
    func damageAOE(index: Int, row: Int, column: Int, damage: CGFloat, position: CGPoint, AOE: CGPoint){
        
        let leftmostColumn = Int(position.x - AOE.x)/Int(TILE_SIZE)
        let rightmostColumn = Int(position.x + AOE.x)/Int(TILE_SIZE)
        let bottomRow = Int(position.y - AOE.y)/Int(TILE_SIZE)
        let topRow = Int(position.y + AOE.y)/Int(TILE_SIZE)
        
        var currentIndex = index
        var row = bottomRow - 1
        var column = leftmostColumn - 1
        for _ in leftmostColumn...rightmostColumn{
            column += 1
            row = bottomRow - 1
            for _ in bottomRow...topRow{
                row += 1
                //Row is not in playable area...
                if(row < 0 || currentIndex >= 3 || row >= tileMaps[currentIndex].numberOfRows){ continue }
                
                //Column is on leftside of screen, not part of the game anymore...
                if(column < 0){ continue }
                
                //Column is in the next tileMap, calculating column in the next tileMap
                if (column >= tileMaps[currentIndex].numberOfColumns){
                    column -= tileMaps[currentIndex].numberOfColumns
                    currentIndex += 1
                }
                
                guard hasSolidObject(in: tileMaps[index], row: row, column: column) else {continue}
                guard hasDestructibleObject(in: tileMaps[index], row: row, column: column) else {continue}
                guard tileMapsHealth[index][row][column] > 0 else {continue}
                
                tileMapsHealth[currentIndex][row][column] -= damage
                if(tileMapsHealth[currentIndex][row][column] <= 0){
                    destroyTile(in: tileMaps[currentIndex]!, row: row, column: column)
                }
            }
        }
    }
    
    //Removes tiles and replaces them with NUM_DESTROYED_TILES that will fall out of scene
    func destroyTile(in tileMap: SKTileMapNode, row: Int, column: Int){
        tileMap.removeTile(row: row, column: column)
        guard let tileCenter = tileMap.getTileCenterInScene(row: row, column: column) else {return}
        
        //Add "small tiles" falling down
        for _ in 0..<NUM_DESTROYED_TILES{
            let tile = DestroyedTileNode.dequeReusableNode()
            tile.position = tileCenter
            scene?.addChild(tile)
        }
    
        //Add dust clode emitter
        guard let dustBrown = newDustBrown() else {return}
        dustBrown.position = tileCenter
        scene?.addChild(dustBrown)
    }
    
    //Same function as above, but with position instead of row / column
    func destroyTile(in tileMap: SKTileMapNode, at point: CGPoint){
        tileMap.removeTile(at: point)
        guard let tileCenter = tileMap.getTileCenterInScene(at: point) else {return}
        for _ in 0..<NUM_DESTROYED_TILES{
            let tile = DestroyedTileNode.dequeReusableNode()
            tile.position = tileCenter
            scene?.addChild(tile)
        }
        
        //Add dust clode emitter
        guard let dustBrown = newDustBrown() else {return}
        dustBrown.position = tileCenter
        scene?.addChild(dustBrown)
    }
    
    //MARK: - Tile Properties
    
    //Returns true if the tile at the given position is marked as solid
    func hasSolidObject(at position: CGPoint) -> Bool{
        for tileMap in tileMaps{
            guard tileMap!.frame.contains(position) else {continue}
            let localPos = convert(position, to: tileMap!)
            if let tileDefinition = tileMap?.getTileDefinition(at: localPos){
                if(tileDefinition.userData?["isSolid"] != nil){
                    return true
                }
            }
        }
        return false
    }
    
    //Does the same as the previous function but with row and column indexes instead of position
    func hasSolidObject(in tileMap: SKTileMapNode, row: Int, column: Int) -> Bool{
        if let tileDefinition = tileMap.getTileDefinition(row: row, column: column){
            if(tileDefinition.userData?["isSolid"] != nil){
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
    
    //Returns true if the tile is destructible
    func hasDestructibleObject(in tileMap: SKTileMapNode, row: Int, column: Int) -> Bool{
        if let tileDefinition = tileMap.getTileDefinition(row: row, column: column){
            let isDestructible: Bool? = tileDefinition.userData?["isDestructible"] as? Bool
            if(isDestructible != nil && isDestructible == true){
                return true
            }
        }
        return false
    }
    
    //MARK: - Util
    
    //Loads a tile map from scene sks file
    private func loadTileMap() -> SKTileMapNode{
        guard let worldScene = SKScene(fileNamed: "WorldScene") else{
            fatalError("Could not open world scene")
        }
        guard let tileMap = worldScene.childNode(withName: "GroundFlat") as? SKTileMapNode else{
            fatalError("Could not open GroundFlat in world scene")
        }
        tileMap.removeFromParent()
        return tileMap
    }
    
    //MARK: - Data Storage
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
