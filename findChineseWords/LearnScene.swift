//
//  LearnScene.swift
//  findChineseWords
//
//  Created by Alvis Poon on 17/11/2023.
//  Copyright © 2023 Alvis Poon. All rights reserved.
//


import SpriteKit
import GameplayKit
import AVFoundation

class LearnScene: SKScene {
    
    var sceneManagerDelegate: SceneManagerDelegate?
    
    var showNext: (() -> Void)?
    var showPrev: (() -> Void)?
    
    let menuLayer = SKNode()
    let speakerLayer = SKNode()
    let gameLayer = SKNode()
    let textLayer = SKNode()
    let controlLayer = SKNode()
    var picWidth : CGFloat = 0
    var picHeight : CGFloat = 0
    
    var picture = SKSpriteNode()

    let synthesizer = AVSpeechSynthesizer()
    
    var tileWidth: CGFloat = 32.0
    var tileHeight: CGFloat = 32.0
    
    var numLabel = SKLabelNode(fontNamed: "AmericanTypeWriter-Bold")
    var wordChinese: String = "" {
          didSet {
              
              self.numLabel.text = wordChinese
                
          }
    }
    
    
    var level: Level!
    var levelNo: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder) is not used in this app")
    }
    
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = .black
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
      
        
        
        addChild(gameLayer)
       // addChild(pictureLayer)
