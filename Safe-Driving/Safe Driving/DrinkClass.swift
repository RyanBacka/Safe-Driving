//
//  DrinkClass.swift
//  Safe Driving
//
//  Created by Ryan K Backa on 7/24/16.
//  Copyright © 2016 Ryan Backa. All rights reserved.
//

import Foundation
import UIKit

class DrinkClass{
  var name: String
  var volume: Float
  var alcoholContent: Float
  
  init(name: String, volume: Float, alcoholContent: Float){
    self.name = name
    self.volume = volume
    self.alcoholContent = alcoholContent
  }
}
