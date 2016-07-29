//
//  BACVC.swift
//  Safe Driving
//
//  Created by Ryan K Backa on 7/22/16.
//  Copyright © 2016 Ryan Backa. All rights reserved.
//

import UIKit
import CoreData
import UberRides
import CoreLocation

// Mark: LoginButtonDelegate



class BACVC: UIViewController, CLLocationManagerDelegate {
  
  @IBOutlet weak var BACLabel: UILabel!
  @IBOutlet weak var legalTimerLabel: UILabel!
  @IBOutlet weak var soberTimerLabel: UILabel!
  @IBOutlet weak var BACView: UIView!
  
  var drinkVolume = Float()
  var drinkContent = Float()
  var profileWeight = Float()
  var profileGender = String()
  var numOfDrinks = Float()
  var soberTimer = NSTimer()
  var legalTimer = NSTimer()
  var soberHours = Double()
  var legalHours = Double()
  var soberTimeEnd = NSDate()
  var legalTimeEnd = NSDate()
  let locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
    //loads core data then inserts into bac function
    
    calcBAC(drinkVolume, drinkAlc: drinkContent, howMany: numOfDrinks, profileLbs: profileWeight, profileSex: profileGender)
    
    let behavior = RideRequestViewRequestingBehavior(presentingViewController: self)
    let location = CLLocation(latitude: 37.787654, longitude: -122.402760)
    let parameters = RideParametersBuilder().setPickupLocation(location).build()
    let uberButton = RideRequestButton(rideParameters: parameters, requestingBehavior: behavior)
    uberButton.translatesAutoresizingMaskIntoConstraints = false
    self.BACView.addSubview(uberButton)
    
    let horizontalConstraint = NSLayoutConstraint(item: uberButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: BACView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    let verticalConstraint = NSLayoutConstraint(item: uberButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: BACView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.4, constant: 0)
    BACView.addConstraint(horizontalConstraint)
    BACView.addConstraint(verticalConstraint)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
      locationManager.stopUpdatingLocation()
    }
  }
  
  //calculates the BAC and calls the functions for timers
  func calcBAC(drinkVol: Float, drinkAlc: Float, howMany: Float, profileLbs: Float, profileSex: String){
    let totalVolume = drinkVol * howMany
    let bodyAC = WidmarkHelper.calculate(drinkAlc, drinkVolume: totalVolume, gender: profileSex, bodyWeight: profileLbs)
    print(bodyAC)
    let BAC = bodyAC - 0.00025
    if BAC >= 0.00{
      BACLabel.text = "\(BAC)"
      soberHours = Double(BAC / 0.015)
      updateSoberTime()
    }
    if BAC >= 0.08 {
      let legalBAC = BAC - 0.08
      legalHours = Double(legalBAC / 0.015)
      updateLegalTime()
    }
  }
  
  //sets the timers and local alerts for sober level
  func updateSoberTime(){
    soberTimeEnd = NSDate(timeInterval: soberHours*60*60, sinceDate: NSDate())
    subtractSoberTime()
    soberTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(BACVC.subtractSoberTime), userInfo: nil, repeats: true)
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
      notification.alertBody = "All alcohol should be out of your system"
      notification.alertAction = "unlock"
      notification.soundName = UILocalNotificationDefaultSoundName
      UIApplication.sharedApplication().scheduleLocalNotification(notification)
      soberTimerLabel.text = hourText + " Hours " + minuteText + " Minutes "
    } else {
      soberTimerLabel.text = "0 Hours 0 Minutes"
    }
  }
  
  //sets the timers and Local Alerts for legal level
  func updateLegalTime(){
    legalTimeEnd = NSDate(timeInterval:legalHours*60*60, sinceDate: NSDate())
    subtractLegalTime()
    legalTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(BACVC.subtractLegalTime), userInfo: nil, repeats: true)
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
      notification.alertBody = "You should now be below the legal limit to drive"
      notification.alertAction = "unlock"
      notification.soundName = UILocalNotificationDefaultSoundName
      UIApplication.sharedApplication().scheduleLocalNotification(notification)
      legalTimerLabel.text = hourText + " Hours " + minuteText + "Minutes"
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
