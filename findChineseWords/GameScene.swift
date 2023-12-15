//
//  GameScene.swift
//  chineseWordPuzzle
//
//  Created by Alvis Poon on 12/7/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    var sceneManagerDelegate: SceneManagerDelegate?
    
    let colors = [SKColor.yellow, SKColor.red, SKColor.blue, SKColor.purple]
    
   let selectedSound = SKAction.playSoundFileNamed("selected.wav", waitForCompletion: false)
   let successSound = SKAction.playSoundFileNamed("success.wav", waitForCompletion: true)
    let passSound = SKAction.playSoundFileNamed("pass.wav", waitForCompletion: false)
    let retrySound = SKAction.playSoundFileNamed("retry.wav", waitForCompletion: false)
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    private var scoreNumLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
    var score :Int = 0 {
          didSet {
              //custom setter - keep the score positive
              score = max(score, 0)
              self.scoreNumLabel.text = "\(score)"
          }
    }
    var tileWidth: CGFloat = 32.0
    var tileHeight: CGFloat = 32.0
    
    var speaker = SKSpriteNode()
    var chineseWord : String = ""
    
    let tilesLayer = SKNode()
    let cropLayer = SKCropNode()
    let maskLayer = SKNode()
    
    let pictureLayer = SKNode()
    let gameLayer = SKNode()
    let LetterLayer = SKNode()
    let HudLayer = SKNode()
    let menuLayer = SKNode()
    
    var picWidth : CGFloat = 0
    var picHeight : CGFloat = 0
    
    var level: Level!
    var levelNo: Int = 0
    
    private var selectionSprite = SKSpriteNode()
    
    let synthesizer = AVSpeechSynthesizer()

    var needle = SKShapeNode()
    var dots : [SKShapeNode] = []
    var circleRad : CGFloat = 0.0
    
    let countdownNum = 10
    
    var started = true
    var checkpoint = 0
    
    var countDownLabel = SKLabelNode()
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
      super.init(size: size)
        
        circleRad = size.width*0.25 >= size.height*0.15 ? size.width*0.15 : size.width*0.25
        print (size.width)
        print (size.height)
        print ("Circle Rad : \(circleRad)")
        
        backgroundColor = .black
      anchorPoint = CGPoint(x: 0.5, y: 0.5)
      
      addChild(gameLayer)
      addChild(pictureLayer)
        
        picWidth = size.width
        picHeight = picWidth
        let picLayerPostition = CGPoint(x: 0, y:circleRad)
        pictureLayer.position = picLayerPostition
          //pictureLayer.frame.backgroundColor = .yellow
        
      tileWidth = size.width*0.9 / CGFloat(numColumns)
      tileHeight = -size.height*0.45 / CGFloat(numColumns)
      
      let layerPosition = CGPoint(
        x: -tileWidth * CGFloat(numColumns) / 2,
        y:  -size.height/2)
      print ("Layer \(layerPosition)")
        
        let menuLayerPosition = CGPoint(
            x: 0,
          y: size.height*0.35)
        menuLayer.position = menuLayerPosition
        
        
      LetterLayer.position = layerPosition
        
      tilesLayer.position = layerPosition
      maskLayer.position = layerPosition
        
        
      HudLayer.position = CGPoint(x: 0, y:size.height*0.35)
        
        maskLayer.zPosition = 0
        HudLayer.zPosition = 1
        maskLayer.zPosition = 0
        cropLayer.zPosition = 1
        tilesLayer.zPosition = 3
        
        LetterLayer.zPosition = 4
        
        gameLayer.zPosition = 2
        
      //cropLayer.maskNode = maskLayer
        gameLayer.addChild(cropLayer)
      gameLayer.addChild(tilesLayer)
        addChild(menuLayer)
     addChild(HudLayer)
   
      cropLayer.addChild(LetterLayer)
      setupHud()
        
      //  cropLayer.addChild(picture)
        
       // addCircleObstacle()
       // addSpeaker()
       // runClockwise()
        //beginGame()
        addTiles()
        showMenu()
        
        
    }

    
    func setupHud(){
         let scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
         scoreLabel.fontSize = 30.0
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.text = "Score : "
        scoreLabel.zPosition = 10
        scoreLabel.position = CGPoint(x: 0, y:size.height*0.05)
        scoreLabel.aspectScale(to: size, width: false, multiplier: 0.05)
        HudLayer.addChild(scoreLabel)
             
         scoreNumLabel.fontSize = 30.0
         scoreNumLabel.verticalAlignmentMode = .center
                   scoreNumLabel.text = "0"
                        scoreNumLabel.zPosition = 10
        scoreNumLabel.position = CGPoint(x: 0, y:0)
                       scoreNumLabel.aspectScale(to: size, width: false, multiplier: 0.05)
        HudLayer.addChild(scoreNumLabel)
        
    }
    
    override func didMove(to view: SKView) {
    }
    
    func addTiles() {
      // 1
      for row in 0..<numRows {
        for column in 0..<numColumns {
            let tileNode = SKSpriteNode(imageNamed: "MaskTile.png")
            tileNode.size = CGSize(width: tileWidth, height: tileHeight)
            tileNode.position = pointFor(column: column, row: row)
            maskLayer.addChild(tileNode)
          
        }
      }
      
      // 2
      for row in 0...numRows {
        for column in 0...numColumns {
          let topLeft     = (column > 0) && (row < numRows)
          let bottomLeft  = (column > 0) && (row > 0)
          let topRight    = (column < numColumns) && (row < numRows)
          let bottomRight = (column < numColumns) && (row > 0)
          
         var value = (topLeft ? 1 : 0)
          value = value | (topRight ? 1 : 0) << 1
          value = value | (bottomLeft ? 1 : 0) << 2
          value = value | (bottomRight ? 1 : 0) << 3

            if value != 0 && value != 6 && value != 9 {
            let name = String(format: "Tile_%ld", value)
            //print (name)
            let tileNode = SKSpriteNode(imageNamed: name)
            tileNode.size = CGSize(width: tileWidth, height: tileHeight)
            var point = pointFor(column: column, row: row)
            point.x -= tileWidth / 2
            point.y -= tileHeight / 2
            tileNode.position = point
            tilesLayer.addChild(tileNode)
          }
        }
      }
    }
    
        func addCircleObstacle() {
            
            let zeroAngle : CGFloat = CGFloat(Double.pi / 2)
            
            let path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: circleRad, startAngle: zeroAngle, endAngle: zeroAngle - CGFloat (Double.pi * 2), clockwise: false)
            
            let lock = SKShapeNode(path: path.cgPath)
            lock.strokeColor = SKColor.yellow
            lock.lineWidth = circleRad  * 0.3
            //lock.position = CGPoint(x: 0, y: size.height/4)
            pictureLayer.addChild(lock)
            
             needle = SKShapeNode(rectOf: CGSize (width: 40.0 - 7.0, height: 7.0), cornerRadius: 3.5)
            needle.fillColor = SKColor.red
            needle.position = CGPoint(x: 0, y: size.width * 0.25)
            needle.zRotation = 3.14 / 2
            needle.zPosition = 2
            pictureLayer.addChild(needle)
            
            
            
            countDownLabel = SKLabelNode(fontNamed: "GillSans-Bold")
            
            
            countDownLabel.fontSize = 30
            countDownLabel.text = String(format: "%ld", countdownNum)
            //countDownLabel.anchorPoint = CGPoint(x: 0.5, y: 0.5)
              
              countDownLabel.fontColor = .red
            countDownLabel.fontSize *= size.width * 0.2 / countDownLabel.frame.width
            countDownLabel.position = CGPoint(x: 0, y: -countDownLabel.frame.height/2)
              print (LetterLayer.position)
            countDownLabel.zPosition = 300
            pictureLayer.addChild(countDownLabel)
              setCheckPoint()
            
