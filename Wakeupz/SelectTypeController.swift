import Foundation
import UIKit
var oneMoreTime:Bool = true

class SelectTypeController: UITableViewController {

    override func viewDidLoad() {
        if oneMoreTime {
            self.showAlert()
            oneMoreTime = false
        }
    }
    
    @IBAction func showAlert() {
        let alertController = UIAlertController(title: "You made it!", message: "Tap 'New Smart Alarm' if you're waking up for an event, or any activity that requires travel. Otherwise, tap 'New Standard Alarm'", preferredStyle: .actionSheet)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
