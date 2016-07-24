//
//  Profile+CoreDataProperties.swift
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

extension Profile {

    @NSManaged var name: String?
    @NSManaged var weight: NSNumber?
    @NSManaged var age: NSNumber?
    @NSManaged var gender: String?

}
