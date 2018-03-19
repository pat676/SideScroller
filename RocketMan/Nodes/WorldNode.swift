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
    
    //MARK: - System
    
    init(playableRect: CGRect){
        super.init()
        addTileMaps()
        anchorPoint = CGPoint.zero
        position = CGPoint(x: 0, y: playableRect.minY)
    }
    
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
    
    private func addTileMaps(){
        tileMaps[0] = loadTileMap()
        for i in 1..<tileMaps.count{
            tileMaps[i] = loadTileMap();
            tileMaps[i].position.x = tileMaps[i-1].frame.maxX
        }
        addChildren(tileMaps)
    }
    
    //MARK: - Update
    
    func update(to cameraNode: SKCameraNode, sceneWidth: CGFloat){
        let maxX = convert(tileMaps[0].position, to: cameraNode).x + sceneWidth/2 + tileMaps[0].frame.width
        if(maxX < 0){
            tileMaps[0].removeFromParent()
            for i in 1..<tileMaps.count{
                tileMaps[i-1] = tileMaps[i]
            }
            tileMaps[tileMaps.count - 1] = loadTileMap()
            tileMaps[tileMaps.count - 1].position.x = tileMaps[tileMaps.count - 2].frame.maxX
            addChild(tileMaps.last!)
        }
    }

    //MARK: - Util
    
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
    
    //MARK: - Data Storage
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
