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
        addEnemiesFromPlaceholders(tileMap: tileMap)
    }
    
    func updateEnemies(){
        for node in children{
            guard let enemy = node as? Enemy else {continue}
            enemy.update(worldTiles: tileMap!, player: player)
        }
    }
    
    //Mark: - Add Enemies
    
    func addEnemiesFromPlaceholders(tileMap: SKTileMapNode){
        for row in 0..<tileMap.numberOfRows{
            for column in 0..<tileMap.numberOfColumns{
                if let tileDefinition = tileMap.getTileDefinition(row: row, column: column){
                    if tileDefinition.name == "Zombie"{
                        addZombie(tileMap: tileMap, row: row, column: column)
                        tileMap.removeTile(row: row, column: column)
                    }
                }
            }
        }
    }
    
    func addZombie(tileMap: SKTileMapNode, row: Int, column: Int){
        let zombie = Zombie.dequeReusableNode()
        zombie.position = CGPoint(x: CGFloat(column)*TILE_SIZE, y: CGFloat(row)*TILE_SIZE)
        zombie.position = convert(zombie.position, from: tileMap)
        addChild(zombie)
    }
}