//
//          let path = UIBezierPath()
//          path.move(to: CGPoint(x: 0, y: -200))
//          path.addLine(to: CGPoint(x: 0, y: -160))
//          path.addArc(withCenter: CGPoint.zero,
//                      radius: 160,
//                      startAngle: CGFloat(3.0 * M_PI_2),
//                      endAngle: CGFloat(0),
//                      clockwise: true)
//          path.addLine(to: CGPoint(x: 200, y: 0))
//          path.addArc(withCenter: CGPoint.zero,
//                      radius: 200,
//                      startAngle: CGFloat(0.0),
//                      endAngle: CGFloat(3.0 * M_PI_2),
//                      clockwise: false)
//
//          let obstacle = obstacleByDuplicatingPath(path, clockwise: true)
//    //      obstacle.position = CGPoint(x: size.width/2, y: size.height/2)
//
//
//            obstacle.position = CGPoint(x: 0, y: 250)
//
//            addChild(obstacle)
//
//            let rotateAction = SKAction.rotate(byAngle: 2.0 * CGFloat(M_PI), duration: 8.0)
//            obstacle.run(SKAction.repeatForever(rotateAction))

        }
    
    
    func setCheckPoint(){
        checkpoint = 0
        dots.removeAll()
        for i in 1...countdownNum{
            let  dot  = SKShapeNode(circleOfRadius: circleRad*0.1)
            dot.fillColor = SKColor.yellow
            dot.strokeColor = .clear
            var angle = 90.0
            print (angle)
            print ( Double(360 / countdownNum * i))
            angle = angle -  Double(360 / countdownNum * i)
            print (angle)
            var zeroAngle = CGFloat(Double.pi * angle / 180.0)
            print (zeroAngle)
            print (i)
            let path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: circleRad, startAngle: zeroAngle, endAngle: zeroAngle - CGFloat (Double.pi * 2), clockwise: false)
            dot.position = path.currentPoint
            pictureLayer.addChild(dot)
            dots.append(dot)
        }
        runClockwise()
        
        
    }
    
    func runClockwise(){
        
        let zeroAngle : CGFloat = CGFloat(Double.pi / 2)
                 
        
           let dx = needle.position.x - size.width/2
           let dy = needle.position.y - size.height/2
           
           let radian = atan2(dy, dx)
           print ("clockwise")
           print(radian)
           print(Double.pi)
           
          // let path = UIBezierPath(arcCenter: CGPoint(x: 0, y: size.height * 0.23), radius: size.width * 0.25, startAngle: zeroAngle, endAngle: zeroAngle - CGFloat (Double.pi * 2), clockwise: false)

           let path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: circleRad, startAngle: zeroAngle, endAngle: zeroAngle - CGFloat (Double.pi * 2), clockwise: false)
