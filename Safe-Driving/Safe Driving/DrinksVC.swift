//
//  DrinksVC.swift
//  Safe Driving
//
//  Created by Ryan K Backa on 7/11/16.
//  Copyright © 2016 Ryan Backa. All rights reserved.
//

import UIKit

class DrinksVC: UIViewController {
  
  @IBOutlet weak var totalDrinks: UILabel! // label to show user selected amount of certain drink
  @IBOutlet weak var howManyDrinks: UISlider!
  @IBOutlet weak var drinksLabel: UILabel!
  @IBOutlet weak var alcoholContent: UITextField!
  @IBOutlet weak var drinkName: UITextField!
  @IBOutlet weak var drinkVolume: UITextField!
  
  var alcCont: Float = Float()
  var volume: Float = Float()
  var totalVolume: Float = Float()
  var drinks:Int = Int()
  
  //from profile
  var age:Int = Int()
  var weight:Int = Int()
  var gender:String = String()
  
  override func viewDidLoad() {
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func saveDrink(sender: AnyObject) {
    // update drinks label
    if let alc = alcoholContent.text {
      if let alcPerc = Float(alc) {
        alcCont = alcPerc
      } else {
        //notify user to enter a number
      }
    } else {
      //alert user to enter a number
    }
    
    if let vol = drinkVolume.text{
      if let drinkVol = Float(vol){
        volume = drinkVol
        totalVolume = howManyDrinks.value * volume
      } else {
        //alert user to enter a number
      }
    } else {
      //alert user to enter a number
    }
    
  }
  
  @IBAction func drinkSlider(sender: UISlider) {
    drinks = Int(howManyDrinks.value)
    totalDrinks.text = "\(drinks)"
  }
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
