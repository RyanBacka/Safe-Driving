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
  @IBOutlet weak var legalTimerLabel: UILabel!
  @IBOutlet weak var soberTimerLabel: UILabel!
  
  
  var drinkData = [NSManagedObject]()
  var profileData = [NSManagedObject]()
  var soberTimer = NSTimer()
  var legalTimer = NSTimer()
  var soberHours = Double()
  var legalHours = Double()
  var soberTimeEnd = NSDate()
  var legalTimeEnd = NSDate()
  
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
    
    let bodyAC = WidmarkHelper.calculate(4.2, drinkVolume: 1, gender: "male", bodyWeight: 320)
    let BAC = bodyAC - 0.00025
    if BAC >= 0.00{
      BACLabel.text = "\(BAC)"
      soberHours = Double(BAC / 0.015)
      /*soberHour = Int(hourDecimal)
       let minutesDecimal = hourDecimal - Float(soberHour)
       soberMinute = Int(minutesDecimal * 60)*/
      updateSoberTime()
    } else if BAC >= 0.08 {
      let legalBAC = BAC - 0.08
      legalHours = Double(legalBAC / 0.015)
      /*legalHour = Int(hourDecimal)
       let minutesDecimal = hourDecimal - Float(legalHour)
       legalMinute = Int(minutesDecimal * 60)*/
      updateLegalTime()
    }
  }
  
  func updateSoberTime(){
    soberTimeEnd = NSDate(timeInterval: soberHours*60*60, sinceDate: NSDate())
    subtractSoberTime()
    soberTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(BACVC.subtractSoberTime), userInfo: nil, repeats: true)
  }
  
  func updateLegalTime(){
    legalTimeEnd = NSDate(timeInterval:legalHours*60*60, sinceDate: NSDate())
    subtractLegalTime()
    legalTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(BACVC.subtractLegalTime), userInfo: nil, repeats: true)
  }
  
  func subtractSoberTime(){
    let timeNow = NSDate()
    if soberTimeEnd.compare(timeNow) == NSComparisonResult.OrderedDescending{
      let calendar = NSCalendar.currentCalendar()
      let components = calendar.components([.Hour, .Minute, .Second], fromDate: timeNow, toDate: soberTimeEnd, options: [])
      
      let hourText  = String(components.hour)
      let minuteText = String(components.minute)
      let notification = UILocalNotification()
      notification.fireDate = NSDate(timeIntervalSinceNow: soberHours*60*60)
      notification.alertBody = "You should now be sober"
      notification.alertAction = "unlock"
      notification.soundName = UILocalNotificationDefaultSoundName
      notification.userInfo = ["CustomField1": "w00t"]
      UIApplication.sharedApplication().scheduleLocalNotification(notification)
      soberTimerLabel.text = hourText + " Hours " + minuteText + " Minutes "
    } else {
      soberTimerLabel.text = "0 Hours 0 Minutes"
    }
  }
  
  func subtractLegalTime(){
    let timeNow = NSDate()
    if legalTimeEnd.compare(timeNow) == NSComparisonResult.OrderedDescending{
      let calendar = NSCalendar.currentCalendar()
      let components = calendar.components([.Hour, .Minute, .Second], fromDate: timeNow, toDate: legalTimeEnd, options: [])
      
      let hourText  = String(components.hour)
      let minuteText = String(components.minute)
      let notification = UILocalNotification()
      notification.fireDate = NSDate(timeIntervalSinceNow: legalHours*60*60)
      notification.alertBody = "You should now be legal to drive"
      notification.alertAction = "unlock"
      notification.soundName = UILocalNotificationDefaultSoundName
      notification.userInfo = ["CustomField1": "w00t"]
      UIApplication.sharedApplication().scheduleLocalNotification(notification)
      legalTimerLabel.text = hourText + " Hours" + minuteText + "Minutes"
    } else {
      legalTimerLabel.text = "0 Hours 0 Minutes"
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
