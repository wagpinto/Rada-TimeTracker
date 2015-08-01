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
    let coreDataStack = UIApplication.sharedApplication().delegate as! CoreDataStack
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
            import
        }
        return Singleton.instance
    }
    
    //MARK: - Location Controller Actions:
    func getLocation () {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Problem with the data received from geocoder")
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
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    
    //MARK: - Workout Controller Actions:
    //Create
    func createNewExercise (name: NSString, date: NSDate, status: NSString, feeling: NSString, type: NSString) ->Exercise {
        
        var exercises: Exercise = NSEntityDescription.insertNewObjectForEntityForName("Exercises", inManagedObjectContext: CoreDataStack().managedObjectContext!) as! Exercise
        
        exercises.exName = name as String
        exercises.exDate = date
        exercises.exStatus = status as String
        exercises.exFeeling = feeling as String
        exercises.exType = type as String
        
        coreDataStack.save()
        
        return exercises
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
    
    
    

