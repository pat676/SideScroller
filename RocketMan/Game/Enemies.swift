//
//  Enemies.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 27.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

extension GameScene{
    
    func initEnemies(){
        guard let tileMap = childNode(withName: "Enemies") as? SKTileMapNode else {
            fatalError("Could not find Enemies tile map")
        }
        tileMap.anchorPoint = CGPoint.zero
        tileMap.position = CGPoint(x: 0, y: playableRect.minY)
        enemiesTileMap = tileMap
        updateEnemiesFromPlaceholders(tileMap: enemiesTileMap, extraColumns: 10)
    }
    
    func updateEnemies(){
        updateEnemiesFromPlaceholders(tileMap: enemiesTileMap, extraColumns: 10)
        for node in children{
            guard let enemy = node as? Enemy else {continue}
            enemy.update(worldTiles: tileMap!, player: player)
        }
    }
    
    
    //Mark: - Add Enemies
    
    //Removes placeholders and adds enemies in visible columns + extraCols
    func updateEnemiesFromPlaceholders(tileMap: SKTileMapNode, extraColumns: Int){
        var maxColumnForEnemies = (Int(cameraPlayableRect.maxX)/Int(TILE_SIZE)) + extraColumns
        if (maxColumnForEnemies > enemiesTileMap.numberOfColumns){
            maxColumnForEnemies = enemiesTileMap.numberOfColumns
        }

        for row in 0..<tileMap.numberOfRows{
            for column in lastMaxColumnForEnemies..<maxColumnForEnemies{
                if let tileDefinition = tileMap.getTileDefinition(row: row, column: column){
                    if tileDefinition.name == "Zombie"{
                        addZombie(tileMap: tileMap, row: row, column: column)
                        tileMap.removeTile(row: row, column: column)
                    }
                }
            }
        }
        
        lastMaxColumnForEnemies = maxColumnForEnemies
    }
    
    func addZombie(tileMap: SKTileMapNode, row: Int, column: Int){
        let zombie = Zombie()
        zombie.position = CGPoint(x: CGFloat(column)*TILE_SIZE, y: CGFloat(row)*TILE_SIZE)
        zombie.position = convert(zombie.position, from: tileMap)
        addChild(zombie)
    }
}
