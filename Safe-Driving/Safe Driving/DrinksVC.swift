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
  @IBOutlet weak var drinksLabel: UILabel!
  @IBOutlet weak var alcoholContent: UITextField!
  @IBOutlet weak var drinkName: UITextField!
  @IBOutlet weak var drinkVolume: UITextField!
  
  var drink = String()
  var alcCont = Float()
  var volume = Float()
  var totalVolume = Float()
  var drinks = Int()
  var drinkData = [NSManagedObject]()
  
  //from profile
  var age = Int()
  var weight = Int()
  var gender = String()
  
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
    
  }
  
  @IBAction func drinkSlider(sender: UISlider) {
    drinks = Int(howManyDrinks.value)
    totalDrinks.text = "\(drinks)"
  }
  
  func drinkCD(name: String, alcCont: Float, volume: Float){
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext
    let entity =  NSEntityDescription.entityForName("Drink", inManagedObjectContext:managedContext)
    let newDrink = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
    
    newDrink.setValue(name, forKey: "name")
    newDrink.setValue(alcCont, forKey: "alcoholPercent")
    newDrink.setValue(volume, forKey: "volume")
    
    do {
      try managedContext.save()
      drinkData.append(newDrink)
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
   }
   */
  
}
