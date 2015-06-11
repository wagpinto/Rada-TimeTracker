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
    
    @IBOutlet weak var setTimeTextField: UITextField!
    @IBOutlet weak var numbSetsTextField: UITextField!
    @IBOutlet weak var breakTimeTextField: UITextField!
    
    var sets: Int = 0
    
    var needBreak : Bool = true
    var timer = NSTimer()
    var startTime = NSTimeInterval()
    var breakTime = NSTimeInterval()
    var endTime = NSDate().dateByAddingTimeInterval(0)
    
    var audioPlayer = AVAudioPlayer()

    //MARK: - METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Workout Actions:
    @IBAction func startWorkout(sender: AnyObject) {
        //check textfields setup:
        if setTimeTextField.text.isEmpty || numbSetsTextField.text.isEmpty || breakTimeTextField.text.isEmpty {
            println("Select reps and breakTime")
            var alert = UIAlertView(title: "No Reps Setup", message: "Please setup workout Reps, breakTime and Time.", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }else {
            //setup the number of sets
            sets = numbSetsTextField.text.toInt()!
            var doubleTime = NSString(string: setTimeTextField.text!).doubleValue
            startTime = doubleTime

            //setup the breakTime
            var doubleBreak = NSString(string: breakTimeTextField.text!).doubleValue
            breakTime = doubleBreak
            needBreak =  false
            
            //timer schedule fires
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "countDownTime", userInfo: nil, repeats: true)
            //loop
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
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
                var alert = UIAlertView(title: "Workout is DONE", message: "The workout is over, you should rest.", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            
            }else {
                
                if needBreak == true {
                endTime = NSDate().dateByAddingTimeInterval(breakTime)
                println(sets)
                numbSetsTextField.text = sets.description
                updateLabels()
                timeLabel.backgroundColor = UIColor.redColor()
                needBreak = false
                playAudio()
                }
                else
                {
                needBreak = true
                timeLabel.backgroundColor = UIColor.darkGrayColor()
                endTime = NSDate().dateByAddingTimeInterval(startTime)
                println(sets)
                numbSetsTextField.text = sets.description
                updateLabels()
                playAudio()
                }
            }
        }
    }

    func countDownBreak() {
        

        
    }
    
    func playAudio() {
        var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("chime", ofType: "wav")!)
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
        if numbSetsTextField.text == "1" {
            numbSetsTextField.backgroundColor = UIColor.orangeColor()
            
        }else if numbSetsTextField.text == "0" {
            numbSetsTextField.backgroundColor = UIColor.redColor()
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
