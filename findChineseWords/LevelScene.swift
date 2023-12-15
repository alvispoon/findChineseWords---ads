//
//  LevelScene.swift
//  findChineseWords
//
//  Created by Alvis Poon on 2/9/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//

import SpriteKit

class LevelScene: SKScene {
    
    var sceneManagerDelegate: SceneManagerDelegate?
    
    var level: Level!
    
    let levelLayer = SKNode()
    let background = SKSpriteNode(imageNamed: "levelBG")
    
    var levelNo: Int = 0
    
    override func didMove(to view: SKView) {
        setupLevelSelection()
        animateScene{
            
        }
        
    }
    
    func setupLevelSelection() {
        
        let numberOfcol =  2
        
        levelLayer.position = CGPoint(x: 0, y: size.height)
        addChild (levelLayer)
        
       
        background.position = CGPoint(x: frame.midX, y:  frame.midY)
        
        //ipad
        if UIDevice.current.userInterfaceIdiom == .pad {
            background.aspectScale(to: frame.size, width: false, multiplier: 0.95)
     
        }else{
            background.aspectScale(to: frame.size, width: true, multiplier: 0.95)
     
        }
        background.zPosition = 1
        levelLayer.addChild(background)
        
        //var level = 1
        var colgap = size.height*0.01
        var columnStartingPoint = size.width/4 + colgap
        
        var rowgap = size.height*0.02
        var rowStartingPoint = size.height - rowgap * 3
        
        let noOfLevel = level.numOfLevel()
        var passLevel = UserDefaults.standard.integer(forKey: .passLevel)
        passLevel = 99
//        if (passLevel == 0){
//            passLevel = 1
//        }
        print ("passLevel\(passLevel)")
        var counter = 0
        
        let  levelname  = level.levelName()
        
        
        for row in 0..<levelname.count/numberOfcol {
            for column in 0..<numberOfcol {
                if (counter < noOfLevel){
                let levelBoxButton = SpriteKitButton(defaultButtonImage: "RoundButton", action: goToGameSceneFor, index: counter)
                    
                levelBoxButton.zPosition = 2
                    levelLayer.addChild(levelBoxButton)
                
                if (counter <= passLevel){
                let levelLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
                levelLabel.fontSize = 200.0
                levelLabel.verticalAlignmentMode = .center
//                levelLabel.text = "\(counter+1)"
                    levelLabel.text = "\(levelname[counter])"
                levelLabel.zPosition = 10
                    
                    
                    
                levelLabel.aspectScale(to: levelBoxButton.size, width: false, multiplier: 0.5)
                
                levelBoxButton.addChild(levelLabel)
                
                }else{
                    print ("Enter Level Lock")
                    let lock = SKSpriteNode(imageNamed: "lock.png")
                    lock.aspectScale(to: frame.size, width: true, multiplier: 0.25)
                    //lock.texture = SKTexture(imageNamed: "speaker1.png")
                    
                    
                    let levelLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
                    levelLabel.fontSize = 200.0
                    levelLabel.verticalAlignmentMode = .center
    //                levelLabel.text = "\(counter+1)"
                        levelLabel.text = "\(levelname[counter])"
                    levelLabel.zPosition = 10
                    levelLabel.aspectScale(to: levelBoxButton.size, width: false, multiplier: 0.5)
                    
                    levelBoxButton.addChild(levelLabel)
                    
                    
                    
                    lock.position = CGPoint(x: 0, y: 0)//CGPoint(x: frame.midX, y: frame.midY)
                    lock.zPosition = 10
                    levelBoxButton.addChild(lock)
                    
                    
                    levelBoxButton.isUserInteractionEnabled = false
                    levelBoxButton.alpha = 0.7
                    }
                    
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        
                         colgap = size.height*0.01
                         columnStartingPoint = size.width/4 + colgap * 8
                        
                         rowgap = size.height*0.02
                         rowStartingPoint = size.height - rowgap
                        levelBoxButton.aspectScale(to: frame.size, width: false, multiplier: 0.08)
                        
                    }else{
                        levelBoxButton.aspectScale(to: frame.size, width: true, multiplier: 0.4)
                        
                    }
                    
                    levelBoxButton.position = CGPoint(x: columnStartingPoint + CGFloat(column) * colgap * 2 + levelBoxButton.size.width *  CGFloat(column)  , y: rowStartingPoint - CGFloat(row+1) * levelBoxButton.size.height - CGFloat(row+1) * rowgap)
                    
                    
                counter += 1
                    }
            }
        }
    }
    
    func animateScene(_ completion: @escaping () -> Void){
        
         let actionPic = SKAction.move(by: CGVector(dx: 0, dy: -frame.height), duration: 1)
        actionPic.timingMode = .easeOut
        levelLayer.run(actionPic, completion: completion)
    }
    
    func goToGameSceneFor(level: Int) {
        print ("go to game \(level)")
        levelNo = level
        presentLearnExamPopup()
        
        
//        sceneManagerDelegate?.presentGameSceneFor(levelNo: level)
    }
    
    
    func presentLearnExamPopup() {
        
        let popup = LearnExamPopup( size: size, levelNo: levelNo)
                    popup.zPosition = 99
        popup.position = CGPoint(x: frame.midX, y:  frame.midY)
                    popup.learnExamPopupButtonHandlerDelegate = self
        popup.levelNo = levelNo
        levelLayer.addChild(popup)
        
//        let popup = Popup(type: 1,nextButton: 0, topScore: 10, size: size)
//        popup.zPosition = 1
//        popup.position = CGPoint(x: frame.midX, y:  frame.midY)
//        popup.popupButtonHandlerDelegate = self
//        levelLayer.addChild(popup)
    }

}

//
//extension LevelScene: PopupButtonHandlerDelegate {
//
//    func menuTapped() {
//        print ("menuTapped")
//        //sceneManagerDelegate?.presentLevelScene()
//    }
//
//    func nextTapped() {
//       print ("nextTapped")
//
//           // sceneManagerDelegate?.presentGameSceneFor(levelNo: levelNo + 1)
//
//    }
//
//    func retryTapped() {
//        print ("retryTapped")
//          //  sceneManagerDelegate?.presentGameSceneFor(levelNo: levelNo)
//    }
//
//    func levelTapped(level: Int){
//           // sceneManagerDelegate?.presentGameSceneFor(levelNo: levelNo)
//
//    }
//
//}



extension LevelScene: LearnExamPopupButtonHandlerDelegate {

    func learningTapped() {
        print ("Enter Learning")
//        sceneManagerDelegate?.presentLevelScene()
        sceneManagerDelegate?.presentExeciseSceneFor(levelNo: levelNo)
    }

    func examTapped() {
       print ("Enter Exam")
        sceneManagerDelegate?.presentGameSceneFor(levelNo: levelNo)
//
//            sceneManagerDelegate?.presentGameSceneFor(levelNo: levelNo + 1)
//
    }
    

}
