import UIKit
import Alamofire
import SwiftyJSON
import MessageUI

class ChatViewController: UIViewController {
    
    var messages = [Message]()
    var show: Show!
    var timer: NSTimer?
    var user = NSUserDefaults.standardUserDefaults().valueForKey("User") as! String

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateChat()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        
        textField.becomeFirstResponder()
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
                    self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.messages.count - 1, inSection: 0), atScrollPosition: .Bottom, animated: true)
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
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        print(keyboardFrame)
        UIView.animateWithDuration(0.5, animations: {
            self.bottomConstraint.constant = keyboardFrame.size.height + 20
        })
    }
    
}


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

/*bit that I have inserted keyboard but doesn't work attempt:1

    func animateTextField(textField: UITextField, up:Bool, withOffset offset: CGFloat) {
        
        let movementDistance : Int = -Int(offset)
        let movementDuration : Double = 0.4
        let movement : Int = (up ? movementDistance : -movementDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(movementDuration)
        self.view.frame = CGRectOffset(self.view.frame, 0, CGFloat(movement)
       // UIView.commitAnimations()
    }

    func textFieldDidBegingEditing(textField: UITextField) {
        
        self.animateTextField(textField, up: true, withOffset: textField.frame.origin.y / 2)
    }

    func textFieldDidEndEditing(textField: UITextField) {
    
        self.animateTextField(textField: up: false, withOffset: textField.frame.origin.y / 2)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
*/
        




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



