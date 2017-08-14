//
//  SaveEntryViewController.swift
//  microtime.tracker
//
//  Created by Eni Sinanaj on 21/11/2016.
//  Copyright © 2016 Eni Sinanaj. All rights reserved.
//

import UIKit

class SaveEntryViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var areaTextField: UITextField!
    
    var time: Double = 0
    var timeAsText: String!
    weak var allEntriesDelegate: AllEntriesViewController!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }

    @IBAction func CancelClick(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let sql = SQLiteProxy();
        
        sql.initDB();
        let _ = sql.insertData(startTime: timeAsText!, duration: Int64(time), info: descriptionTextField.text!, category: areaTextField.text!);
        
        allEntriesDelegate.reloadData();
        
        self.dismiss(animated: true, completion:  nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
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
