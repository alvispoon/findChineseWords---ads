//
//  Level.swift
//  chineseWordPuzzle
//
//  Created by Alvis Poon on 12/7/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//

import Foundation


let numColumns = 3
let numRows = 3


class Level {
    private var letters = Array2D<Letter>(columns: numColumns, rows: numRows)
    private var tiles = Array2D<Tile>(columns: numColumns, rows: numRows)
    
    var wordsList:[NSArray] = []
    var categoryList:[NSString] = []
    var words: [NSArray] = []
    var allWords = ""
    var completedWord : [Bool] = []
    
       
    var currentWord :Int = 0
    
    init() {
        for row in 0...numRows-1{
            for column in 0...numColumns-1{
                tiles[column, numRows - row - 1] = Tile()
            }
        }
        
        //1 find .plist file for this level
        let fileName = "wordList.plist"
        let levelPath = "\(Bundle.main.resourcePath!)/\(fileName)"
          
        //2 load .plist file
        let levelDictionary: NSDictionary? = NSDictionary(contentsOfFile: levelPath)
          
        //3 validation
        assert(levelDictionary != nil, "Level configuration file not found")
          
        //4 initialize the object from the dictionary
        self.wordsList = levelDictionary!["words"] as! [NSArray]
        currentWord = 0
        //print(self.words)
        
//        for word in words{
//            allWords += word[1] as! String
//            self.completedWord.append(false)
//        }
//        print (allWords)
        
        
        
        //1 find .plist file for this level
        let catfileName = "categoryList.plist"
       let catPath = "\(Bundle.main.resourcePath!)/\(catfileName)"
          
        //2 load .plist file
        let catDictionary: NSDictionary? = NSDictionary(contentsOfFile: catPath)
          
        //3 validation
        assert(catDictionary != nil, "cat configuration file not found")
          
        //4 initialize the object from the dictionary
        self.categoryList = catDictionary!["category"] as! [NSString]
       // currentWord = 0
        
        //print (categoryList[0] as! String)
        levelName()
    }
    
    func numOfLevel() -> Int{
        print ("numOfLevel")
        print (self.wordsList.count)
        return self.wordsList.count
    }
    
    func numOfQuestion() -> Int{
        return self.words.count
    }
    
    func levelName() -> [String]{
        guard let nsStringArray = self.categoryList as? [NSString] else {
               // Handle the case where self.categoryList is not an array of NSString
               return []
           }

           // Using map to transform each NSString to String
           let stringArray = nsStringArray.map { String($0) }
        print (stringArray[0])
           return stringArray
    }
    
    
    
    func selectedLevel(level : Int){
        print ("level \(level)")
        self.completedWord.removeAll()
        self.allWords = ""
        self.words = self.wordsList[level] as! [NSArray]
                print(self.words)
                
                for word in words{
                    allWords += word[1] as! String
                    self.completedWord.append(false)
                }
                print (allWords)
    }
    
    
    
    func checkfinish() -> Bool{
         if (!completedWord.contains(false)){
            self.completedWord.removeAll()
                        for index in 1...self.words.count {
                            self.completedWord.append(false)
                        }
                return true
        }else{
            return false
        }
    }
    
    func getWord(nextPrev : Int) -> String {
        var tempWord : String = ""
        print ("=========elf.words[currentWord][1]==========")
        print (self.words[currentWord][1])
        
        currentWord += nextPrev
        
        if (currentWord >= self.words.count){
                currentWord = 0
        }
        
        if (currentWord < 0){
            currentWord = self.words.count - 1
        }
        
        tempWord = self.words[currentWord][1] as! String
        
        return tempWord
        
    }
    
    
    
    
    func genPic() -> NSArray{
        
        var randomIndex = 0
        repeat {
            randomIndex = Int(arc4random_uniform(UInt32(self.words.count)))
        } while (completedWord[randomIndex])
        
        completedWord[randomIndex] = true

        
        let picNum = randomIndex
        print (self.words[picNum])
      
        return self.words[picNum]
    }
    
    func shuffle(answer: String) -> Set<Letter> {
      var set: Set<Letter>
        set = createInitialCookies(answer: answer)
      return set
    }
    
    func checkSuccess() -> (success: Bool, Score: Int){
        var score = 0
        for row in 0..<numRows {
            for column in 0..<numColumns {
                if let letter = letter(column: column, row: row) {
                    if (letter.correct == !letter.selected){
                        return (false, 0)
                    }
                    if (letter.correct){
                        score += 10
                    }
                }
            }
        }
        return (true, score)
    }
    

    private func createInitialCookies(answer: String) -> Set<Letter> {
        
        let answerLength = answer.count
        var rowOrCol = Bool.random()
        var startPosX = 0
        var startPosY = 0
        
        if (answerLength > numRows){
            rowOrCol = true
        }
        
        if rowOrCol{
            startPosX = Int(arc4random_uniform(UInt32(numColumns - answer.count)))
            startPosY = Int(arc4random_uniform(UInt32(numRows)))
        }else{
            startPosX = Int(arc4random_uniform(UInt32(numColumns)))
            startPosY = Int(arc4random_uniform(UInt32(numRows - answer.count)))
        }
        print (rowOrCol)
        print (startPosX)
        print (startPosY)
        
        var allFalseWords = allWords.replacingOccurrences(of: answer, with: "")
        for i in 0..<answer.count{
            allFalseWords = allFalseWords.replacingOccurrences(of: answer[i], with: "")
        }
        
        print (allFalseWords)
        
        var assigned = false
        var set: Set<Letter> = []
        for row in 0..<numRows {
          for column in 0..<numColumns {
            if tiles[column, row] != nil {
                assigned = false
                if rowOrCol{
                    print (row)
                    print (column)
                    print (startPosX)
                    print (startPosY)
                    print (answer.count)
                    if (column>=startPosX && column<startPosX+answer.count && row == startPosY){
                        let letter = Letter(column: column, row: row, letter: String(answer[column-startPosX]))
                        letter.correct = true
                        letters[column, row] = letter
                        set.insert(letter)
                        //print ("ROW ANSWER : \(column)\(row)\(answer[row-startPosX])")
                        assigned = true
                        let ansPos = String("\(column)\(row)")
                        //correctAnswerPos.append(ansPos)
                    }
                }else{
                    print (row)
                    print (column)
                    print (startPosX)
                    print (startPosY)
                    print (answer.count)
                    if (row>=startPosY && row<startPosY+answer.count && column == startPosX){
                        let letter = Letter(column: column, row: row, letter: String(answer[row-startPosY]))
                        letter.correct = true
                        letters[column, row] = letter
                        set.insert(letter)
                        //print ("COL ANSWER : \(column)\(row)\(answer[column-startPosY])")
                        assigned = true
                        let ansPos = String("\(column)\(row)")
                        //correctAnswerPos.append(ansPos)
                    }
                }
                if (!assigned){
                    let randomWord = Int(arc4random_uniform(UInt32(allFalseWords.count)))
                    let letter = Letter(column: column, row: row, letter: allFalseWords[randomWord])
                    
                      print ("\(column)\(row)\(allFalseWords[randomWord])")
                      letters[column, row] = letter
                      set.insert(letter)
                }
            }
          }
        }
        return set
      }
    
    func letter(column: Int, row: Int) -> Letter? {
      precondition(column >= 0 && column < numColumns)
      precondition(row >= 0 && row < numRows)
      return letters[column, row]
    }
    
   
    
  
}
