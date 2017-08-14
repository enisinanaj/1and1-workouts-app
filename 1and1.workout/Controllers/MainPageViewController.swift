//
//  MainPageViewController.swift
//  microtime.tracker
//
//  Created by Eni Sinanaj on 29/10/2016.
//  Copyright © 2016 Eni Sinanaj. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class MainPageViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var minutesHand: UILabel!
    @IBOutlet weak var secondsHand: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    weak var allEntriesDelegate: AllEntriesViewController?
    
    var minutes = 0
    var seconds = 0
    var hours = 0
    var timer: Timer!
    
    var timeKeeper: Double = 0.0
    var startSeconds: Double = 0.0
    var sectionSeconds: Double = 0.0
    var differenceInSecconds: Double = 0.0
    
    var running: Bool!
    
    func startTime(_ sender: AnyObject) {
        running = true
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
        self.startSeconds = CACurrentMediaTime()
        self.differenceInSecconds = 0.0
        self.resetTimerCounters()
        
        startButton.isHidden = true
        stopButton.isHidden = false
    }
    
    func stopTime(_ sender: AnyObject) {
        timer.invalidate()
        running = false
        
        let saveEntryDialog = SaveEntryViewController(nibName: "SaveEntryViewController", bundle: nil)
        saveEntryDialog.time = sectionSeconds
        saveEntryDialog.timeAsText = (timeLabel!.text  ?? "").appending("H ")
                .appending(minutesHand!.text  ?? "").appending("M ")
                .appending(secondsHand?.text ?? "").appending("S")
        saveEntryDialog.allEntriesDelegate = self.allEntriesDelegate
        
        self.resetTimerCounters()
        sectionSeconds = getIntervalFromStartTime()
        
        self.present(saveEntryDialog, animated: true, completion: nil)
        
        stopButton.isHidden = true
        startButton.isHidden = false
    }
    
    func resetTimerCounters() {
        minutes = 0
        seconds = 0
        hours = 0
        timeLabel.text = "00"
        minutesHand.text = "00"
        secondsHand.text = "00"
    }
    
    @IBAction func stopTimerAction(_ sender: AnyObject) {
        stopTime(sender)
    }
    
    @IBAction func startTimerAction(_ sender: AnyObject) {
        startTime(sender)
    }
    
    func update() {
        self.timeKeeper += 1
        incrementSeconds()
        playBeep()
        timeLabel.text = getAsString(timePart: hours)
        minutesHand.text = getAsString(timePart: minutes)
        secondsHand.text = getAsString(timePart: seconds)
    }
    
    func playBeep() {
        let interval: Double = getIntervalFromStartTime()
        
        print("interval in seconds: " + String(interval))
        
        if (interval == 5) {
            //TODO: play notification aufio every half an hour?
        }
    }
    
    func getIntervalFromStartTime() -> Double {
        return CACurrentMediaTime() - startSeconds
    }
    
    func incrementMinutes() {
        if (minutes == 59) {
            minutes = 0
            incrementHours()
        } else {
            minutes += 1
        }
    }
    
    func incrementHours() {
        if (hours == 23) {
            hours = 0
        } else {
            hours += 1
        }
    }
    
    func incrementSeconds() {
        if (seconds == 59) {
            seconds = 0
            incrementMinutes()
        } else {
            seconds += 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidBecomeActive, object: nil, queue: OperationQueue.main, using: self.reloadTimer)
        
        stopButton.isHidden = true
    }
    
    func reloadTimer(notification: Notification) {
        differenceInSecconds = CACurrentMediaTime() - self.startSeconds
        
        let hoursD = floor(differenceInSecconds / (60.0 * 60.0))
        
        let divisorForMinutes = differenceInSecconds.truncatingRemainder(dividingBy: (60.0 * 60.0))
        let minutesD = floor(divisorForMinutes / 60.0)
        
        let divisorForSeconds = divisorForMinutes.truncatingRemainder(dividingBy: 60.0)
        let secondsD = ceil(divisorForSeconds)
        
        print ("application restored at: " + String(CACurrentMediaTime()))
        print ("startTime: " + String(self.startSeconds))
        print ("differenceInSeconds: " + String(CACurrentMediaTime() - self.startSeconds))
        print ("hoursD: " + String(hoursD))
        print ("minutesD: " + String(minutesD))
        print ("secondsD: " + String(secondsD))
        
        if self.startSeconds > 0.0 {
            self.seconds = Int(secondsD)
            self.minutes = minutesD > 1 ? Int(minutesD) : self.minutes
            self.hours = hoursD > 1 ? Int(hoursD) : self.hours
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAsString(timePart: NSInteger) -> String {
        if (timePart == 0) {
            return "00"
        } else if (timePart > 0 && timePart < 10) {
            return "0" + String(timePart)
        } else {
            return String(timePart)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
