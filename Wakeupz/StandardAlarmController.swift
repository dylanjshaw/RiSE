import Foundation
import UIKit
import CoreData

class StandardAlarmController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var standardTime: UIDatePicker!
    
    @IBOutlet weak var submitButtonAppearance: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        standardTime.setValue(UIColor.white, forKeyPath: "textColor")
        submitButtonAppearance.layer.cornerRadius = 8
    }
    
    @IBAction func handleSetRegAlarm(_ sender: Any) {
        let alarm = NSEntityDescription.insertNewObject(forEntityName: "Alarm", into: self.context)
        alarm.setValue(standardTime.date, forKey: "regularWakeup")
        alarm.setValue(false, forKey: "isSmart")
        alarm.setValue(Date(), forKey: "createdAt")
        
        do {
            try context.save()
            print("standard alarm saved")
        } catch {
            print("standard alarm didn't save")
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
}