//
//        if (size.width < size.height/2){
//            picWidth = size.width*0.5
//        }else{
//            picWidth = size.height/2*0.7
//        }
//        picHeight = picWidth
//        let picLayerPostition = CGPoint(x: 0, y:picHeight/2)
//        pictureLayer.position = picLayerPostition
//
//        tileWidth = size.width*0.9 / CGFloat(numColumns)
//        tileHeight = -size.height*0.45 / CGFloat(numColumns)
//
//        if (tileWidth<tileHeight){
//            tileHeight = tileWidth
//        }else{
//            tileWidth = tileHeight
//        }
//
        let textLayerPosition = CGPoint(
            x: 0,
            y: size.height / 5)
        
        textLayer.position = textLayerPosition
        gameLayer.addChild(textLayer)
        gameLayer.addChild(speakerLayer)
        
        let speakerLayerPosition = CGPoint(
            x:0, y:-size.height/8)
        
        
        
        let controlLayerPosition = CGPoint(
            x: 0,
          y: -size.height/3)
        
        controlLayer.position = controlLayerPosition
        //let controlLayerPosition = CGPoint(x: 0, y:picHeight/2)
        speakerLayer.position = speakerLayerPosition
        
        let menuLayerPosition = CGPoint(
            x: 0,
          y: size.height/2)
        menuLayer.position = menuLayerPosition
          
        gameLayer.addChild(controlLayer)
        gameLayer.addChild(menuLayer)
        
        showSpeaker()
        showLRSButton()
        showMenu()
    }
    
    
    func showPic(){
//        pictureLayer.removeAllChildren()
        textLayer.removeAllChildren()
        
//        let word = wordPair[0] as! String
//        print (word)
//        picture = SKSpriteNode()
//        picture.name = "PIC"
//        picture.size = CGSize(width: picWidth, height: picHeight)
//        picture.texture = SKTexture(imageNamed: "\(word).png")
//        let picSize = CGSize(width: picWidth, height: picHeight)
//        picture.aspectFillToSize(fillSize: picSize)
//
//        pictureLayer.addChild(picture)
        //controlLayer.addChild(picture)
        wordChinese = level.getWord(nextPrev: 0)
        print ("=======WordChinese=======")
        print (wordChinese)
        
        numLabel.text = wordChinese
        numLabel.fontSize = 40
        numLabel.fontColor = .white
        numLabel.verticalAlignmentMode = .center
        numLabel.position = CGPoint (x:0,y:0)
        numLabel.name = wordChinese
        numLabel.zPosition = 2
        
        numLabel.aspectScale(to: size , width: true, multiplier: 0.3*CGFloat(wordChinese.count))
        textLayer.addChild(numLabel)
        
        speak(word: wordChinese)
    }
    
    
    func showMenu(){
        
        let buttonlength = size.width*0.8/5
        
        var backtoHomeButton = SKSpriteNode()
        backtoHomeButton.name = "Home"
        backtoHomeButton.size = CGSize(width: size.width*0.5, height: size.width*0.5)
        backtoHomeButton.texture = SKTexture(imageNamed: "BackHome.png")
        let picSize = CGSize(width: buttonlength*0.9, height: buttonlength*0.9)
        backtoHomeButton.position = CGPoint(x: -size.width*0.5+buttonlength*0.5, y: -buttonlength)
        backtoHomeButton.aspectFillToSize(fillSize: picSize)
        
        menuLayer.addChild(backtoHomeButton)
    }
    
    
    func showSpeaker(){
        
        var speakButton = SKSpriteNode()
        speakButton.name = "Speak"
        speakButton.size = CGSize(width: size.width*0.4, height: size.width*0.4)
        speakButton.texture = SKTexture(imageNamed: "Speaker.png")
        speakButton.position = CGPoint(x: 0, y: 0)
        //speakButton.aspectFillToSize(fillSize: picSize)
        
        speakerLayer.addChild(speakButton)
    }
    
    func showLRSButton(){
        
        let buttonlength = size.width*0.8/3
        
        var leftButton = SKSpriteNode()
        leftButton.name = "Left"
        leftButton.size = CGSize(width: buttonlength*0.9, height: buttonlength*0.9)
        leftButton.texture = SKTexture(imageNamed: "PrevButton.png")
        let picSize = CGSize(width: buttonlength*0.9, height: buttonlength*0.9)
        leftButton.position = CGPoint(x: -buttonlength, y: 0)
        leftButton.aspectFillToSize(fillSize: picSize)
        
        controlLayer.addChild(leftButton)
        //controlLayer.addChild(picture)
        
        
        var rightButton = SKSpriteNode()
        rightButton.name = "Right"
        rightButton.size = CGSize(width: buttonlength*0.9, height: buttonlength*0.9)
        rightButton.texture = SKTexture(imageNamed: "NextButton1.png")
        rightButton.position = CGPoint(x: buttonlength, y: 0)
        rightButton.aspectFillToSize(fillSize: picSize)
        
        controlLayer.addChild(rightButton)
        
        
    }
    
    func speak(word: String){
    
            let utterance = AVSpeechUtterance(string: word)
            utterance.voice = AVSpeechSynthesisVoice(language: "zh-HK")
            //utterance.rate = Float(0.8)
            //utterance.pitchMultiplier = 0.5
            //utterance.preUtteranceDelay = 0
            utterance.volume = 1
            synthesizer.speak(utterance)
        }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
           
            let touchLocation = t.location(in: self)
            let touchNode = atPoint(touchLocation)
            if touchNode != nil{
                if let name = touchNode.name{
                if (name == "Right"){
                    wordChinese = level.getWord(nextPrev: 1)
                    speak(word: wordChinese)
//                    if let showNext = self.showNext{
//                        showNext()
//                    }
                }
                else if (name == "Left"){
                    wordChinese = level.getWord(nextPrev: -1)
                    speak(word: wordChinese)
//                    if let showPrev = self.showPrev{
//                            showPrev()
//                        }
                    }
                else if (name == "Speak"){
                    speak(word: wordChinese)
                    }
                else if (name == "Home"){
                        print ("Go back home")
                    sceneManagerDelegate?.presentLevelScene()
                        }
            }
            
            
        }
        }
    }

    func beginGame() {
        print ("BEGIN GAME 1")
      //removeAllLetterPicSprites()
        showPic()
     
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        return
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        return
    }
}
