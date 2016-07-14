//
//  ViewController.swift
//  Safe Driving
//
//  Created by Ryan K Backa on 6/29/16.
//  Copyright © 2016 Ryan Backa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  
  
  @IBOutlet weak var weightText: UITextField!
  @IBOutlet weak var ageText: UITextField!
  @IBOutlet weak var genderSelection: UIPickerView!
  
  var pickerData: [String] = [String]()
  var currentAge = Int()
  var currentWeight = Int()
  var gender = String()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    self.genderSelection.delegate = self
    self.genderSelection.dataSource = self
    
    pickerData = ["Male", "Female"]
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
      }
    } else {
      // alert user to enter Weight
    }
    if let ageString = ageText.text{
      if let age = Int(ageString){
        currentAge = age
      } else {
        //alert to enter an Int
      }
      
    } else {
      //alert user to enter age
    }
  }
}

