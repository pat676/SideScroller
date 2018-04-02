//
//  GameLogic.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 15.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

extension GameScene{
    
    //MARK: - Win/Loose conditions
    
    //Game is won when camera.maxX has reached the edge of the til map
    func checkWinCondition(){
        if cameraPlayableRect.maxX >= tileMap!.frame.maxX - TILE_SIZE{
            gameWon()
        }
    }
    
    func checkLooseCondition(){
        if (player.isDead || player.frame.maxX < cameraPlayableRect.minX || player.frame.maxY < cameraPlayableRect.minY){
            gameLost()
        }        
    }
    
    //MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let touchLocation = touch.location(in: self)
        if(isPaused && !isGameOver){
            resumeGame()
        }
        else if(isGameOver){
            returnToMainMenu()
        }
        else if(touchLocation.x < cameraPlayableRect.minX + LEFT_SCREEN_AMOUNT*cameraPlayableRect.width){
            if(!isPaused) {player.jump()}
        }
        else{
            if(!isPaused) {playerFire(at: touch.location(in: self))}
        }
    }
    
    func playerFire(at touchLocation: CGPoint){
        let bullet = player.fire()
        if(bullet != nil){
            let bulletDirection = (touchLocation - player.centerPosition()).normalized()
            bullet?.velocity = bulletDirection * PLAYER_BULLET_SPEED
            bullet?.zRotation = atan2(bulletDirection.y, bulletDirection.x)
            addChild(bullet!)
        }
    }
    
    //Removes all nodes further out of viewable screen than REMOVE_NODES_DISTANCE
    func removeNodesOutsideView(){
        let viewRect = cameraPlayableRect
        for child in children{
            if let node = child as? PhysicsNode{
                if (node.position.x < viewRect.minX - REMOVE_NODES_DISTANCE) || (node.position.x > viewRect.maxX + REMOVE_NODES_DISTANCE) || (node.position.y < viewRect.minY - REMOVE_NODES_DISTANCE) || (node.position.y > viewRect.maxY + REMOVE_NODES_DISTANCE){
                    node.removeFromParent()
                }
            }
        }
    }
    
    //MARK: - Pause Game
    
    //Used to fix a bug where the game resumes when resuming from background
    @objc func setShouldPause(){
        shouldPause = true
    }
    
    func pauseGame(){
        presentTextOverlayNode(title: "Game Paused!", subtitle: "Touch the screen to resume...")
        isPaused = true
    }
    
    func resumeGame(){
        textOverlayNode?.removeFromParent()
        isPaused = false
    }
    
    //MARK: - Game Over
    
    func gameWon(){
        isGameWon = true
        isPaused = true
        presentTextOverlayNode(title: "You Won!", subtitle: "Touch the screen to return to main menu...")
    }
    
    func gameLost(){
        isGameLost = true
        presentTextOverlayNode(title: "You Lost!", subtitle: "Touch the screen to return to main menu...")
    }
    
    //MARK: - Util
    
    func returnToMainMenu(){
        resetDequableNodes()
        let scene = LoadingScene(size: CGSize(width: 2048, height: 1536))
        view?.presentScene(scene);
    }
    
    func presentTextOverlayNode(title: String, subtitle: String){
        if(self.textOverlayNode != nil){
            self.textOverlayNode!.removeFromParent()
            self.textOverlayNode = nil
        }
        
        let textOverlayNode = SKSpriteNode(texture: nil, color: .black, size: size)
        textOverlayNode.position.x = cameraPlayableRect.minX + cameraPlayableRect.width/2
        textOverlayNode.position.y = cameraPlayableRect.minY + cameraPlayableRect.height/2
        textOverlayNode.alpha = 0.5
        textOverlayNode.zPosition = 1000
        addChild(textOverlayNode)
        self.textOverlayNode = textOverlayNode
        
        let titleNode = SKLabelNode()
        titleNode.fontName = "Chalkduster"
        titleNode.fontColor = .white
        titleNode.fontSize = 150
        titleNode.position.y = 50
        titleNode.text = title
        textOverlayNode.addChild(titleNode)
        
        let subtitleNode = SKLabelNode()
        subtitleNode.fontName = "Chalkduster"
        subtitleNode.fontColor = .white
        subtitleNode.fontSize = 75
        subtitleNode.position.y = -80
        subtitleNode.text = subtitle
        textOverlayNode.addChild(subtitleNode)
    }
}
