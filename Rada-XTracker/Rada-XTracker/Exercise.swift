//
//  Exercise.swift
//  Rada-XTracker
//
//  Created by Wagner Pinto on 6/11/15.
//  Copyright (c) 2015 weeblu.co llc. All rights reserved.
//

import Foundation
import CoreData

class Exercise: NSManagedObject {

    @NSManaged var exName: String
    @NSManaged var exDate: NSDate
    @NSManaged var exStatus: String
    @NSManaged var exFeeling: String
    @NSManaged var exType: String

}
