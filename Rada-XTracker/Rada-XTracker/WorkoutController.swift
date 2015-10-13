//
//  WorkoutController.swift
//  Rada-XTracker
//
//  Created by Wagner Pinto on 6/12/15.
//  Copyright (c) 2015 weeblu.co llc. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class WorkoutController: NSObject, CLLocationManagerDelegate {

    //CoreData Stack Properties
    let coreDataStack = CoreDataStack.sharedInstance
    let fetchRequest = NSFetchRequest(entityName: "Exercise")
    
    //CoreLocation Stack Properties
    let locationManager = CLLocationManager()
    var localCity: String = ""
    var localZip: String = ""
    var localState: String = ""
    var localCountry: String = ""
    
    var error: NSError?
    
    //singleton class
    class var sharedInstance :WorkoutController {
        struct Singleton {
            static let instance = WorkoutController()
        }
        return Singleton.instance
    }
    
    //MARK: - Location Controller Actions:
    func getLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            localCity = locality
            localZip = postalCode
            localState = administrativeArea
            localCountry = country
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    
    //MARK: - Workout Controller Actions:
    //Create
    func createNewExercise (name: NSString, date: NSDate, status: NSString, feeling: NSString, type: NSString) ->Exercise {
        
        let exercises = NSEntityDescription.entityForName("Exercise", inManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext!)
        let ex = Exercise(entity: exercises!, insertIntoManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext)

        //        var exercises: Exercise = NSEntityDescription.insertNewObjectForEntityForName("Exercise", inManagedObjectContext: CoreDataStack().managedObjectContext!) as! Exercise
        
        ex.exName = name as String
        ex.exDate = date
        ex.exStatus = status as String
        ex.exFeeling = feeling as String
        ex.exType = type as String
        
        coreDataStack.save()
        
        return ex
    }

    //Fetch
    var fetchExercises:[Exercise]{
        get {
            return coreDataStack.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as! [Exercise]
        }
    }

    //Delete
    func removeExerciseInBackground(ex:Exercise){
        ex.managedObjectContext?.deleteObject(ex)
        coreDataStack.save()
        
    }
    
}
    
    
    

