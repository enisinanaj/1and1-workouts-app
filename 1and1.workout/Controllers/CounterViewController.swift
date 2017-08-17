//
//  CounterViewController.swift
//  1and1.workout
//
//  Created by Eni Sinanaj on 17/08/2017.
//  Copyright © 2017 Eni Sinanaj. All rights reserved.
//

import UIKit

class CounterViewController: UIViewController {
    
    var parentController: MainPageViewController?
    
    var minutes = 0
    var seconds = 0
    var timer: Timer!
    
    var timeKeeper: Double = 0.0
    var startSeconds: Double = 0.0
    var sectionSeconds: Double = 0.0
    var differenceInSecconds: Double = 0.0
    
    @IBOutlet weak var ShadowView: GradientView!
    
    @IBOutlet weak var secondHand: UILabel!
    @IBOutlet weak var minuteHand: UILabel!
    var running: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ShadowView.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.45).cgColor, UIColor.black.withAlphaComponent(0).cgColor]
        ShadowView.gradientLayer.gradient = GradientPoint.bottomTop.draw()
    }
    
    
    @IBAction func stopTimerAction(_ sender: Any) {
        stopTime();
        
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
        
        self.resetTimerCounters()
        sectionSeconds = getIntervalFromStartTime()
        parentController?.completeExercise()
        self.dismiss(animated: true, completion: nil)
    }
    
    func resetTimerCounters() {
        minutes = 0
        seconds = 0
        
        minuteHand.text = "00"
        secondHand.text = "00"
    }
    
    func update() {
        if (parentController?.exercise?.duration == self.timeKeeper) {
            stopTime()
        }
        
        self.timeKeeper += 1
        incrementSeconds()
        
        minuteHand.text = getAsString(timePart: minutes)
        secondHand.text = getAsString(timePart: seconds)
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
