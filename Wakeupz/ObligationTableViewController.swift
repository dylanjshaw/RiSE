//
//  ObligationTableViewController.swift
//  Wakeupz
//
//  Created by Tiffany Huey on 3/18/17.
//  Copyright © 2017 F4. All rights reserved.
//

import UIKit
import CoreData

class ObligationTableViewController: UITableViewController {
    
    var places = ["DBC", "Home", "Work", "Gym", "Church" ]
    var addresses = ["707 Broadway Ave | San Diego, CA | 92101", "707 Broadway Ave | San Diego, CA | 92101", "707 Broadway Ave | San Diego, CA | 92101", "707 Broadway Ave | San Diego, CA | 92101", "707 Broadway Ave | San Diego, CA | 92101"]

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var newObligationName: UITextField!
    @IBOutlet weak var myDatePicker: UIDatePicker!
    @IBOutlet weak var newAddress: UITextField!
    @IBOutlet weak var newEstimatedDriveDuration: UITextField!
    // avg reaady duration

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    func setObligationValues() {
        let obligation = NSEntityDescription.insertNewObject(forEntityName: "Obligation", into: self.context)
        
        obligation.setValue(newObligationName.text, forKey: "name")
        
        obligation.setValue(newAddress.text, forKey: "address")
        
        let stringEstDriveDuration = newEstimatedDriveDuration.text
        let intEstDriveDuration = Int(stringEstDriveDuration!)
        obligation.setValue(intEstDriveDuration, forKey: "estimatedDrivingDuration")
        
        obligation.setValue(myDatePicker.date, forKey: "idealArrivalTime")
    }
    
    @IBAction func handleAddNewObligation(_ sender: UIButton) {
        setObligationValues()
        
        do {
            try context.save()
            print("hello")
        } catch {
            print("oopsies didn't work")
        }
    }
}
