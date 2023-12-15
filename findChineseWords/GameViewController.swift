//
//  GameViewController.swift
//  chineseWordPuzzle
//
//  Created by Alvis Poon on 12/7/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


protocol SceneManagerDelegate {
    func presentMenuScene()
    func presentLevelScene()
    func presentExeciseSceneFor(levelNo: Int)
    func presentGameSceneFor(levelNo: Int)
}

class GameViewController: UIViewController {
    
    var level: Level!
    var scene: GameScene!
    
    var score = 0
    
    
   var victoryview : ScoreBoard!
    var levelview: LevelBoard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        level = Level()
        presentMenuScene()
        //presentGameSceneFor(levelNo: 0)
        
//         // Configure the view
//         let skView = view as! SKView
//         skView.isMultipleTouchEnabled = false
//
//         // Create and configure the scene.
//         scene = GameScene(size: skView.bounds.size)
//         scene.scaleMode = .aspectFill
//
//         scene.level = level
//        scene.showWin = showWin
//        scene.updateScoreAndNext = updateScoreAndNext
//         // Present the scene.
//
//        level.selectedLevel(level: 1)
//
//         skView.presentScene(scene)
//
//         scene.addTiles()
//
//
//        beginGame()
//
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    
    
    
    
    @IBAction func nextButton(_ sender: Any) {
    
    }
    
    func updateScore() {
//      
//      scoreLabel.text = String(format: "%ld", score)
    }
    
//
//    func showGameLevel() {
//        shuffleButton.isHidden = true
//
//        gameOverPanel.isHidden = false
//        scene.isUserInteractionEnabled = false
//
//        scene.animateGameOver {
//          self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideGameOver))
//          self.view.addGestureRecognizer(self.tapGestureRecognizer)
//        }
//      }
//
//      @objc func hideGameLevel() {
//        view.removeGestureRecognizer(tapGestureRecognizer)
//        tapGestureRecognizer = nil
//
//        gameOverPanel.isHidden = true
//        scene.isUserInteractionEnabled = true
//
//        setupLevel(number: currentLevelNumber)
//    //    beginGame()
//      }
//
    
}


extension GameViewController: SceneManagerDelegate {
    
    func presentMenuScene() {
        print ("presentMenuScene")
        let skView = view as! SKView
        let menuScene = MenuScene(size: skView.bounds.size)
        menuScene.sceneManagerDelegate = self
        present(scene: menuScene)
    }
    
    func presentLevelScene() {
        let skView = view as! SKView
        let levelScene = LevelScene(size: skView.bounds.size)
        levelScene.sceneManagerDelegate = self
        levelScene.level = level
        present(scene: levelScene)
    }
    
    func presentExeciseSceneFor(levelNo: Int) {
        print ("enter game scene \(levelNo)")
        let skView = view as! SKView
        
        let execiseScene = LearnScene(size: skView.bounds.size)
        execiseScene.sceneManagerDelegate = self
        execiseScene.scaleMode = .aspectFill
        level.selectedLevel(level: levelNo)
        execiseScene.level = level
        execiseScene.levelNo = levelNo
        execiseScene.showNext = showNext
        execiseScene.showPrev = showPrev
       //  skView.presentScene(scene)
        present(scene: execiseScene)
        execiseScene.beginGame()
//
//
//        let gameScene = GameScene(size: skView.bounds.size)
//            gameScene.sceneManagerDelegate = self
//            //gameScene.level = level
//            level.selectedLevel(level: levelNo)
//            gameScene.level = level
//            gameScene.levelNo = levelNo
//
//            if (level == nil){
//                print ("level nil")}
//            else{
//            print ("level not null")}
//
//            present(scene: gameScene)
//            gameScene.beginGame()
//
    }
    
    func presentGameSceneFor(levelNo: Int) {
        print ("enter game scene \(levelNo)")
        let skView = view as! SKView
        let gameScene = GameScene(size: skView.bounds.size)
            gameScene.sceneManagerDelegate = self
            //gameScene.level = level
            level.selectedLevel(level: levelNo)
            gameScene.level = level
            gameScene.levelNo = levelNo
        
            if (level == nil){
                print ("level nil")}
            else{
            print ("level not null")}
            
            present(scene: gameScene)
            gameScene.beginGame()
           
    }
    
    func present(scene: SKScene) {
        if let view = self.view as! SKView? {
            if let gestureRecognizers = view.gestureRecognizers {
                for recognizer in gestureRecognizers {
                    view.removeGestureRecognizer(recognizer)
                }
            }
            let reveal = SKTransition.reveal(with: .down,
            duration: 1)
            scene.scaleMode = .aspectFill
                                    
            view.presentScene(scene, transition: reveal)
            view.ignoresSiblingOrder = true
        }
    }
    
    
    
    func showNext(){
        print ("showNext")
//        counter = counter + 1
//        if (counter>=level.getTotalWords()){
//            counter = 0}
//
    }
    
    func showPrev(){
        print ("ShowPrev")
//        counter = counter - 1
//        if (counter<0){
//            counter = level.getTotalWords() - 1}
//
    }
    
    func beginGame() {
//        let pic = level.getPic(PicNo: counter)
//
//        scene.showPic(wordPair: pic)
////      print ("answer \(answer)")
////      scene.animateBeginGame { }
////      victoryPanel.isHidden = true
////      nextButton.isHidden = true
//
        self.view.isUserInteractionEnabled = true
    }
    
}
