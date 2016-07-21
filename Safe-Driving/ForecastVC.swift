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
    <#code#>
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    <#code#>
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    <#code#>
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
