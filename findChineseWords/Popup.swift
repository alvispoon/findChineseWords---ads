//
//  Popup.swift
//  findChineseWords
//
//  Created by Alvis Poon on 3/9/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//


import SpriteKit

protocol PopupButtonHandlerDelegate {
    func menuTapped()
    func nextTapped()
    func retryTapped()
    func levelTapped(level: Int)
}

struct PopupButtons {
    static let menu = 0
    static let next = 1
    static let retry = 2
}

class Popup: SKSpriteNode {

    let type: Int
    let nextButtonAvailable: Int
    let topScore : Int
    let currentScore: Int
    var popupButtonHandlerDelegate: PopupButtonHandlerDelegate?
    
    init(type: Int, nextButton: Int, topScore: Int, currentScore: Int, size: CGSize) {
        self.type = type
        self.nextButtonAvailable = nextButton
        self.topScore = topScore
        self.currentScore = currentScore
        super.init(texture: nil, color: UIColor.clear, size: size)
        setupPopup()
    }
    
    func setupPopup() {
        let background = type == 0 ? SKSpriteNode(imageNamed: "ResultBoard") : SKSpriteNode(imageNamed: "ResultBoard")
        background.aspectScale(to: size, width: true, multiplier: 0.8)
        
        let scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
               scoreLabel.fontSize = 30.0
              scoreLabel.verticalAlignmentMode = .center
              scoreLabel.text = "Best Score: \(topScore)"
              scoreLabel.zPosition = 10
        scoreLabel.fontColor = .white
              scoreLabel.aspectScale(to: size, width: true, multiplier: 0.6)
        
        
        let currentscoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        currentscoreLabel.fontSize = 30.0
        currentscoreLabel.verticalAlignmentMode = .center
        currentscoreLabel.text = "Current : \(topScore)"
        currentscoreLabel.zPosition = 10
              
        currentscoreLabel.aspectScale(to: size, width: true, multiplier: 0.025)
        
        
        
        
        
        let menuButton = SpriteKitButton(defaultButtonImage: "homeButton", action: popupButtonHandler, index: PopupButtons.menu)
        let nextButton = SpriteKitButton(defaultButtonImage: "nextButton", action: popupButtonHandler, index: PopupButtons.next)
        let retryButton = SpriteKitButton(defaultButtonImage: "retryButton", action: popupButtonHandler, index: PopupButtons.retry)
        nextButton.isUserInteractionEnabled = type == 0 ? true : false
        
        menuButton.aspectScale(to: background.size, width: true, multiplier: 0.2)
        nextButton.aspectScale(to: background.size, width: true, multiplier: 0.2)
        retryButton.aspectScale(to: background.size, width: true, multiplier: 0.2)
        
        let buttonWidthOffset = retryButton.size.width/2
        let buttonHeightOffset = retryButton.size.height/2
        let backgroundWidthOffset = background.size.width/2
        let backgroundHeightOffset = background.size.height/2
        
        menuButton.position = CGPoint(x: -backgroundWidthOffset + buttonWidthOffset, y: -backgroundHeightOffset - buttonHeightOffset)
        nextButton.position = CGPoint(x: 0, y: -backgroundHeightOffset - buttonHeightOffset)
        retryButton.position = CGPoint(x: backgroundWidthOffset - buttonWidthOffset, y: -backgroundHeightOffset - buttonHeightOffset)
        background.position = CGPoint(x: 0, y: buttonHeightOffset)
        
        scoreLabel.position = CGPoint(x: 0, y: buttonHeightOffset)
        
        
        addChild(menuButton)
        if (nextButtonAvailable == 1){
            addChild(nextButton)
            }
        addChild(retryButton)
       addChild(background)
        addChild(scoreLabel)
    }
    
    func popupButtonHandler(index: Int) {
        switch index {
        case PopupButtons.menu:
            popupButtonHandlerDelegate?.menuTapped()
        case PopupButtons.next:
            popupButtonHandlerDelegate?.nextTapped()
        case PopupButtons.retry:
            popupButtonHandlerDelegate?.retryTapped()
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

