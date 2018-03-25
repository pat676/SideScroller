//
//  SKTileMapNode.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 14.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

extension SKTileMapNode{
    
    func removeTile(at point: CGPoint){
        let row = tileRowIndex(fromPosition: point)
        let column = tileColumnIndex(fromPosition: point)
        removeTile(row: row, column: column)
    }
    
    func removeTile(row: Int, column: Int){
        setTileGroup(nil, forColumn: column, row: row)
    }
    
    func getTileDefinition(at position: CGPoint) -> SKTileDefinition?{
        let row = tileRowIndex(fromPosition: position)
        let col = tileColumnIndex(fromPosition: position)
        if let tileDefinition = tileDefinition(atColumn: col, row: row){
            return tileDefinition
        }
        return nil
    }
    
    func getTileDefinition(row: Int, column: Int) -> SKTileDefinition?{
        if let tileDefinition = tileDefinition(atColumn: column, row: row){
            return tileDefinition
        }
        return nil
    }
    
    func getTileCenter(at position: CGPoint) -> CGPoint{
        let row = tileRowIndex(fromPosition: position)
        let col = tileColumnIndex(fromPosition: position)
        return centerOfTile(atColumn: col, row: row)
    }
    
    func getTileCenterInScene(at position: CGPoint) -> CGPoint?{
        guard let currentScene = scene else {return nil}
        let row = tileRowIndex(fromPosition: position)
        let col = tileColumnIndex(fromPosition: position)
        return convert(centerOfTile(atColumn: col, row: row), to: currentScene)
    }
    
    func getTileCenterInScene(row: Int, column: Int) -> CGPoint?{
        guard let currentScene = scene else {return nil}
        return convert(centerOfTile(atColumn: column, row: row), to: currentScene)
    }
}
