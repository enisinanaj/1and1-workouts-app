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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.frame.size.width = self.view.frame.size.width
        
        var frame = mainPage.view.frame
        frame.origin.x = 0
        frame.origin.y = 0
        frame.size.width = self.view.frame.size.width
        frame.size.height = self.view.frame.size.height
        
        mainPage.view.frame = frame
        
        self.addChildViewController(mainPage)
        self.scrollView.addSubview(mainPage.view)
        mainPage.didMove(toParentViewController: self)
        
        frame = allEntriesViewController.view.frame
        frame.origin.x = self.view.frame.width
        frame.origin.y = 0
        frame.size.width = self.view.frame.size.width
        frame.size.height = self.view.frame.size.height
        
        allEntriesViewController.view.frame = frame
        
        self.addChildViewController(allEntriesViewController);
        self.scrollView.addSubview(allEntriesViewController.view)
        allEntriesViewController.didMove(toParentViewController: self)
        
        self.mainPage.allEntriesDelegate = self.allEntriesViewController;
        
        self.scrollView.contentSize = CGSize(width:
            mainPage.view.frame.size.width + allEntriesViewController.view.frame.size.width
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

