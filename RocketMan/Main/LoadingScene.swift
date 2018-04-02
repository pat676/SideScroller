//
//  LoadingScene.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 28.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

class LoadingScene: SKScene{
    
    //MARK: - Properties
    
    var gameScene: GameScene!
    var textNode: SKNode!
    var titleNode: SKLabelNode!
    var subtitleNode: SKLabelNode!
    var loadingStage = 0
    
    //MARK: - System
    
    override func didMove(to view: SKView){
        scaleMode = .aspectFill
        addBackground()
        addText()
    }
    
    override func willMove(from view: SKView) {
        gameScene = nil
        textNode = nil
        titleNode = nil
        subtitleNode = nil
        for node in children{
            node.removeAllActions()
            node.removeFromParent()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(loadingStage == 0){
            subtitleNode.text = "Initializing scene"
            guard let scene = GameScene(fileNamed: "WorldScene") else{fatalError("Could not open world scene")}
            gameScene = scene
            gameScene.scaleMode = .aspectFill
        }
        else if(loadingStage == 1){
            subtitleNode.text = "Loading Nodes"
            gameScene.resetDequableNodes()
            gameScene.preloadDequableNodes()
        }
        else if(loadingStage == 2){
            subtitleNode.text = "Loading Game World"
            gameScene.addPlayableRect()
            gameScene.addBackground()
            gameScene.initWorld()
            gameScene.addCamera()
        }
        else if(loadingStage == 3){
            subtitleNode.text = "Adding Enemies"
            gameScene.initEnemies()
            gameScene.addPlayer()
        }
        else if(loadingStage == 4){
            subtitleNode.text = "Loading finished"
            presentGameScene()
        }
        loadingStage += 1
    }
    
    //MARK: - Design
    
    func addBackground(){
        let background = SKSpriteNode(imageNamed: "LoadingScreen")
        background.anchorPoint = CGPoint.zero
        background.scale(to: self.size)
        addChild(background)
    }
    
    func addText(){
        textNode = SKNode()
        textNode.position = CGPoint(x: size.width/2, y: size.height/2)
        textNode.zPosition = 1
        
        titleNode = SKLabelNode()
        titleNode.fontName = "Chalkduster"
        titleNode.fontColor = .black
        titleNode.fontSize = 100
        titleNode.position.y = 50
        titleNode.text = "Starting Game..."
        textNode.addChild(titleNode)
        
        subtitleNode = SKLabelNode()
        subtitleNode.fontName = "Chalkduster"
        subtitleNode.fontColor = .black
        subtitleNode.fontSize = 40
        subtitleNode.position.y = -50
        textNode.addChild(subtitleNode)
        
        addChild(textNode)
    }
    
    //MARK: - Load GameScene
    
    func presentGameScene(){
        let transition = SKTransition.fade(withDuration: 1.5);
        view?.presentScene(gameScene, transition: transition);
    }
}
