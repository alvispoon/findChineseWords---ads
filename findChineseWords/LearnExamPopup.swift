//
//  LearnExamPopup.swift
//  findChineseWords
//
//  Created by Alvis Poon on 28/10/2023.
//  Copyright © 2023 Alvis Poon. All rights reserved.
//

import Foundation




import SpriteKit

protocol LearnExamPopupButtonHandlerDelegate {
    func learningTapped()
    func examTapped()
}

struct LearnExamPopupButton {
    static let menu = 0
    static let next = 1
}

class LearnExamPopup: SKSpriteNode {

    var learnExamPopupButtonHandlerDelegate: LearnExamPopupButtonHandlerDelegate?
    var levelNo: Int
    
    init( size: CGSize, levelNo: Int) {
        self.levelNo = levelNo
        super.init(texture: nil, color: UIColor.clear, size: size)
       // self.levelNo = levelNo
        setupPopup()
    }
    
    func retrieveScore(){
        // Assuming you have retrievedLevelScores array
        let retrievedLevelScores = ScoreManager.retrieveLevelScoresFromUserDefaults()

        // Specify the key you are looking for
        let desiredKey = "B"

        // Find the LevelScore with the desired key
        if let levelScoreWithDesiredKey = retrievedLevelScores.first(where: { $0.key == desiredKey }) {
            // Use levelScoreWithDesiredKey
            print("Found LevelScore with key '\(desiredKey)': \(levelScoreWithDesiredKey)")
        } else {
            print("LevelScore with key '\(desiredKey)' not found")
        }
    }
    
    func setupPopup() {
        //let background = SKSpriteNode(imageNamed: "pass")
        //ackground.aspectScale(to: size, width: true, multiplier: 0.8)
        
        let background = createColoredSprite(size: size, color: SKColor.blue, alpha: 0.5)
            //     addChild(coloredSprite)
        
        var scoreLabel = SKLabelNode(fontNamed: "AmericanTypeWriter-Bold")
        var bestLabel = SKLabelNode(fontNamed: "AmericanTypeWriter-Bold")
        
        var topScore = 0
        
        let defaults = UserDefaults.standard
        topScore = defaults.integer(forKey: "level_\(levelNo)")
        

        if topScore == 0{
            scoreLabel.text = "--"}
        else{
            
            scoreLabel.text = "\(topScore)"
        }
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = .yellow
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.name = "\(topScore)"
        scoreLabel.zPosition = 20
        scoreLabel.aspectScale(to: size , width: false, multiplier: 0.06)  //*CGFloat(topScore.count)
        
        
        bestLabel.text = "BEST"
        bestLabel.fontSize = 40
        bestLabel.fontColor = .yellow
        bestLabel.verticalAlignmentMode = .center
        bestLabel.name = "BEST"
        bestLabel.zPosition = 20
        bestLabel.aspectScale(to: size , width: true, multiplier: 0.4)  //*CGFloat(topScore.count)
        
        
        
        let menuButton = SpriteKitButton(defaultButtonImage: "LearnButton", action: popupButtonHandler, index: PopupButtons.menu)
        let nextButton = SpriteKitButton(defaultButtonImage: "TestButton", action: popupButtonHandler, index: PopupButtons.next)
        
        nextButton.isUserInteractionEnabled = true
        
        menuButton.aspectScale(to: background.size, width: true, multiplier: 0.6)
        nextButton.aspectScale(to: background.size, width: true, multiplier: 0.6)
        
        let buttonWidthOffset = menuButton.size.width/2
        let buttonHeightOffset = menuButton.size.height/2
        let backgroundWidthOffset = size.width * 0.8 / 2
        let backgroundHeightOffset = size.height * 0.8 / 2
        
        menuButton.position = CGPoint(x: 0, y: -menuButton.size.height)
        nextButton.position = CGPoint(x: 0, y: -menuButton.size.height * 2.5)
        background.position = CGPoint(x: 0, y: buttonHeightOffset)
        
        scoreLabel.position = CGPoint (x:0,y:menuButton.size.height)
        bestLabel.position = CGPoint (x:0,y:menuButton.size.height*2)
        
        
        background.zPosition = 10
        menuButton.zPosition = 20
        nextButton.zPosition = 20
        
        
        addChild(menuButton)
        addChild(nextButton)
        addChild(scoreLabel)
        addChild(bestLabel)
        addChild(background)
    }
    
    func popupButtonHandler(index: Int) {
        switch index {
        case PopupButtons.menu:
            learnExamPopupButtonHandlerDelegate?.learningTapped()
        case PopupButtons.next:
            learnExamPopupButtonHandlerDelegate?.examTapped()
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createColoredSprite(size: CGSize, color: SKColor, alpha: CGFloat) -> SKSpriteNode {
         // Create an SKSpriteNode with a colored background
         let sprite = SKSpriteNode(color: color, size: size)
         
         // Set the position of the sprite to the center of the screen
         sprite.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
         
         // Set the alpha value to make the sprite semi-transparent
         sprite.alpha = alpha
         
         return sprite
     }
}
