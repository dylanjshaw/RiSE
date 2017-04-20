import UIKit
import CoreData
import MapKit
var oneLove:Bool = true

class createAlarmViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var earliestWakeupTime: UIDatePicker!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var isOn: UISwitch!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var createButtonAppearance: UIButton!
    @IBOutlet weak var submitButtonAppearance: UIButton!
    
    
    var obligations: [Obligation] = []
    var obligationSelection = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.dataSource = self
        picker.delegate = self
        
        earliestWakeupTime.setValue(UIColor.white, forKeyPath: "textColor")

        if oneLove {
            self.showAlert()
            oneLove = false
        }
        
        createButtonAppearance.layer.cornerRadius = 8
        submitButtonAppearance.layer.cornerRadius = 8
    }
    
    func getData() {
        
        let obligationFetch: NSFetchRequest<Obligation> = Obligation.fetchRequest()
        let obligationSort = NSSortDescriptor(key: "createdAt", ascending: false)
        obligationFetch.sortDescriptors = [obligationSort]
        
        do {
            obligations = try context.fetch(obligationFetch)
            print("obligations fetched")
            print(obligations)
        } catch {
            print("Fetching failed")
        }
    }
    
    func removeNilValues(arrayOf: inout [Obligation]) -> [Obligation] {
        for element in arrayOf {
            if element.name == nil {
                var index = arrayOf.index(of: element)
                arrayOf.remove(at: index!)
            }
        }
        return arrayOf
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        obligations = removeNilValues(arrayOf: &obligations)
        picker.reloadAllComponents()
    }
    
//    Setup for location picker 
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: obligations[row].name!, attributes: [NSForegroundColorAttributeName:UIColor.white])
    }

    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let obligation = obligations[row]
        return obligation.name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return obligations.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        obligationSelection = row
    }

    
    let locationManager = CLLocationManager()
    var userLocation = CLLocation()
    
    func calculateWakeup() -> Date {
        return Date(timeIntervalSinceNow: 0)
//        // get the selected obligation
//        let ob = obligations[obligationSelection]
//        
//        // get some attributes and store them
//        let addressTo = ob.address
//        let timeArriveBy = ob.idealArrivalTime
//        let timeTilReady = ob.avgReadyTime
//        
//        // check if locations services are on
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            // ask permission to use location services
//            locationManager.requestAlwaysAuthorization()
//        
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//        }
//        
//        let geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(addressTo!, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
//            
//            if placemarks != nil && placemarks!.count > 0 {
//                let destinationPlacemark = MKPlacemark(placemark: (placemarks?[0])!)
//                let request = MKDirectionsRequest()
//                request.source = MKMapItem(placemark: MKPlacemark(
//                    coordinate: CLLocationCoordinate2D(
//                        latitude: self.userLocation.coordinate.latitude,
//                        longitude: self.userLocation.coordinate.longitude
//                ))
//                )
//                request.destination = MKMapItem(placemark: destinationPlacemark)
//                request.transportType = .automobile
//                
//                let directions = MKDirections(request: request)
//                
//                directions.calculateETA(completionHandler: {(response: MKETAResponse?, error: Error?) -> Void in
//                    
//                    print("TIME TO TRAVEL \(response?.expectedTravelTime)")
//                    
//                    let calculated = timeArriveBy?.addingTimeInterval(((response?.expectedTravelTime)! + TimeInterval(timeTilReady) * 60) * -1) as! Date
//                    print("THIS IS CALCULATED  \(calculated)")
//                })
//            }
//        })
//        return Date()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        userLocation = locations[0] as! CLLocation
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func showMessage() {
        let alertController = UIAlertController(title: "Easy there, cowboy!", message: "Make sure that you've entered a destination.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func setAlarmValues() {
        let alarm = NSEntityDescription.insertNewObject(forEntityName: "Alarm", into: self.context)
        
        // let updatedWakeupTime = calculateWakeup()
        // remember to remove Date() from below
        alarm.setValue(calculateWakeup(), forKey: "calculatedWakeup")
        alarm.setValue(earliestWakeupTime.date, forKey: "earliestWakeup")
        alarm.setValue(true, forKey: "isSmart")
        
        var obligationSelected = obligations[obligationSelection]
        
        func validateObligation() -> Bool {
            if(obligationSelected.name == ""){
                print(obligationSelected)
                return false
            } else {
                print(obligationSelected)
                return true
            }
        }
        
        if validateObligation(){
            alarm.setValue(obligationSelected, forKey: "obligation")
            alarm.setValue(Date(), forKey: "createdAt")
        } else {
            showMessage()
        }
        
    }

        
    
    @IBAction func handleAddNewAlarm(_ sender: UIButton) {
        setAlarmValues()
        
        do {
            try context.save()
            print("saved")
        } catch {
            print("alarm did not save")
        }
    }
    

    @IBAction func showAlert() {
        let alertController = UIAlertController(title: "Where you goin'?", message: "Where is your event located? If you don't see your destination, add one by tapping 'Create new destination'.", preferredStyle: .actionSheet)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
   
    @IBAction func scrollUpButton(_ sender: Any) {
        scrollUp()
    }
    
  
    @IBAction func scrollDownButton(_ sender: Any) {
        scrollDown()
    }
    
    func scrollUp(){
        let topOffset = CGPoint(x: 0, y: 0)
        self.scrollView.setContentOffset(topOffset, animated: true)
    }
    
    func scrollDown(){
        let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
        self.scrollView.setContentOffset(bottomOffset, animated: true)
    }
    

    
    
    //TRY TO FIND A WAY TO CHECK PREVIOUS VIEW CONTROLLER
    
//        func backViewController() -> UIViewController? {
//            if let stack = self.navigationController?.viewControllers {
//                for i in (1..<stack.count).reversed() {
//                    if(stack[i] == self) {
//                        return stack[i-1]
//                    }
//                }
//            }
//            return nil
//        }

}







