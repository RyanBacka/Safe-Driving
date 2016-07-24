//
//  Drink+CoreDataProperties.swift
//  Safe Driving
//
//  Created by Ryan K Backa on 7/24/16.
//  Copyright © 2016 Ryan Backa. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Drink {

    @NSManaged var name: String?
    @NSManaged var alcoholPercent: NSNumber?
    @NSManaged var volume: NSNumber?

}
