//
//  WidmarkFormulaHelper.swift
//  Safe Driving
//
//  Created by Ryan K Backa on 7/19/16.
//  Copyright © 2016 Ryan Backa. All rights reserved.
//

import Foundation

class WidmarkHelper {
  var alcContent = Float()
  var drinkVolume = Float()
  var gender = String()
  var bodyWeight = Float()
  
  // Calculates the BAC of the user without the time factor 
  static func calculate(alcPercent: Float, drinkVolume: Float, gender: String, bodyWeight: Float) -> Float{
    var r = Float()
    let alcContent = alcPercent * 100
    let totalGrams = drinkVolume * 29.57
    let gOfAlcohol = alcContent * totalGrams * 0.789
    
    if gender == "male" {
      r = (bodyWeight / 0.0022046) * 0.68
    } else if gender == "female" {
      r = (bodyWeight / 0.0022046) * 0.55
    }
    
    let bac = (gOfAlcohol / r) * 100
    
    return bac
  }
}