//
//  LevelBoard.swift
//  findChineseWords
//
//  Created by Alvis Poon on 31/8/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//

import UIKit


class LevelBoard: UIView {
    
    var level = Level()
    let maxCol = 5
    let maxRow = 7
    
    var noOfLevel = 0

    var popupButtonHandlerDelegate: PopupButtonHandlerDelegate?

    
  lazy var closeButton: UIButton = {
    let closeButton = UIButton(type: .contactAdd)
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    return closeButton
  }()
  
  lazy var contentView: UIImageView = {
    let contentView = UIImageView()
    contentView.image = UIImage(named: "WoodTexture")
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(closeButton)
    return contentView
  }()
  
  lazy var headerTitle: UILabel = {
    let headerTitle = UILabel()
    headerTitle.font = UIFont.systemFont(ofSize: 30, weight: .medium)
    headerTitle.text = "RESULT"
    headerTitle.textAlignment = .center
    headerTitle.translatesAutoresizingMaskIntoConstraints = false
    return headerTitle
  }()
    
  
  lazy var headerView: UIView = {
    let headerView = UIView()
    headerView.backgroundColor = UIColor(red: 22/255, green: 160/255, blue: 133/255, alpha: 0)
    headerView.layer.shadowColor = UIColor.gray.cgColor
    headerView.layer.shadowOffset = CGSize(width: 0, height: self.frame.height*0.2)
    headerView.layer.shadowOpacity = 1
    headerView.layer.shadowRadius = 5
    headerView.addSubview(headerTitle)
    
    headerView.translatesAutoresizingMaskIntoConstraints = false
    return headerView
  }()
    

    //this should never be called
    required init(coder aDecoder:NSCoder) {
      fatalError("use init(frame:")
    }
    
     init(frame: CGRect, levelNum: Int) {
        super.init(frame: frame)
        self.noOfLevel = levelNum
        setupView()
        isUserInteractionEnabled = true
    }
  
  
  private func setupView() {
    backgroundColor = .white
    alpha = 1
    addSubview(contentView)
    addSubview(headerView)
    setupLayout()
    genLevelButton()
  }
  
  private func setupLayout() {
    NSLayoutConstraint.activate([
      //pin headerTitle to headerView
      headerTitle.topAnchor.constraint(equalTo: headerView.topAnchor),
      headerTitle.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
      headerTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
      headerTitle.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
      
      
      //pin headerView to top
      headerView.topAnchor.constraint(equalTo: topAnchor),
      headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
      headerView.heightAnchor.constraint(equalToConstant: 40),
      
      //layout contentView
      contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
      contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
      
      
      
      
        //layout closeButton in headerView
        closeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        closeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        
    ])
  }
    
 func genLevelButton(){

    let buttonwidth = (frame.width * 0.8 / CGFloat(maxCol) ) * 0.8
    let buttonmargin = (frame.width * 0.8 / CGFloat(maxCol) ) * 0.2
    
    let buttonGroupMargin = frame.width*0.1
    let buttonGroupTop = frame.width * 0.25
    
    print (buttonwidth)
    print (buttonmargin)
    
    print (buttonGroupMargin)
    
    var counter = 0
    for i in 0...maxRow-1{
        for j in 0...maxCol-1{
            if counter<noOfLevel{
                let hintButton = ActionButton(defaultButtonImage: "blockR", defaultTitle: "123", action: popupButtonHandler, level: counter, width: buttonwidth, height: buttonwidth)
                
                print (buttonGroupMargin + (buttonwidth + buttonmargin)*CGFloat(j))
                hintButton.frame = CGRect(x: buttonGroupMargin + (buttonwidth + buttonmargin)*CGFloat(j) , y: buttonGroupTop+(buttonwidth+buttonmargin)*CGFloat(i), width: buttonwidth, height: buttonwidth)
                contentView.addSubview(hintButton)
            }
            counter+=1
        }
    }

    }
    

        @objc func popupButtonHandler(index: Int) {
            print (index)
           //switch index {
            //case PopupButtons.level:
//            playSound1(filename: "selected.wav")
                popupButtonHandlerDelegate?.levelTapped(level: index)
    //        case PopupButtons.next:
    //            popupButtonHandlerDelegate?.nextTapped()
    //        case PopupButtons.retry:
    //            popupButtonHandlerDelegate?.retryTapped()
           // default:
           //     break
           // }
        }
  
  //custom views should override this to return true if
  //they cannot layout correctly using autoresizing.
  //from apple docs https://developer.apple.com/documentation/uikit/uiview/1622549-requiresconstraintbasedlayout
  override class var requiresConstraintBasedLayout: Bool {
    return true
  }
}
