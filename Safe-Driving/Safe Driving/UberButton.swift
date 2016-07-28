//
//  UberButton.swift
//  Safe Driving
//
//  Created by Ryan K Backa on 7/27/16.
//  Copyright © 2016 Ryan Backa. All rights reserved.
//

import UIKit
import UberRides
import CoreLocation

public class ButtonViewController : UIViewController {
  
  public let topView = UIView()
  public let bottomView = UIView()
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(topView)
    view.addSubview(bottomView)
    
    initialSetup()
    addTopViewConstraints()
    addBottomViewConstraints()
  }
  
  // Mark: Private Interface
  
  private func initialSetup() {
    topView.backgroundColor = UIColor.whiteColor()
    bottomView.backgroundColor = UIColor.blackColor()
  }
  
  private func addTopViewConstraints() {
    topView.translatesAutoresizingMaskIntoConstraints = false
    
    let topConstriant = NSLayoutConstraint(item: topView, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
    let bottomConstraint = NSLayoutConstraint(item: topView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
    let leftConstraint = NSLayoutConstraint(item: topView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0.0)
    let rightConstraint = NSLayoutConstraint(item: topView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0.0)
    
    view.addConstraints([topConstriant, bottomConstraint, leftConstraint, rightConstraint])
  }
  
  private func addBottomViewConstraints() {
    bottomView.translatesAutoresizingMaskIntoConstraints = false
    
    let topConstriant = NSLayoutConstraint(item: bottomView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
    let bottomConstraint = NSLayoutConstraint(item: bottomView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
    let leftConstraint = NSLayoutConstraint(item: bottomView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0.0)
    let rightConstraint = NSLayoutConstraint(item: bottomView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0.0)
    
    view.addConstraints([topConstriant, bottomConstraint, leftConstraint, rightConstraint])
  }
}
