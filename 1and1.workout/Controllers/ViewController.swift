//
//  ViewController.swift
//  microtime.tracker
//
//  Created by Eni Sinanaj on 29/10/2016.
//  Copyright © 2016 Eni Sinanaj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    let allEntriesViewController = AllEntriesViewController(nibName: "AllEntriesViewController", bundle: nil)
    let mainPage = MainPageViewController(nibName: "MainPageViewController", bundle: nil)
    let exercisesPage = ExercisesTableViewController(nibName: "ExercisesTableView", bundle: nil)
    
    fileprivate func addExercisesListPage() {
        exercisesPage.view.frame.origin.x = self.view.frame.width
        exercisesPage.view.frame.origin.y = 0
        exercisesPage.view.frame.size.width = self.view.frame.size.width
        exercisesPage.view.frame.size.height = self.view.frame.size.height
        
        self.addChildViewController(exercisesPage)
        self.scrollView.addSubview(exercisesPage.view)
        exercisesPage.didMove(toParentViewController: self)
    }
    
    fileprivate func addTimerPage() {
        mainPage.view.frame.origin.x = self.view.frame.width * 2
        mainPage.view.frame.origin.y = 0
        mainPage.view.frame.size.width = self.view.frame.size.width
        mainPage.view.frame.size.height = self.view.frame.size.height
        
        self.addChildViewController(mainPage)
        self.scrollView.addSubview(mainPage.view)
        mainPage.didMove(toParentViewController: self)
    }
    
    fileprivate func addAllEntriesPage() {
        allEntriesViewController.view.frame.origin.x = 0
        allEntriesViewController.view.frame.origin.y = 0
        allEntriesViewController.view.frame.size.width = self.view.frame.size.width
        allEntriesViewController.view.frame.size.height = self.view.frame.size.height
        
        self.addChildViewController(allEntriesViewController);
        self.scrollView.addSubview(allEntriesViewController.view)
        allEntriesViewController.didMove(toParentViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(super.view.frame)
        
        self.scrollView.frame.size.width = self.view.frame.size.width
        self.scrollView.frame.size.height = self.view.frame.size.height
        self.scrollView.contentOffset = CGPoint(x: self.view.frame.width, y: 0)
        
        addExercisesListPage()
        addTimerPage()
        addAllEntriesPage()
        
        self.mainPage.allEntriesDelegate = self.allEntriesViewController;
        
        self.scrollView.contentSize = CGSize(width:
                mainPage.view.frame.size.width +
                allEntriesViewController.view.frame.size.width +
                exercisesPage.view.frame.size.width
            , height: self.scrollView.frame.size.height)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if (motion == .motionShake) {
            let refreshAlert = UIAlertController(title: "Delete all entries",
                                                 message: "Are you sure you want to delete all entries? This action is undoable and will result all data will be lost.",
                                                 preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                let sql = SQLiteProxy();
                
                sql.initDB();
                sql.deleteAllRows();
                
                self.allEntriesViewController.reloadData()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

}

