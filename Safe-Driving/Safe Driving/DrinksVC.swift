//
//  DrinksVC.swift
//  Safe Driving
//
//  Created by Ryan K Backa on 7/11/16.
//  Copyright © 2016 Ryan Backa. All rights reserved.
//

import UIKit
import CoreData

class DrinksVC: UIViewController {
  
  @IBOutlet weak var totalDrinks: UILabel! // label to show user selected amount of certain drink
  @IBOutlet weak var howManyDrinks: UISlider!
  @IBOutlet weak var alcoholContent: UITextField!
  @IBOutlet weak var drinkName: UITextField!
  @IBOutlet weak var drinkVolume: UITextField!
  
  var drink = String()
  var alcCont = Float()
  var volume = Float()
  var totalVolume = Float()
  var drinks = Int()
  let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  
  
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
        let alert = UIAlertController(title: "Alert", message: "Please enter a number in Alcohol %", preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        alert.addAction(dismissAction)
        presentViewController(alert, animated: true, completion: nil)
      }
    } else {
      //alert user to enter a number
      let alert = UIAlertController(title: "Alert", message: "Please enter a number in Alcohol %", preferredStyle: .Alert)
      let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
      alert.addAction(dismissAction)
      presentViewController(alert, animated: true, completion: nil)
    }
    
    if let vol = drinkVolume.text{
      if let drinkVol = Float(vol){
        volume = drinkVol
        totalVolume = howManyDrinks.value * volume
      } else {
        //alert user to enter a number
        let alert = UIAlertController(title: "Alert", message: "Please enter a number in oz per drink", preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        alert.addAction(dismissAction)
        presentViewController(alert, animated: true, completion: nil)
      }
    } else {
      //alert user to enter a number
      let alert = UIAlertController(title: "Alert", message: "Please enter a number in oz per drink", preferredStyle: .Alert)
      let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
      alert.addAction(dismissAction)
      presentViewController(alert, animated: true, completion: nil)
    }
    
    if let drinkNm = drinkName.text {
      drink = drinkNm
    } else {
      let alert = UIAlertController(title: "Alert", message: "Please enter a name for your drink", preferredStyle: .Alert)
      let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
      alert.addAction(dismissAction)
      presentViewController(alert, animated: true, completion: nil)
    }
    drinkCD(alcCont, name: drink, volume: volume)
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  // sets value of label based on the slider
  @IBAction func drinkSlider(sender: UISlider) {
    drinks = Int(howManyDrinks.value)
    totalDrinks.text = "\(drinks)"
  }
  
  // sets new drink in coreData
  func drinkCD(alcCont: Float, name: String, volume: Float){
    let managedContext = appDelegate.managedObjectContext
    let entity =  NSEntityDescription.insertNewObjectForEntityForName("Drink", inManagedObjectContext: managedContext) as! Drink
    
    entity.setValue(alcCont, forKey: "alcoholPercent")
    entity.setValue(name, forKey: "name")
    entity.setValue(volume, forKey: "volume")
    
    do {
      try managedContext.save()
    } catch let error as NSError  {
      print("Could not save \(error), \(error.userInfo)")
    }
  }
  

  
 /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
    if (segue.identifier == "BACSegue"){
      let destinationVC = segue.destinationViewController as! BACVC
      destinationVC.userName = profileName
    }
   }
  */
  
}
