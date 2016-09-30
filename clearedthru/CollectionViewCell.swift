//
//  CollectionViewCell.swift
//  clearedthru
//
//  Created by Avinash Kondagunta on 9/30/16.
//  Copyright © 2016 avinash kondagunta. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  
  
  @IBOutlet weak var userImage: UIImageView!
  @IBOutlet weak var userName: UILabel!
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.makeItRound()
  }
  
  func makeItRound()
  {
    self.userImage.layer.masksToBounds = true
    self.userImage.layer.cornerRadius = self.userImage.frame.size.width/2.0
  }
  
  
    
}
