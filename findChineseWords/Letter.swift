//
//  Letter.swift
//  chineseWordPuzzle
//
//  Created by Alvis Poon on 12/7/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//

import SpriteKit

class Letter: CustomStringConvertible, Hashable {
  
  var hashValue: Int {
    return row * 10 + column
  }
  
  static func ==(lhs: Letter, rhs: Letter) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
    
  }
 
  var description: String {
    return "type:\(letter) square:(\(column),\(row))"
  }
    
    
    var highlightedSpriteName: String {
      return  "blockO"
    }
  var SpriteName: String {
    return  "blockR"
  }
  var column: Int
  var row: Int
  let letter: String
    var correct: Bool
    var selected: Bool
  var sprite: SKSpriteNode?
  
  init(column: Int, row: Int, letter: String) {
    self.column = column
    self.row = row
    self.letter = letter
    self.correct = false
    self.selected = false
  }
}
