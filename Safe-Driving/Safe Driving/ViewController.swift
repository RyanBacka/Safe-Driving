//
//  ViewController.swift
//  Safe Driving
//
//  Created by Ryan K Backa on 6/29/16.
//  Copyright © 2016 Ryan Backa. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
  
  @IBOutlet weak var nameText: UITextField!
  @IBOutlet weak var weightText: UITextField!
  @IBOutlet weak var ageText: UITextField!
  @IBOutlet weak var genderSelection: UIPickerView!
  
  var pickerData = [String]()
  var currentAge = Int()
  var currentWeight = Int()
  var gender = String()
  var name = String()
  var profileData = [NSManagedObject]()
  let locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    //initialAlert()
    let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
    UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    
    self.genderSelection.delegate = self
    self.genderSelection.dataSource = self
    
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
    
    pickerData = ["", "Male", "Female"]
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
  
  // sets components in PickerView
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  //sets rows in pickerView
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData.count
  }
  
  //sets atributes for pickerView
  func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    let titleData = pickerData[row]
    let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName:UIColor.grayColor()])
    return myTitle
  }
  
  //returns selection of pickerView
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[row]
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
    gender = pickerData[row]
  }
  
  // adds alerts and sets values once the user is done entering information
  @IBAction func doneButton(sender: AnyObject) {
    if let userName = nameText.text{
      name = userName
    }
    
    if let userWeight = weightText.text{
      if let weight = Int(userWeight){
        currentWeight = weight
      } else {
        //alert to enter an Int
        let alert = UIAlertController(title: "Alert", message: "Please enter a number in weight", preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        alert.addAction(dismissAction)
        presentViewController(alert, animated: true, completion: nil)
      }
    } else {
      // alert user to enter Weight
      let alert = UIAlertController(title: "Alert", message: "Please enter a number in weight", preferredStyle: .Alert)
      let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
      alert.addAction(dismissAction)
      presentViewController(alert, animated: true, completion: nil)
    }
    if let ageString = ageText.text{
      if let age = Int(ageString){
        currentAge = age
      } else {
        //alert to enter an Int
        let alert = UIAlertController(title: "Alert", message: "Please enter a number in age", preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        alert.addAction(dismissAction)
        presentViewController(alert, animated: true, completion: nil)
      }
      
    } else {
      //alert user to enter age
      let alert = UIAlertController(title: "Alert", message: "Please enter a number in age", preferredStyle: .Alert)
      let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
      alert.addAction(dismissAction)
      presentViewController(alert, animated: true, completion: nil)
    }
    profileCD(name, age: Float(currentAge), weight: Float(currentWeight), gender: gender)
  }
  
  @IBAction func userFinishedEditing(sender: AnyObject){
    view.endEditing(true)
  }
  //assigns values to coreData for later use
  func profileCD(name: String, age: Float, weight: Float, gender: String){
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext
    let entity =  NSEntityDescription.insertNewObjectForEntityForName("Profile", inManagedObjectContext: managedContext) 
    
    
    entity.setValue(name, forKey: "name")
    entity.setValue(weight, forKey: "weight")
    entity.setValue(age, forKey: "age")
    entity.setValue(gender, forKey: "gender")
    do {
      try managedContext.save()
      profileData.append(entity)
    } catch let error as NSError  {
      print("Could not save \(error), \(error.userInfo)")
    }
  }
  
  // sets the inital alert 
  func initialAlert(){
    let alert = UIAlertController(title: "Alert", message: "This application to intended to help keep track of your BAC. It is not 100% accurate and has no legal standing. Don't drink and Drive!", preferredStyle: .Alert)
    let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alert.addAction(okAction)
    presentViewController(alert, animated: true, completion: nil)
  }
  
  
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
    if (segue.identifier == "ProfileSegue"){
    let destinationVC = segue.destinationViewController as! ForecastVC
    destinationVC.profileName = name
    destinationVC.profileGender = gender
    destinationVC.profileWeight = Float(currentWeight)
    }
   }
 
}

