import UIKit
import UserNotifications
var justOnce:Bool = true


class IndexTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var alarms: [Alarm] = []
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        self.tableView.reloadData()
        
        // on load, request notifications from user
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(
            options: [.alert, .sound, .badge],
            completionHandler: { (granted,error) in
                if justOnce {
                    self.showAlert()
                    justOnce = false
                }
        })
    }
    
    
    override func viewDidLoad() {
        let navBar = view as? UINavigationBar
        navBar?.tintColor = UIColor.darkGray
        tableView.allowsSelection = false
        
//        var faicon = [String: UniChar]()
//        faicon["faglass"] = 0xf000
//        
//        let label = UILabel(frame: CGRect(x: 0, y: CGFloat(60), width: 120, height: 40))
//        label.font = UIFont(name: "FontAwesome", size:40)
//        label.text = String(format: "%C", faicon["faglass"]!)
//        self.view.addSubview(label)
    }
    
    func getData() {
        do {
            alarms = try context.fetch(Alarm.fetchRequest())
            print("That is sooo fetch")
        } catch {
            print("Fetching failed")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        return alarms.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "indexCell", for: indexPath) as! CustomIndexCell
        
        if alarms[indexPath.row].isSmart {
            cell.placeLabel.text = alarms[indexPath.row].obligation?.name
        } else {
            cell.placeLabel.text = ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let earliestWakeupString: String? = dateFormatter.string(for: alarms[indexPath.row].earliestWakeup)
        let regularWakeupString: String? = dateFormatter.string(for: alarms[indexPath.row].regularWakeup)
        
        if alarms[indexPath.row].isSmart {
            cell.timeLabel.text = earliestWakeupString!
        } else {
            cell.timeLabel.text = regularWakeupString!
        }

        cell.toggleAlarm.onTintColor = UIColor(red: (20/255.0), green: (95/255.0), blue: (244/255.0), alpha: 1.0)
        cell.toggleAlarm.tintColor = UIColor(red: (20/255.0), green: (95/255.0), blue: (244/255.0), alpha: 1.0)
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(alarms[indexPath.row])
            do {
                try context.save()
                viewWillAppear(false) 
            } catch {
                print("oops didn't save")
            }
        }
    }
        
    @IBAction func whiten() {
        let navBar = view as? UINavigationBar
        navBar?.tintColor = UIColor.white
    }
    
    @IBAction func showAlert() {
        let alertController = UIAlertController(title: "Hi there!", message: "After, tapping the 'OK' button below, tap the [+] button on the top-right corner to get started.", preferredStyle: .actionSheet)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {action in self.whiten()
        })
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
}
