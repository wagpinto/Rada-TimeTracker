//
//  CountDownTableViewController.swift
//  Rada-XTracker
//
//  Created by Wagner Pinto on 6/1/15.
//  Copyright (c) 2015 weeblu.co llc. All rights reserved.
//

import UIKit
import AVFoundation

class CountDownTableViewController: UITableViewController {

    //MARK: - PROPERTIES
    @IBOutlet weak var happyButton: UIButton!
    @IBOutlet weak var normalButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!
    
    @IBOutlet weak var startWorkOut: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var breaksTextField: UITextField!
    
    var workouts: Int = 0
    var breaks: Int = 0
    
    var timer = NSTimer()
    var startTime = NSTimeInterval()
    var endTime = NSDate().dateByAddingTimeInterval(0)
    
    var audioPlayer = AVAudioPlayer()

    //MARK: - METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        countDownLoop()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Workout Actions:
    @IBAction func startWorkout(sender: AnyObject) {
        //check textfields setup:
        if repsTextField.text.isEmpty || breaksTextField.text.isEmpty || timeTextField.text.isEmpty {
            println("Select reps and breaks")
            var alert = UIAlertView(title: "No Reps Setup", message: "Please setup workout Reps, Breaks and Time.", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }else {
            workouts = repsTextField.text.toInt()!
            breaks = breaksTextField.text.toInt()!
            
            var doubleTime = NSString(string: timeTextField.text!).doubleValue
            startTime = doubleTime

            //timer schedule fires
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "countDownTime", userInfo: nil, repeats: true)
            //loop
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        }
    }
    
    func countDownLoop () {
        var iniiTime = 0
        var endTime = 10
        
        for i in (1...10) {
            initTime++
            println("RADAMES \(initTime)")
        }
    }
    
    
    func countDownTime() {
        let remainedTime = endTime.timeIntervalSinceNow
        timeLabel.text = remainedTime.time
        
        if remainedTime <= 0 {
            workouts--
            if workouts == -1 {
                timer.invalidate()
                var alert = UIAlertView(title: "Workout is DONE", message: "The workout is over, you should rest.", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            
            }else {
                endTime = NSDate().dateByAddingTimeInterval(startTime)
                println(workouts)
                repsTextField.text = workouts.description
                updateLabels()
                //playAudio()
            }
        }
    }

    func countDownBreak() {
        

        
    }
    func playAudio() {
        var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("button-09", ofType: "wav")!)
        println(alertSound)
        
        // Removed deprecated use of AVAudioSessionDelegate protocol
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: alertSound, error: &error)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    func updateLabels() {
        if repsTextField.text == "1" {
            repsTextField.backgroundColor = UIColor.orangeColor()
            
        }else if repsTextField.text == "0" {
            repsTextField.backgroundColor = UIColor.redColor()
        }
        
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