//
//            UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 120, startAngle: radian, endAngle: radian - CGFloat (Double.pi * 2), clockwise: false)
           
           let run = SKAction.follow(path.cgPath, asOffset: false, orientToPath: true, duration: 15.0)
        
           needle.run(run, withKey: "timer")
        checkpoint = 0
            started = true
        
            print(started)
       }
//
//    func obstacleByDuplicatingPath(_ path: UIBezierPath, clockwise: Bool) -> SKNode {
//      let container = SKNode()
//
//      var rotationFactor = CGFloat(M_PI_2)
//      if !clockwise {
//        rotationFactor *= -1
//      }
//
//      for i in 0...3 {
//        let section = SKShapeNode(path: path.cgPath)
//        section.fillColor = colors[i]
//        section.strokeColor = colors[i]
//        section.zRotation = rotationFactor * CGFloat(i);
//
//
//        container.addChild(section)
//      }
//      return container
//    }

    func addSpeaker(){
                  speaker = SKSpriteNode()
                  speaker.name = "SPEAK"
                  speaker.size = CGSize(width: picWidth*0.1, height: picWidth*0.1)
                  speaker.texture = SKTexture(imageNamed: "speaker1.png")
                    
                  let speakSize = CGSize(width: picWidth*0.1, height: picWidth*0.1)
                  speaker.aspectFillToSize(fillSize: speakSize)
                  speaker.position = CGPoint(x: size.width/2 - picWidth*0.1/2 ,y:-circleRad+picWidth*0.1)
                  pictureLayer.addChild(speaker)
                  
      }
  
    
    func showPic(wordPair: NSArray){
        let word = wordPair[0] as! String
        print (word)
//        let picture = SKSpriteNode()
//        picture.name = "PIC"
//        picture.size = CGSize(width: picWidth, height: picHeight)
//        picture.texture = SKTexture(imageNamed: "\(word).png")
//        let picSize = CGSize(width: picWidth, height: picHeight)
//        picture.aspectFillToSize(fillSize: picSize)

        //pictureLayer.addChild(picture)
       addSpeaker()
        addCircleObstacle()
        
        
        
        let wordChinese = wordPair[1] as! String
        chineseWord = wordChinese
        speak(word: wordChinese)
    }
    
    func showMenu(){
        
        let buttonlength = size.width*0.8/5
        
        var backtoHomeButton = SKSpriteNode()
        backtoHomeButton.name = "HOME"
        backtoHomeButton.size = CGSize(width: size.width*0.5, height: size.width*0.5)
        backtoHomeButton.texture = SKTexture(imageNamed: "BackHome.png")
        let picSize = CGSize(width: buttonlength*0.9, height: buttonlength*0.9)
        backtoHomeButton.position = CGPoint(x: -size.width*0.5+buttonlength*0.7, y: -buttonlength)
        backtoHomeButton.position = CGPoint(x: -size.width/2 + buttonlength*0.7, y:size.height*0.05)
        backtoHomeButton.aspectFillToSize(fillSize: picSize)
        
//
//        speaker = SKSpriteNode()
//        speaker.name = "SPEAK"
//        speaker.size = CGSize(width: picWidth*0.1, height: picWidth*0.1)
//        speaker.texture = SKTexture(imageNamed: "speaker1.png")
//
//        let speakSize = CGSize(width: picWidth*0.1, height: picWidth*0.1)
//        speaker.aspectFillToSize(fillSize: speakSize)
//        speaker.position = CGPoint(x: size.width/2 - picWidth*0.1/2 ,y:-circleRad+picWidth*0.1)
        
        
        menuLayer.addChild(backtoHomeButton)
    }
    
    

    func addSprites(for letters: Set<Letter>) {
        
      for letter in letters {

        let sprite = LetterCard(letter: letter.letter, sideLength: tileWidth)
        sprite.size = CGSize(width: tileWidth, height: tileHeight)
        sprite.position = pointFor(column: letter.column, row: letter.row)
        
        letter.sprite = sprite
        LetterLayer.addChild(sprite)

        sprite.alpha = 0
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        //addCircleObstacle()
        sprite.run(
          SKAction.sequence([
            SKAction.wait(forDuration: 0.25, withRange: 0.5),
            SKAction.group([
              SKAction.fadeIn(withDuration: 0.25),
              SKAction.scale(to: 1.0, duration: 0.25)
              ])
            ]))
        
      }
    }

    private func pointFor(column: Int, row: Int) -> CGPoint {
      return CGPoint(
        x: CGFloat(column) * tileWidth + tileWidth / 2,
        y: CGFloat(row) * tileHeight + tileHeight / 2)
    }
    
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            // 1
        print ("touchB egin")
        guard let touch = touches.first else { return }
        var touchLocation = CGPoint()
        touchLocation = touch.location(in: self)
        let touchNode = atPoint(touchLocation)
        if touchNode != nil{
            if touchNode.name != nil{
                if touchNode.name! == "SPEAK"{
                    print ("Speak")
                    speak(word: chineseWord)
                    return
                    }
                if touchNode.name! == "HOME"{
                    print ("HOME")
                    sceneManagerDelegate?.presentLevelScene()
                    return
                    }
                
                }
            
        
            
        }
        let location = touch.location(in: LetterLayer)
        // 2
        let (success, column, row) = convertPoint(location)
        if success {
          // 3
        
            if let letter = level.letter(column: column, row: row) {
            // 4
                showSelectionIndicator(letter: letter)
                let selectedPos = "\(column)\(row)"
                run(selectedSound)
                checkSuccess()
          }
        }
    }
    
    func animateScore(score: Int , completion: @escaping () -> Void) {
      
      // Add a label for the score that slowly floats up.
      let scoreLabel = SKLabelNode(fontNamed: "GillSans-Bold")
      scoreLabel.fontSize = 30
      scoreLabel.text = String(format: "%ld", score)
        scoreLabel.fontColor = .blue
        scoreLabel.fontSize *= size.width * 0.2 / scoreLabel.frame.width
        scoreLabel.position = CGPoint(x: 0, y: -scoreLabel.frame.height/2)

        scoreLabel.zPosition = 300
      pictureLayer.addChild(scoreLabel)
        print ("score \(score)")
      let moveAction = SKAction.move(by: CGVector(dx:0 , dy: size.width*0.35), duration:1)
      moveAction.timingMode = .easeOut
        scoreLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]), completion: {
            completion()
        })
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is renderednt
//        print("ABC")
//        print(started)
        
        if started{
            if checkpoint == countdownNum{
                started = false
                timeout()
            }
        }
        
