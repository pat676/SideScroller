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
    var world: WorldNodes!
    var player: PlayerNode!
    
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
    
    //MARK: - System
    override init(size: CGSize){
        super.init(size: size);
    }
    
    override func didMove(to view: SKView){
        addPlayableRect()
        addBackground()
        addWorld()
        addPlayer()
        addCamera()
    }
    
    //MARK: - Game update
    
    override func update(_ currentTime: TimeInterval){
        
        //Updates phase before Physics
        updateDt(currentTime)
        background.update(to: camera!, sceneWidth: frame.width)
        world.update(to: camera!, sceneWidth: frame.width)
        camera?.update(dt: dt)
        player.update(in: cameraPlayableRect)
        
        //Physics phase
        runPhysics()
        
        removeNodesOutsideView()
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
    
    func addWorld(){
        world = WorldNodes(playableRect: playableRect)
        addChild(world)
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
    
    func removeNodesOutsideView(){
        for child in children{
            guard let node = child as? PhysicsNode else {continue}
            if (node.position.x < cameraPlayableRect.minX - REMOVE_NODES_DISTANCE) || (node.position.x > cameraPlayableRect.maxX + REMOVE_NODES_DISTANCE) || (node.position.y < cameraPlayableRect.minY - REMOVE_NODES_DISTANCE) || (node.position.y > cameraPlayableRect.maxY + REMOVE_NODES_DISTANCE){
                node.removeFromParent()
            }
        }
    }
    
    //MARK: - DataStorage
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
