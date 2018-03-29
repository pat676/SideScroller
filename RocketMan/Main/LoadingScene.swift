//
//  LoadingScene.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 28.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

class LoadingScene: SKScene{
    
    var gameScene: GameScene!
    var textNode: SKNode!
    var titleNode: SKLabelNode!
    var subtitleNode: SKLabelNode!
    
    override func didMove(to view: SKView){
        scaleMode = .aspectFill
        addBackground()
        addText()
        preloadTextureAtlases()
    }
    
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
    
    func preloadTextureAtlases(){
        subtitleNode.text = "Loading textures"
        var atlases = textureAtlasManager.level1Atlases
        atlases.append(textureAtlasManager.playerAtlas)
        SKTextureAtlas.preloadTextureAtlases(atlases){self.setUpGameScene()}
    }
    
    func setUpGameScene(){
        subtitleNode.text = "Initializing scene"
        guard let scene = GameScene(fileNamed: "WorldScene") else{fatalError("Could not open world scene")}
        scene.scaleMode = .aspectFill
        scene.setup()
        gameScene = scene
        presentGameScene()
    }
    
    func presentGameScene(){
        let transition = SKTransition.fade(withDuration: 1.5);
        view?.presentScene(gameScene, transition: transition);
    }
}
