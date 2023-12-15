//
//  LetterCard.swift
//  chineseWordPuzzle
//
//  Created by Alvis Poon on 12/7/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//

import SpriteKit

class LetterCard: SKSpriteNode {
    
    var letter: String
    var sideLength : CGFloat = 0
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func adjustLabelFontSizeToFitRect(labelNode:SKLabelNode) {
        let scalingFactor = min(self.size.width / labelNode.frame.width, self.size.height / labelNode.frame.height)
        labelNode.fontSize *= scalingFactor
    }
    
    init(letter:String, sideLength:CGFloat) {
        self.letter = letter
        let texture = SKTexture(imageNamed: "blockR.png")
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: sideLength, height: sideLength))
        var numLabel = SKLabelNode(fontNamed: "AmericanTypeWriter-Bold")
        numLabel.text = letter
        numLabel.fontSize = 40
        numLabel.fontColor = .white
        numLabel.verticalAlignmentMode = .center
        numLabel.position = CGPoint (x:0,y:0)
        numLabel.name = letter
        numLabel.zPosition = 2
        numLabel.aspectScale(to: self.size, width: true, multiplier: 0.5)
        addChild(numLabel)

    }
    

    
    
}
