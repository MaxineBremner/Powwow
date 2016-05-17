import UIKit
import Alamofire
import SwiftyJSON
import MessageUI
import CoreLocation

class ChatViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    var messages = [Message]()
    var show: Show!
    var timer: NSTimer?
    var user = NSUserDefaults.standardUserDefaults().valueForKey("User") as! String
    var keyboardDismissTapGesture: UIGestureRecognizer?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateChat()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
       
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        
        textField.becomeFirstResponder() //this makes the keyboard appear straight away
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "updateChat", userInfo: nil, repeats: true)

    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer!.invalidate()
    }
    
    

    func updateChat() {
        Alamofire.request(.POST, "http://kylegoslan.co.uk/powwow/messages.php", parameters: ["program_id": "\(show.id)"]).response { request, response, data, error in
            if let data = data {
                let json = JSON(data: data)
                self.messages.removeAll()
                for message in json["Messages"].arrayValue {
                    let newMessage = Message(data: message)
                    self.messages.append(newMessage)
                }
                
                self.tableView.reloadData()
                if self.messages.count > 0 {
                    self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.messages.count - 1, inSection: 0), atScrollPosition: .Bottom,  animated: true)
                }
            }
        }
    }
    
    
    @IBAction func sendMessage(sender: AnyObject) {
        
        guard let message = textField.text where !textField.text!.isEmpty else {
            return
        }
        
        let parameters = [
            "program_id": "\(show.id)",
            "message": message,
            "user": user
        ]
        
        Alamofire.request(.POST, "http://kylegoslan.co.uk/powwow/new-message.php", parameters: parameters).response { request, response, data, error in
            self.updateChat()
            self.textField.text = nil
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if keyboardDismissTapGesture == nil {
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard:"))
            self.view.addGestureRecognizer(keyboardDismissTapGesture!)
            let info = notification.userInfo!
            let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            print(keyboardFrame)
            UIView.animateWithDuration(0.5, animations: {
            self.bottomConstraint.constant = keyboardFrame.size.height + 5
            })
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification){
        if keyboardDismissTapGesture != nil
        {
            self.view.removeGestureRecognizer(keyboardDismissTapGesture!)
            keyboardDismissTapGesture = nil
            let info = notification.userInfo!
            let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            print(keyboardFrame)
            UIView.animateWithDuration(0.5, animations: {
                self.bottomConstraint.constant = keyboardFrame.size.height + 5
            })
        }
        
    }
        
    func dismissKeyboard(sender: AnyObject) {
          textField?.resignFirstResponder()
        }
    }

    /*
    
    // kyle's
    func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        print(keyboardFrame)
        UIView.animateWithDuration(0.5, animations: {
            self.bottomConstraint.constant = keyboardFrame.size.height + 5
        })
    }

*/
    

extension ChatViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! MessageCell
        cell.message = message
        cell.updateView()
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
}





extension ChatViewController: UITableViewDelegate {

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
            print(newLocation)
        }
        
    }
    
}


