import UIKit
import Alamofire
import SwiftyJSON
import MessageUI
import CoreLocation


class ChatViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var locationDistance: Int?
    
    var messages = [Message]()
    var show: Show!
    var timer: NSTimer?
    var user = NSUserDefaults.standardUserDefaults().valueForKey("User") as! String
    var keyboardDismissTapGesture: UIGestureRecognizer?
    var currentLocation: CLLocation?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        
        tableView.backgroundColor = .clearColor()
        
        textField.becomeFirstResponder() //this makes the keyboard appear straight away
    
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        locationDistance = NSUserDefaults.standardUserDefaults().integerForKey("Distance")
        
        if locationDistance == nil {
            locationDistance = 1000
        }
        
        updateChat()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "updateChat", userInfo: nil, repeats: true)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer!.invalidate()
    }


    func updateChat() {
        Alamofire.request(.POST, "http://178.62.89.129/messages.php", parameters: ["program_id": "\(show.id)"]).response { request, response, data, error in
            if let data = data {
                let json = JSON(data: data)
                self.messages.removeAll()
                
  //make it so any new message that is past 1 hour will be filtered
                for message in json["Messages"].arrayValue {
                    let newMessage = Message(data: message)
                    if newMessage.sentTime < 01:00:00 {
                        self.filterMessages(newMessage)
                    }
                }

                self.tableView.reloadData()

                //check to see if tableview is at the bottom
                
                if self.messages.count > 0 {
                    self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.messages.count - 1, inSection: 0), atScrollPosition: .Bottom, animated: true)
                }
            }
        }
    }
    
    
    func filterMessages(message: Message) {
        
        guard let location = message.location else { return }
        
        if let currentLocation = currentLocation {
            if Int(location.distanceFromLocation(currentLocation) / 1000) < locationDistance! {
                messages.append(message)
            }
        }
    }
    
    
    @IBAction func sendMessage(sender: AnyObject) {
        
        guard let message = textField.text where !textField.text!.isEmpty else {
            return
        }
        
        var parameters = [
            "program_id": "\(show.id)",
            "message": message,
            "user": user,
        ]
        
        if let currentLocation = currentLocation {
            parameters["lat"] = "\(currentLocation.coordinate.latitude)"
            parameters["lng"] = "\(currentLocation.coordinate.longitude)"
        }
        
        Alamofire.request(.POST, "http://178.62.89.129/new-message.php", parameters: parameters).response { request, response, data, error in
            self.updateChat()
            self.textField.text = nil
        }
    }
    
    //additional keyboard now
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("layout subviews")
    }
    
   func keyboardWillShow(notification: NSNotification) {
    
        if keyboardDismissTapGesture == nil {
            
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard:"))
            self.view.addGestureRecognizer(keyboardDismissTapGesture!)
            let info = notification.userInfo!
            let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            UIView.animateWithDuration(0.5, animations: {
            self.bottomConstraint.constant = keyboardFrame.size.height + 5
            })
        }
        
    }
    
   func keyboardWillHide(notification: NSNotification){
    
        if keyboardDismissTapGesture != nil {
            
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: Selector("showKeyboard:"))
            self.view.removeGestureRecognizer(keyboardDismissTapGesture!)
            keyboardDismissTapGesture = nil
            let info = notification.userInfo!
            let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            UIView.animateWithDuration(0.5, animations: {
            self.bottomConstraint.constant = keyboardFrame.size.height - 5
            
            })
        }
        
    }
        
    func dismissKeyboard(sender: AnyObject) {
          textField?.resignFirstResponder()
    }
}

    

extension ChatViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! MessageCell
        cell.message = message
        cell.updateView(currentLocation)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
}

extension ChatViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! MessageCell
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! MessageCell
        cell.selectedState()
    }

}


extension ChatViewController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.characters.count > 0 {
            sendButton.enabled = true
        } else {
            sendButton.enabled = false
        }
        return true
    }
}

extension ChatViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocation = locations.last
        
        if let newLocation = newLocation {
            currentLocation = newLocation
        }
        
    }
    
}


