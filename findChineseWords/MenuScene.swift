//
//  MenuScene.swift
//  findChineseWords
//
//  Created by Alvis Poon on 2/9/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//


import SpriteKit

class MenuScene: SKScene {
    
    var sceneManagerDelegate: SceneManagerDelegate?

    override func didMove(to view: SKView) {
        setupMenu()
    }
    
    
    func setupMenu() {
        let background = SKSpriteNode(imageNamed: "ChineseTestLogo")
        background.position = CGPoint(x: frame.midX, y: frame.midY/2*3)
        background.aspectScale(to: frame.size, width: true, multiplier: 0.65)
        //background.zPosition = ZPosition.background
        background.zPosition = 1
        addChild(background)
        
        let button = SpriteKitButton(defaultButtonImage: "nextButton", action: goToLevelScene, index: 0)
        button.position = CGPoint(x: frame.midX, y: frame.midY*0.8)
        button.aspectScale(to: frame.size, width: false, multiplier: 0.1)
        //button.zPosition = ZPosition.hudLabel
        button.zPosition = 2
        addChild(button)
        
        backgroundColor = UIColor(red: 0.78, green: 0.77, blue: 0.76, alpha: 1.0)
    }
    
    func goToLevelScene(_: Int) {
        sceneManagerDelegate?.presentLevelScene()
    }
    
}
