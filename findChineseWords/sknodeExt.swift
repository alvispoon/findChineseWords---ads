//
//  sknodeExt.swift
//  findChineseWords
//
//  Created by Alvis Poon on 2/9/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//

import SpriteKit

extension SKNode {
    
    func aspectScale(to size: CGSize, width: Bool, multiplier: CGFloat) {
        let scale = width ? (size.width * multiplier) / self.frame.size.width : (size.height * multiplier) / self.frame.size.height
        self.setScale(scale)
    }
    
}
