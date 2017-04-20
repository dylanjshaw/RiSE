//
//  CreateObligationViewController.swift
//  Wakeupz
//
//  Created by Allison Ines on 3/19/17.
//  Copyright © 2017 F4. All rights reserved.
//

import UIKit
import CoreData

class CreateObligationViewController: UIViewController, UITextFieldDelegate {
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var newObligationName: UITextField!
    @IBOutlet weak var newAddress: UITextField!
    @IBOutlet weak var newDatePicker: UIDatePicker!
    @IBOutlet weak var avgReadyDuration: UITextField!
    @IBOutlet weak var addButtonAppearance: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        newDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
     //   avgReadyDuration.setValue(UIColor.white, forKeyPath: "textColor")
        addButtonAppearance.layer.cornerRadius = 8
        self.newObligationName.delegate = self;
        self.newAddress.delegate = self;
        self.hideKeyboard()
    }
    
    func validateName() -> Bool {
        if (newObligationName.text == "") {
            print("new obligation name fail")
            return false
        } else {
            return true
        }
    }
    
    func validateAddress() -> Bool {
        if newAddress.text == "" {
            print("new obligation address fail")
            return false
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//    func validateCharacterLength() -> Bool {
//        if (avgReadyDuration.text?.characters.count)! > 12 {
//            return false
//        } else {
//            return true
//        }
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setObligationValues() -> Bool {
        let obligation = NSEntityDescription.insertNewObject(forEntityName: "Obligation", into: self.context)
        
        if validateName() && validateAddress() {
            obligation.setValue(newObligationName.text, forKey: "name")
            obligation.setValue(newAddress.text, forKey: "address")
            // set estimatedDrivingDuration value here
            
            let avgReadyDurationInt = Int(avgReadyDuration.text!)
            obligation.setValue(avgReadyDurationInt!, forKey: "avgReadyTime")
            obligation.setValue(newDatePicker.date, forKey: "idealArrivalTime")
            obligation.setValue(Date(), forKey: "createdAt")
            
            return true
        } else {
            showAlert()
            return false
        }
    }
    
    @IBAction func handleAddNewObligation(_ sender: UIButton) {
        if setObligationValues() {
            do {
                try context.save()
                print("obligation saved!")
            } catch {
                print("oopsies didn't save")
            }
            navigationController?.popViewController(animated: true)
//            createAlarmViewController.scrollDown()
        } else {
            print("???")
        }
    }
    
    @IBAction func showAlert() {
        let alertController = UIAlertController(title: "Oops!", message: "Make sure that you've entered both a destination (max. 12 characters) and an address.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil) 
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    func scrollUp(){
        let topOffset = CGPoint(x: 0, y: 0)
        self.scrollView.setContentOffset(topOffset, animated: true)
    }
    
    func scrollDown(){
        let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
        self.scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    
    @IBAction func scrollUpButton(_ sender: Any) {
        scrollUp()
    }
    
    
    @IBAction func scrollDownButton(_ sender: Any) {
        scrollDown()
    }
    
}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
