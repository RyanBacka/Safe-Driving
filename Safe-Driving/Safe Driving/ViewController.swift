//
//  ViewController.swift
//  Safe Driving
//
//  Created by Ryan K Backa on 6/29/16.
//  Copyright © 2016 Ryan Backa. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  
  
  @IBOutlet weak var weightText: UITextField!
  @IBOutlet weak var ageText: UITextField!
  @IBOutlet weak var genderSelection: UIPickerView!
  
  var pickerData = [String]()
  var currentAge = Int()
  var currentWeight = Int()
  var gender = String()
  var name = String()
  var profileData = [NSManagedObject]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    self.genderSelection.delegate = self
    self.genderSelection.dataSource = self
    
    pickerData = ["Male", "Female"]
    
    initialAlert()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData.count
  }
  
  func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    let titleData = pickerData[row]
    let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName:UIColor.grayColor()])
    return myTitle
  }
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[row]
  }
  
  @IBAction func doneButton(sender: AnyObject) {
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
  
  func profileCD(name: String, age: Float, weight: Float, gender: String){
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext
    let entity =  NSEntityDescription.entityForName("Profile", inManagedObjectContext:managedContext)
    let newProfile = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
    
    newProfile.setValue(name, forKey: "name")
    newProfile.setValue(weight, forKey: "weight")
    newProfile.setValue(age, forKey: "age")
    newProfile.setValue(gender, forKey: "gender")
    do {
      try managedContext.save()
      profileData.append(newProfile)
    } catch let error as NSError  {
      print("Could not save \(error), \(error.userInfo)")
    }
  }
  
  func initialAlert(){
    let alert = UIAlertController(title: "Alert", message: "This application to intended to help keep track of your BAC. It is not 100% accurate and has no legal standing. Don't drink and Drive!", preferredStyle: .Alert)
    let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alert.addAction(okAction)
    presentViewController(alert, animated: true, completion: nil)
  }
}

