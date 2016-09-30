//
//  TextInputTableView.swift
//  clearedthru
//
//  Created by Avinash Kondagunta on 9/28/16.
//  Copyright © 2016 avinash kondagunta. All rights reserved.
//

import Foundation
import UIKit

public class TextInputTableView: UITableViewCell {
  
  @IBOutlet weak var myTextField: UITextField!
  
  public func configure(text:String?,placeholder:String?) {
    myTextField.text = text
    myTextField.placeholder = placeholder
    
  }
  
  
}