//        if (started && checkpoint == countdownNum){
//            print ("Fail")
//            timeout()
//            //started = false
//            checkpoint += 1
//            print ("update checkpoint to \(checkpoint)")
//        }
//
//        print(started)
//        print (checkpoint)
        if (started && checkpoint < dots.count){
              
                   if needle.intersects(dots[checkpoint]){
                       print ("intersect")
                       print ("Checkpoint  \(checkpoint)")
                       checkpoint+=1
                       countDownLabel.text = String(format: "%ld", countdownNum - checkpoint)
                       
                       }
                   }
    }
    
    private func convertPoint(_ point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        print (point.y)
        print (Int(-point.y / tileHeight))
    if point.x >= 0 && point.x < CGFloat(numColumns) * tileWidth &&
        point.y <= 0 && point.y > CGFloat(numRows) * tileHeight {
        return (true, Int(point.x / tileWidth), Int(point.y / tileHeight))
      } else {
        return (false, 0, 0)  // invalid location
      }
    }
    
    
    func hideSelectionIndicator() {
       selectionSprite.run(SKAction.sequence([
         SKAction.fadeOut(withDuration: 0.3),
         SKAction.removeFromParent()]))
     }
    
    func timeout(){
        print ("timeout")
        self.view?.isUserInteractionEnabled = false
        beginGame()
        //updateScoreAndNext(addScore: -10)
        
    }
    
    func checkSuccess() {
        let (success, score) = level.checkSuccess()
        if (success){
            needle.removeAction (forKey:"timer")
            self.view?.isUserInteractionEnabled = false
            run(successSound)
            let addScore = (countdownNum - checkpoint) 
            animateScore(score: addScore) {
                    self.updateScoreAndNext(addScore: addScore)

            }
            
        }
    }
    
     
     func showSelectionIndicator(letter: Letter) {

        letter.selected = !letter.selected
        
        var texture : SKTexture
        if (letter.selected){
            texture   = SKTexture(imageNamed: letter.highlightedSpriteName)
                  
        }else{
            texture = SKTexture(imageNamed: letter.SpriteName)
        }
        if let sprite = letter.sprite {
                            //selectionSprite.size = CGSize(width: tileWidth, height: tileHeight)
                          sprite.run(SKAction.setTexture(texture))
                 
                          //sprite.addChild(selectionSprite)
        
                          sprite.alpha = 1.0
            }
//       if selectionSprite.parent != nil {
//         selectionSprite.removeFromParent()
//       }
//
//       if let sprite = letter.sprite {
//         let texture = SKTexture(imageNamed: letter.highlightedSpriteName)
//         selectionSprite.size = CGSize(width: tileWidth, height: tileHeight)
//         selectionSprite.run(SKAction.setTexture(texture))
//
//         sprite.addChild(selectionSprite)
//         selectionSprite.alpha = 1.0
//       }
     }
    func removeAllLetterPicSprites() {
      LetterLayer.removeAllChildren()
      pictureLayer.removeAllChildren()
    }
    
    func animateBeginGame(_ completion: @escaping () -> Void) {
      gameLayer.isHidden = false
      gameLayer.position = CGPoint(x: 0, y: size.height)
        
        pictureLayer.isHidden = false
        pictureLayer.position = CGPoint(x: 0, y: size.height)
        
      let action = SKAction.move(by: CGVector(dx: 0, dy: -size.height/2), duration: 0.3)
      action.timingMode = .easeOut
      gameLayer.run(action, completion: completion)
       
        let actionPic = SKAction.move(by: CGVector(dx: 0, dy: -size.height+circleRad+circleRad*0.4), duration: 0.3)
       actionPic.timingMode = .easeOut
       pictureLayer.run(actionPic, completion: completion)
    }
    
    func animateGameOver(_ completion: @escaping () -> Void) {
      let action = SKAction.move(by: CGVector(dx: 0, dy: -size.height), duration: 0.3)
      action.timingMode = .easeIn
      gameLayer.run(action, completion: completion)
        
        let actionPic = SKAction.move(by: CGVector(dx: 0, dy: -size.height-size.width*0.3), duration: 0.3)
        actionPic.timingMode = .easeIn
        pictureLayer.run(actionPic, completion: completion)

    }
    
    func presentPopup(victory: Bool, topScore: Int, currentScore: Int) {
        if victory {
            let popup = Popup(type: 0,nextButton: levelNo<level.numOfLevel()-1 ? 1 : 0, topScore: topScore, currentScore: currentScore, size: size)
            popup.zPosition = 1
            popup.popupButtonHandlerDelegate = self
            addChild(popup)
        } else {
            let popup = Popup(type: 1,nextButton: 0, topScore: topScore, currentScore: currentScore, size: size)
            popup.zPosition = 1
            popup.popupButtonHandlerDelegate = self
            addChild(popup)
        }
    }
    
    func showPic() -> String{
        let pic = level.genPic()
        showPic(wordPair: pic)
        return pic[1] as! String
    }

    func shuffle(answer: String) {
        print ("Shuffle \(answer)")
        let newLetters = level.shuffle(answer: answer)
        addSprites(for: newLetters)
    }
    
    func showPassOrFail(){
        print ("showPassOrFail")
        
        self.view?.isUserInteractionEnabled = true
        let defaults = UserDefaults.standard
        var topScoreinSystem = defaults.integer(forKey: "level_\(levelNo)")
        if (topScoreinSystem < score){
            defaults.set(score, forKey: "level_\(levelNo)")
            topScoreinSystem = score
        }
        var passLevel = defaults.integer(forKey: .passLevel)
        let maxScore = level.numOfQuestion() * (countdownNum - 1)
        
        
      //  if (score > maxScore / 3){
            print ("Stage Clear")
            defaults.set("1", forKey: "PassLevel_\(levelNo)")
            print ("levelNo \(levelNo)")
            print ("passLevel \(passLevel)")
            if (levelNo+1 >= passLevel){
                 defaults.set(levelNo+1, forKey: .passLevel)
            }
            run(passSound)
            presentPopup(victory: true, topScore: topScoreinSystem, currentScore: score)
      //  }else{
      //      print ("try agian")
      //      run(retrySound)
      //      presentPopup(victory: false, topScore: Int(maxScore / 3), currentScore: )
      //  }
        
        
        
        animateGameOver {
            //self.victoryPanel.isHidden = false
            //self.nextButton.isHidden = false
//            self.scoreLabel.isHidden = true
//            self.scoreTitleLabel.isHidden = true
//            self.victoryview.showVictory(topScore: topScoreinSystem, currentScore: self.score)
            
        }
        AppStoreReviewManager.requestReviewIfAppropriate()
    }
    
    func updateScoreAndNext(addScore: Int){
        print ("updateScore")
        score += addScore
        //scoreNumLabel.text = "\(score)"
        //self.updateScore()
        print ("Enter beginGame")
        beginGame()
    }
    
        func beginGame() {
            print ("BEGIN GAME 1")
          removeAllLetterPicSprites()
            print ("REMOVE ALL LETTER")
            
          if level.checkfinish(){
            //victoryPanel.isHidden = false
    //        //nextButton.isHidden = false
    //             self.victoryview.isHidden = false
    //             self.view.isUserInteractionEnabled = true
            showPassOrFail()
            
            }else{
            let answer = showPic()
                animateBeginGame {
            }
                shuffle(answer: answer)
                self.view?.isUserInteractionEnabled = true
                
                   
            }
         
        }
    
    
    func speak(word: String){
    print ("Click image view")
            
            let utterance = AVSpeechUtterance(string: word)
            utterance.voice = AVSpeechSynthesisVoice(language: "zh-HK")
            //utterance.rate = Float(0.8)
            //utterance.pitchMultiplier = 0.5
            //utterance.preUtteranceDelay = 0
            utterance.volume = 1
            synthesizer.speak(utterance)
        }
    
    
    
    
}



extension GameScene: PopupButtonHandlerDelegate {
    
    func menuTapped() {
        print ("menuTapped")
        sceneManagerDelegate?.presentLevelScene()
    }
    
    func nextTapped() {
       print ("nextTapped")
        
            sceneManagerDelegate?.presentGameSceneFor(levelNo: levelNo + 1)
       
    }
    
    func retryTapped() {
        print ("retryTapped")
            sceneManagerDelegate?.presentGameSceneFor(levelNo: levelNo)
    }
    
    func levelTapped(level: Int){
            sceneManagerDelegate?.presentGameSceneFor(levelNo: levelNo)
    
    }

}
