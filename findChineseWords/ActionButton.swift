//
//  ActionButton.swift
//  LearnWord123
//
//  Created by Alvis Poon on 30/5/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//

import UIKit



class ActionButton:UIButton {
    
   // var defaultButton: UIButton
    var action: (Int) -> ()
    var level: Int

    required init(coder aDecoder:NSCoder) {
      fatalError("use init(letter:, sideLength:")
    }
    
    
    init(defaultButtonImage: String, defaultTitle: String, action: @escaping (Int) -> (), level: Int, width: CGFloat, height: CGFloat) {
        //defaultButton = UIButton()
        self.action = action
        self.level = level
        super.init(frame:  CGRect(x: 0, y: 0, width: 10, height: 10))
        
        self.setTitle(defaultTitle, for: .normal)
        self.titleLabel?.font = UIFont(name:"Baskerville-SemiBoldItalic" , size: 40.0)!
        self.setBackgroundImage(UIImage(named: defaultButtonImage), for: .normal)
        self.alpha = 1
        
//        super.init(frame: defaultButton.frame)
        self.isUserInteractionEnabled = true
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alpha = 0.75
    }
    

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //self.touchesMoved(touches, with: event)
        action(level)
        self.alpha = 1.0
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
       self.alpha = 1.0
    }
    
    
}
