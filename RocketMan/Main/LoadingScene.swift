//
//  LoadingScene.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 28.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

class LoadingScene: SKScene{
    
    override func didMove(to view: SKView){
        //presentGameScene()
        preloadTextureAtlases()
    }
    
    func preloadTextureAtlases(){
        var atlases = textureAtlasManager.level1Atlases
        atlases.append(textureAtlasManager.playerAtlas)
        SKTextureAtlas.preloadTextureAtlases(atlases){self.presentGameScene()}
    }
    
    func presentGameScene(){
        guard let scene = GameScene(fileNamed: "WorldScene") else{fatalError("Could not open world scene")}
        scene.scaleMode = .aspectFill
        scene.setup()
        let transition = SKTransition.doorway(withDuration: 1.5);
        view?.presentScene(scene, transition: transition);
    }
}
