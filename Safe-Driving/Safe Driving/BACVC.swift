//
//  BACVC.swift
//  Safe Driving
//
//  Created by Ryan K Backa on 7/22/16.
//  Copyright © 2016 Ryan Backa. All rights reserved.
//

import UIKit
import CoreData

class BACVC: UIViewController {
  
  @IBOutlet weak var BACLabel: UILabel!
  @IBOutlet weak var legalHours: UILabel!
  @IBOutlet weak var legalMinutes: UILabel!
  @IBOutlet weak var soberHours: UILabel!
  @IBOutlet weak var soberMInutes: UILabel!
  
  var drinkData = [NSManagedObject]()
  var profileData = [NSManagedObject]()
  var soberTimer = NSTimer()
  var legalTimer = NSTimer()
  var soberHour = Int()
  var soberMinute = Int()
  var legalHour = Int()
  var legalMinute = Int()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext
    let drinkFetchRequest = NSFetchRequest(entityName: "Drink")
    let profileFetchRequest = NSFetchRequest(entityName: "Profile")
    
    do{
      let results = try managedContext.executeFetchRequest(profileFetchRequest)
      profileData = results as! [NSManagedObject]
      print(profileData)
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
    
    do{
      let results = try managedContext.executeFetchRequest(drinkFetchRequest)
      drinkData = results as! [NSManagedObject]
      print(drinkData)
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
    
    calcBAC(drinkData, profileData: profileData)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func calcBAC(drinkData : [NSManagedObject], profileData: [NSManagedObject]){
    
    let bodyAC = WidmarkHelper.calculate(4.2, drinkVolume: 36, gender: "male", bodyWeight: 320)
    let BAC = bodyAC - 0.00025
    if BAC >= 0.00{
      BACLabel.text = "\(BAC)"
      let hourDecimal = BAC / 0.015
      soberHour = Int(hourDecimal)
      let minutesDecimal = hourDecimal - Float(soberHour)
      soberMinute = Int(minutesDecimal * 60)
      updateSoberTime()
      if soberHour == 1 {
        soberHours.text = "\(soberHour) Hour"
      } else {
        soberHours.text = "\(soberHour) Hours"
      }
      soberMInutes.text = "\(soberMinute) Minutes"
    } else if BAC >= 0.08 {
      let legalBAC = BAC - 0.08
      let hourDecimal = legalBAC / 0.015
      legalHour = Int(hourDecimal)
      let minutesDecimal = hourDecimal - Float(legalHour)
      legalMinute = Int(minutesDecimal * 60)
      legalTimer = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: #selector(BACVC.subtractLegalTime), userInfo: nil, repeats: true)
      if legalHour == 1 {
        legalHours.text = "\(legalHour) Hour"
      } else {
        legalHours.text = "\(legalHour) Hours"
      }
      legalMinutes.text = "\(legalMinute) Minutes"
    }
  }
  
  func updateSoberTime(){
    subtractSoberTime()
    soberTimer = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: #selector(BACVC.subtractSoberTime), userInfo: nil, repeats: true)
  }
  
  func subtractSoberTime(){
    if soberMinute > 0 {
      soberMinute = soberMinute - 1
      if soberHour == 1 {
        soberHours.text = "\(soberHour) Hour"
      } else {
        soberHours.text = "\(soberHour) Hours"
      }
      soberMInutes.text = "\(soberMinute) Minutes"
    } else if soberMinute == 0 {
      soberMinute = 59
      soberHour = soberHour - 1
      if soberHour == 1 {
        soberHours.text = "\(soberHour) Hour"
      } else {
        soberHours.text = "\(soberHour) Hours"
      }
      soberMInutes.text = "\(soberMinute) Minutes"
    }
    if soberHour == 0 && soberMinute == 0{
      if soberHour == 1 {
        soberHours.text = "\(soberHour) Hour"
      } else {
        soberHours.text = "\(soberHour) Hours"
      }
      soberMInutes.text = "\(soberMinute) Minutes"
      soberTimer.invalidate()
    }
  }
  
  func subtractLegalTime(){
    if legalMinute > 0 {
      legalMinute = legalMinute - 1
      if legalHour == 1 {
        legalHours.text = "\(legalHour) Hour"
      } else {
        legalHours.text = "\(legalHour) Hours"
      }
      legalMinutes.text = "\(legalMinute) Minutes"
    } else if legalMinute == 0 {
      legalMinute = 59
      legalHour = legalHour - 1
      if legalHour == 1 {
        legalHours.text = "\(legalHour) Hour"
      } else {
        legalHours.text = "\(legalHour) Hours"
      }
      legalMinutes.text = "\(legalMinute) Minutes"
    }
    if legalHour == 0 && legalMinute == 0{
      legalHours.text = "\(legalHour) Hours"
      legalMinutes.text = "\(legalMinute) Minutes"
      legalTimer.invalidate()
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
