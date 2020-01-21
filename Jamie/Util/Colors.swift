//
//  Colors.swift
//  Jamie
//
//  Created by yunseo on 1/5/20.
//  Copyright © 2020 yunseo. All rights reserved.
//

import UIKit
import Foundation

class Colors: UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
          let newRed = CGFloat(red)/255
          let newGreen = CGFloat(green)/255
          let newBlue = CGFloat(blue)/255
          
          self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
      }
    
    
    //241,238,231 #lightGrey
    static let backgroundGray = Colors.init(red: 241, green: 238, blue: 231)
    static let playholderGray = Colors.init(red: 135, green: 135, blue: 135)
}
