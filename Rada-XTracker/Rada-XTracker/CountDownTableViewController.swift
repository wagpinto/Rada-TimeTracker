//
//  CountDownTableViewController.swift
//  Rada-XTracker
//
//  Created by Wagner Pinto on 6/1/15.
//  Copyright (c) 2015 weeblu.co llc. All rights reserved.
//

import UIKit
import AVFoundation

class CountDownTableViewController: UITableViewController, UITextFieldDelegate {

    //MARK: - PROPERTIES
    @IBOutlet weak var happyButton: UIButton!
    @IBOutlet weak var normalButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!
    
    @IBOutlet weak var startWorkOut: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var setTimeTextField: UITextField!
    @IBOutlet weak var numbSetsTextField: UITextField!
    @IBOutlet weak var breakTimeTextField: UITextField!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    var sets: Int = 0
    
    var needBreak : Bool = true
    var timer = NSTimer()
    var startTime = NSTimeInterval()
    var breakTime = NSTimeInterval()
    var endTime = NSDate().dateByAddingTimeInterval(0)
    
    var audioPlayer = AVAudioPlayer()

    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.numbSetsTextField.delegate = self
        self.setTimeTextField.delegate = self
        self.breakTimeTextField.delegate = self
        
        WorkoutController.sharedInstance.getLocation()
        
        self.locationLabel.text = WorkoutController.sharedInstance.localCity
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Workout Actions:
    @IBAction func startWorkout(sender: AnyObject) {
        //check textfields setup:
        if setTimeTextField.text!.isEmpty || numbSetsTextField.text!.isEmpty || breakTimeTextField.text!.isEmpty {
            print("Select reps and breakTime")
            let alert = UIAlertView(title: "No Reps Setup", message: "Please setup workout Reps, breakTime and Time.", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }else {
            //setup the number of sets
            sets = numbSetsTextField.text.toInt()!
            let doubleTime = NSString(string: setTimeTextField.text!).doubleValue
            startTime = doubleTime

            //setup the breakTime
            let doubleBreak = NSString(string: breakTimeTextField.text!).doubleValue
            breakTime = doubleBreak
            needBreak =  false
            
            //timer schedule fires
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "countDownTime", userInfo: nil, repeats: true)
            //loop
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
            
            //remove keyboard
            setTimeTextField.resignFirstResponder()
            breakTimeTextField.resignFirstResponder()
            numbSetsTextField.resignFirstResponder()
            
        }
    }
    
    func countDownTime() {
        let remainedTime = endTime.timeIntervalSinceNow
        timeLabel.text = remainedTime.time
        
        if remainedTime <= 0 {
            if needBreak == true {
            sets--
            }
            if sets == -1 {
                timer.invalidate()
                let alert = UIAlertView(title: "Workout is DONE", message: "The workout is over, you should rest.", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                let today = NSDate()
                WorkoutController.sharedInstance.createNewExercise("Monday", date:today, status: "Active", feeling: "Good", type: "Workout")
            
            }else {
                
                if needBreak == true {
                endTime = NSDate().dateByAddingTimeInterval(breakTime)
                print(sets)
                numbSetsTextField.text = sets.description
                updateLabels()
                timeLabel.backgroundColor = UIColor.redColor()
                needBreak = false
                playAudioBreak()
                }
                else
                {
                needBreak = true
                timeLabel.backgroundColor = UIColor.darkGrayColor()
                endTime = NSDate().dateByAddingTimeInterval(startTime)
                print(sets)
                numbSetsTextField.text = sets.description
                updateLabels()
                playAudioWorkout()
                }
            }
        }
        
    }

    @IBAction func cancelWorkout(sender: AnyObject) {
        
        timer.invalidate()
        setTimeTextField.text = ""
        breakTimeTextField.text = ""
        numbSetsTextField.text = ""
        
        
    }
    // MARK: - ViewController Setup
    func playAudioWorkout() {
        var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("go", ofType: "wav")!)

        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: alertSound, error: &error)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    func playAudioBreak() {
        var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("stopRest", ofType: "wav")!)

        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: alertSound, error: &error)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func updateLabels() {
        if numbSetsTextField.text == "1" {
            numbSetsTextField.backgroundColor = UIColor.orangeColor()
            
        }else if numbSetsTextField.text == "0" {
            numbSetsTextField.backgroundColor = UIColor.redColor()
        }
        
    }
    //dismiss keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
            case 0:
            return 3
            default:
            return 1
        }
    }

}
// MARK - Time Extension
extension NSTimeInterval {
    var time:String {
        return String(format:"%02d:%02d", Int((self) % 60 ),Int(self*100 % 100 )  )
    }
}
