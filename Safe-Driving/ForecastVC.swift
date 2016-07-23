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
  
  let searchController = UISearchController(searchResultsController: nil)
  var searchActive = false
  var filtered:[String] = []
  var drinkData = [NSManagedObject]()
  var profileData = [NSManagedObject]()
  var drinkName:[String] = []
  var differentDrinks = 0
  var aC = Float()
  var vol = Float()
  
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
    
    for item in drinkData {
      drinkName.append(item.valueForKey("name") as! String)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    searchTableView.hidden = false
    searchActive = true
  }
  
  func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    searchActive = false
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchActive = false
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchActive = false
  }
  
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
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchActive == true {
      return filtered.count
    } else {
      return drinkData.count
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
    if searchActive == true {
      cell.textLabel?.text = filtered[indexPath.row]
    } else {
      cell.textLabel?.text = drinkName[indexPath.row]
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    searchTableView.hidden = true
    drinkLabel1.hidden = false
    drinkSlider1.hidden = false
    drinkCountLabel1.hidden = false
    differentDrinks = differentDrinks + 1
    if differentDrinks == 1 {
      let drink = drinkData[indexPath.row]
      drinkLabel1.text = drink.valueForKey("name") as? String
      if let alcCont = drink.valueForKey("alcoholPercent") as? Float {
        aC = alcCont
      }
      if let volume = drink.valueForKey("volume") as? Float {
        vol = volume
      }
      drinkCountLabel1.text = "\(WidmarkHelper.calculate(aC, drinkVolume: vol, gender: "male", bodyWeight: 320)-0.015)"
      
    }
  }
  
  @IBAction func addDrinkButton(sender: AnyObject) {
  }
  
  @IBAction func checkBacButton(sender: AnyObject) {
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
