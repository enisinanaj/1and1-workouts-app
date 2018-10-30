//
//  CounterViewController.swift
//  1and1.workout
//
//  Created by Eni Sinanaj on 17/08/2017.
//  Copyright © 2017 Eni Sinanaj. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class CounterViewController: UIViewController {
    
    var parentController: MainPageViewController?
    
    var minutes = 0
    var seconds = 0
    var timer: Timer!
    
    var sets: Int = 1
    
    var timeKeeper: Double = 0.0
    var startSeconds: Double = 0.0
    var sectionSeconds: Double = 0.0
    var differenceInSecconds: Double = 0.0
    
    var restMinuteConsumed: Bool = false
    var player: AVAudioPlayer?
    
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    
    @IBOutlet weak var secondHand: UILabel!
    @IBOutlet weak var minuteHand: UILabel!
    var running: Bool!
    @IBOutlet weak var baseWindowView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseWindowView.layer.cornerRadius = 20.0
        baseWindowView.backgroundColor = UIColor.white
        baseWindowView.layer.shadowOffset = .zero
        baseWindowView.layer.shadowOpacity = 0.2
        baseWindowView.layer.shadowRadius = 10
        baseWindowView.layer.shadowColor = UIColor.black.cgColor
        baseWindowView.layer.masksToBounds = false
        
        restLabel.isHidden = true
    }
    
    @IBAction func restartNewSet(_ sender: Any) {
        if running {
            return
        }
        
        sets = sets + 1
        setLabel.text = "Set " + String(sets)
        restLabel.isHidden = true
        restMinuteConsumed = false
        
        self.timeKeeper = 0
        startTime(self)
    }
    
    @IBAction func stopTimerAction(_ sender: Any) {
        let wasRunning = running
        parentController?.completeExercise(wasRunning!)
        stopTime()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func startTime(_ sender: AnyObject) {
        running = true
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        self.timeKeeper = 0
        
        self.startSeconds = CACurrentMediaTime()
        self.differenceInSecconds = 0.0
        self.resetTimerCounters()
    }
    
    func stopTime() {
        timer.invalidate()
        running = false
        restLabel.isHidden = true
        
        self.resetTimerCounters()
        sectionSeconds = (parentController?.exercise?.duration)! * Double(sets)
    }
    
    func resetTimerCounters() {
        minutes = 0
        seconds = 0
        
        minuteHand.text = "00"
        secondHand.text = "00"
    }
    
    func startRestMinute() {
        stopTime()
        restMinuteConsumed = true
        startTime(self)
        restLabel.isHidden = false
    }
    
    @objc func update() {
        if parentController?.exercise?.duration == self.timeKeeper && !self.restMinuteConsumed {
            playSound()
            startRestMinute()
        } else if parentController?.exercise?.restDuration == self.timeKeeper && self.restMinuteConsumed {
            stopTime()
        } else {
            self.timeKeeper += 1
            incrementSeconds()
            
            minuteHand.text = getAsString(timePart: minutes)
            secondHand.text = getAsString(timePart: seconds)
        }
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "doneBell.mp3", withExtension: nil)!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else {return}
            
            player.prepareToPlay()
            player.play();
        } catch let error as NSError {
            print(error.description)
        }
    }

    func getIntervalFromStartTime() -> Double {
        return CACurrentMediaTime() - startSeconds
    }
    
    func incrementMinutes() {
        if (minutes == 59) {
            minutes = 0
            if (seconds == 59) {
                seconds = 0
                resetTimerCounters()
            }
        } else {
            minutes += 1
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
    
    func reloadTimer(notification: Notification) {
        differenceInSecconds = CACurrentMediaTime() - self.startSeconds
        
        let divisorForMinutes = differenceInSecconds.truncatingRemainder(dividingBy: (60.0 * 60.0))
        let minutesD = floor(divisorForMinutes / 60.0)
        
        let divisorForSeconds = divisorForMinutes.truncatingRemainder(dividingBy: 60.0)
        let secondsD = ceil(divisorForSeconds)
        
        if self.startSeconds > 0.0 {
            self.seconds = Int(secondsD)
            self.minutes = minutesD > 1 ? Int(minutesD) : self.minutes
        }
    }
    
    func secondsToTimeString(_ seconds: NSInteger) -> (minutes: NSInteger, seconds: NSInteger) {
        let minutes = seconds / 60
        let seconds = seconds % 60
        
        return (minutes: minutes, seconds: seconds)
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
}
