//
//  ScoreBoard.swift
//  findChineseWords
//
//  Created by Alvis Poon on 29/8/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//


import UIKit


class ScoreBoard: UIView {
    
    
  lazy var closeButton: UIButton = {
    let closeButton = UIButton(type: .contactAdd)
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    return closeButton
  }()
  
  lazy var contentView: UIImageView = {
    let contentView = UIImageView()
    contentView.image = UIImage(named: "WoodTexture")
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(topScorelabel)
    contentView.addSubview( topScoreNumlabel)
    contentView.addSubview(currentScorelabel)
    contentView.addSubview( currentScoreNumlabel)
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
    
    lazy var topScorelabel: UILabel = {
      let topScorelabel = UILabel()
      topScorelabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        topScorelabel.text = "TOP SCORE : "
        topScorelabel.textAlignment = .center
      topScorelabel.translatesAutoresizingMaskIntoConstraints = false
      return topScorelabel
    }()
    
    
    lazy var topScoreNumlabel: UILabel = {
      let topScoreNumlabel = UILabel()
      topScoreNumlabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        topScoreNumlabel.text = "100"
        topScoreNumlabel.textAlignment = .center
      topScoreNumlabel.translatesAutoresizingMaskIntoConstraints = false
      return topScoreNumlabel
    }()
    
     lazy var currentScorelabel: UILabel = {
       let currentScorelabel = UILabel()
       currentScorelabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
         currentScorelabel.text = "THIS SCORE : "
         currentScorelabel.textAlignment = .center
       currentScorelabel.translatesAutoresizingMaskIntoConstraints = false
       return currentScorelabel
     }()
     
     
     lazy var currentScoreNumlabel: UILabel = {
       let currentScoreNumlabel = UILabel()
       currentScoreNumlabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
         currentScoreNumlabel.text = "100"
         currentScoreNumlabel.textAlignment = .center
       currentScoreNumlabel.translatesAutoresizingMaskIntoConstraints = false
       return currentScoreNumlabel
     }()
     
  
  lazy var headerView: UIView = {
    let headerView = UIView()
    headerView.backgroundColor = UIColor(red: 22/255, green: 160/255, blue: 133/255, alpha: 0.5)
    headerView.layer.shadowColor = UIColor.gray.cgColor
    headerView.layer.shadowOffset = CGSize(width: 0, height: self.frame.height*0.2)
    headerView.layer.shadowOpacity = 1
    headerView.layer.shadowRadius = 5
    headerView.addSubview(headerTitle)
    
    headerView.translatesAutoresizingMaskIntoConstraints = false
    return headerView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  private func setupView() {
    backgroundColor = .white
    alpha = 0.5
    addSubview(contentView)
    addSubview(headerView)
    setupLayout()
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
      
      
      
        topScorelabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
      //topScorelabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        topScorelabel.heightAnchor.constraint(equalToConstant: 50),
      topScorelabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      topScorelabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        

      topScoreNumlabel.topAnchor.constraint(equalTo: topScorelabel.bottomAnchor, constant: 20),
         //  topScoreNumlabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
           topScoreNumlabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
           topScoreNumlabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

      currentScorelabel.topAnchor.constraint(equalTo: topScoreNumlabel.bottomAnchor, constant: 40),
         //topScorelabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
           currentScorelabel.heightAnchor.constraint(equalToConstant: 50),
         currentScorelabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         currentScorelabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
           

         currentScoreNumlabel.topAnchor.constraint(equalTo: currentScorelabel.bottomAnchor, constant: 20),
            //  topScoreNumlabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
              currentScoreNumlabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
              currentScoreNumlabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

      
        //layout closeButton in headerView
        closeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        closeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        
    ])
  }
    
    func showVictory(topScore: Int, currentScore: Int){
        
        self.isHidden = false
//        self.topScore = topScore
//        self.currentScore = currentScore
//
        topScoreNumlabel.text = "\(topScore)"
        currentScoreNumlabel.text = "\(currentScore)"
    }
  
  //custom views should override this to return true if
  //they cannot layout correctly using autoresizing.
  //from apple docs https://developer.apple.com/documentation/uikit/uiview/1622549-requiresconstraintbasedlayout
  override class var requiresConstraintBasedLayout: Bool {
    return true
  }
}
