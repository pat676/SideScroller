//
//  GameScene.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 12.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //MARK: - Nodes
    
    var background: BackgroundNode!
    var player: PlayerNode!
    weak var tileMap: SKTileMapNode?
    var tileMapsHealth = [[CGFloat]]() // Keeps track of tile health
    
    //MARK: - Properties
    
    var playableRect: CGRect!;
    var cameraPlayableRect: CGRect{
        return CGRect(
            x: camera!.position.x - playableRect.size.width/2,
            y: camera!.position.y - playableRect.size.height/2,
            width: playableRect.width,
            height: playableRect.height);
    }
    
    var lastUpdateTime: TimeInterval = 0;
    var dt: TimeInterval = 0;
    
    override var isPaused:Bool{
        willSet(newValue){
            super.isPaused = newValue
            if(!newValue){
                lastUpdateTime = 0;
                dt = 0;
            }
        }
    }
    
    //MARK: - System
    /*
    override init(size: CGSize){
        super.init(size: size);
    }
    */
 
    override func didMove(to view: SKView){
        addPlayableRect()
        addBackground()
        addWorld()
        addPlayer()
        addCamera()
    }
    
    //MARK: - Game update
    override func update(_ currentTime: TimeInterval){
        if !isPaused{
            //Updates phase before Physics
            updateDt(currentTime)
            background.update(to: camera!, sceneWidth: frame.width)
            camera!.update(dt: dt)
            player.update(in: cameraPlayableRect)
        
            //Physics phase
            runPhysics()
            checkWinCondition()
            checkLooseCondition()
            
            //Cleanup phase
            removeNodesOutsideView()
        }
    }
    
    //Calculates the time passed since last frame
    func updateDt(_ currentTime: CFTimeInterval){
        if lastUpdateTime > 0{
            dt = currentTime-lastUpdateTime;
        }else{
            dt = 0;
        }
        lastUpdateTime = currentTime;
    }
    
    //MARK: - Add Nodes
    
    func addBackground(){
        background = BackgroundNode(size: size)
        addChild(background)
    }
    
    func addPlayer(){
        player = PlayerNode(playableRect: playableRect, playerMargin: PLAYER_MARGIN)
        addChild(player)
    }
    
    func addCamera(){
        let cam = SKCameraNode(position: CGPoint(x: size.width/2, y: size.height/2))
        camera = cam
        addChild(camera!)
    }
    
    func addPlayableRect(){
        let playableHeight: CGFloat = size.width/MAX_ASPECT_RATIO;
        let playableMargin: CGFloat = (size.height - playableHeight)/2.0;
        playableRect = CGRect(x:0, y:playableMargin, width: size.width, height: playableHeight);
    }
    
    
    //Removes all nodes further out of viewable screen than REMOVE_NODES_DISTANCE
    func removeNodesOutsideView(){
        for child in children{
            if let node = child as? PhysicsNode{
                if (node.position.x < cameraPlayableRect.minX - REMOVE_NODES_DISTANCE) || (node.position.x > cameraPlayableRect.maxX + REMOVE_NODES_DISTANCE) || (node.position.y < cameraPlayableRect.minY - REMOVE_NODES_DISTANCE) || (node.position.y > cameraPlayableRect.maxY + REMOVE_NODES_DISTANCE){
                    node.removeFromParent()
                }
            }
        }
    }
    
    //MARK: - DataStorage
    /*
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 */
}
