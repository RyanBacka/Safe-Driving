//
//  ForecastVC.swift
//  Safe Driving
//
//  Created by Ryan K Backa on 7/19/16.
//  Copyright © 2016 Ryan Backa. All rights reserved.
//

import UIKit
import CoreData

class ForecastVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var drinkLabel1: UILabel!
  @IBOutlet weak var drinkSlider1: UISlider!
  @IBOutlet weak var drinkCountLabel1: UILabel!
  @IBOutlet weak var drinkLabel2: UILabel!
  @IBOutlet weak var drinkSlider2: UISlider!
  @IBOutlet weak var drinkCountLabel2: UILabel!
  @IBOutlet weak var forecastSwitch: UISwitch!
  
  let searchController = UISearchController(searchResultsController: nil)
  var searchActive = false
  var filtered:[String] = []
  var drinkData = [NSManagedObject]()
  var profileData = [NSManagedObject]()
  var drinkName:[String] = []
  var differentDrinks = 0
  var aC = Float()
  var vol = Float()
  var profileName = String()
  var profileGender = String()
  var profileWeight = Float()
  var selectedDrink = String()
  var drink1Amount = Int()
  var drink2Amount = Int()
  
  @IBOutlet weak var searchTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    searchTableView.delegate = self
    searchTableView.dataSource = self
    searchBar.delegate = self
    
    searchTableView.hidden = true
    drinkLabel1.hidden = true
    drinkSlider1.hidden = true
    drinkCountLabel1.hidden = true
    drinkLabel2.hidden = true
    drinkSlider2.hidden = true
    drinkCountLabel2.hidden = true
    
    //loads Core Data
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext
    let drinkFetchRequest = NSFetchRequest(entityName: "Drink")
    let profileFetchRequest = NSFetchRequest(entityName: "Profile")
    
    do{
      let results = try managedContext.executeFetchRequest(profileFetchRequest)
      profileData = results as! [NSManagedObject]
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
    
    do{
      let results = try managedContext.executeFetchRequest(drinkFetchRequest)
      drinkData = results as! [NSManagedObject]
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
    
    for item in drinkData {
      drinkName.append(item.valueForKey("name") as! String)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // checks to see if the user began editing the search
  func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    searchTableView.hidden = false
    searchActive = true
  }
  
  // checks to see if the user finished editing the search
  func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    searchActive = false
  }
  
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchActive = false
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchActive = false
  }
  
  // searches through items
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    filtered = drinkName.filter({ (text) -> Bool in
      let tmp: NSString = text
      let range  = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
      return range.location != NSNotFound
    })
    
    if filtered.count == 0 {
      searchActive = false
    } else {
      searchActive = true
    }
  self.searchTableView.reloadData()
  }
  
  // sets the sections for the UITableView
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  // sets the rows for the UITableView
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchActive == true {
      return filtered.count
    } else {
      return drinkData.count
    }
  }
  
  // shows the items found in the UITableView
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
    if searchActive == true {
      cell.textLabel?.text = filtered[indexPath.row]
    } else {
      cell.textLabel?.text = drinkName[indexPath.row]
    }
    
    return cell
  }
  
  //handles the selection of a search item
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    searchTableView.hidden = true
    drinkLabel1.hidden = false
    drinkSlider1.hidden = false
    drinkCountLabel1.hidden = false
    differentDrinks = differentDrinks + 1
    if differentDrinks == 1 {
      let drink = drinkData[indexPath.row]
      drinkLabel1.text = drink.valueForKey("name") as? String
      if let chosen = drinkLabel1.text{
        selectedDrink = chosen
      }
      if let alcCont = drink.valueForKey("alcoholPercent") as? Float {
        aC = alcCont
      }
      if let volume = drink.valueForKey("volume") as? Float {
        vol = volume
      }
      print(profileGender)
    } else if differentDrinks == 2 {
      let drink = drinkData[indexPath.row]
      drinkLabel2.text = drink.valueForKey("name") as? String
      if let alcCont = drink.valueForKey("alcoholPercent") as? Float {
        aC = alcCont
      }
      if let volume = drink.valueForKey("volume") as? Float {
        vol = volume
      }
    }
  }
  
  @IBAction func slider1Action(sender: AnyObject) {
    drink1Amount = Int(drinkSlider1.value)
    drinkCountLabel1.text = "\(drink1Amount)"
  }
  
  @IBAction func slider2Action(sender: AnyObject) {
    drink2Amount = Int(drinkSlider2.value)
    drinkCountLabel2.text = "\(drink2Amount)"
  }
  
  // lets the user choose if they want to see how many they can drink before over the legal limit
  @IBAction func switchAction(sender: AnyObject) {
    if forecastSwitch.on{
      forecastSwitch.setOn(true, animated: true)
      let possibleBAC = WidmarkHelper.calculate(aC, drinkVolume: vol, gender: profileGender, bodyWeight: profileWeight)
      let allowedBeforeIntox = 0.080000 / possibleBAC
      drinkSlider1.value = Float(Int(allowedBeforeIntox))
      drinkCountLabel1.text = "\(Int(allowedBeforeIntox))"
    } else {
      forecastSwitch.setOn(false, animated: true)
      drinkCountLabel1.text = "0"
      drinkSlider1.value = 0
    }
  }
  
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
    if (segue.identifier == "BACSegue"){
      let destinationVC = segue.destinationViewController as! BACVC
      destinationVC.profileWeight = profileWeight
      destinationVC.profileGender = profileGender
      destinationVC.drinkVolume = vol
      destinationVC.drinkContent = aC
      destinationVC.numOfDrinks = drinkSlider1.value
    }
   }
   
  
}
