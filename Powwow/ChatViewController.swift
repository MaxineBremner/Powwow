import UIKit
import Alamofire
import SwiftyJSON
import MessageUI

class ChatViewController: UIViewController {
    
    var messages = [Message]()
    var show: Show!
    var timer: NSTimer?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateChat()
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
            }
        }
    }
    
    
    @IBAction func sendMessage(sender: AnyObject) {
        
        guard let message = textField.text where !textField.text!.isEmpty else {
            return
        }
        
        let parameters = [
            "program_id": "\(show.id)",
            "message": message
        ]
        
        Alamofire.request(.POST, "http://kylegoslan.co.uk/powwow/new-message.php", parameters: parameters).response { request, response, data, error in
            self.updateChat()
            self.textField.text = nil
        }
    }
}


extension ChatViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let cellTitleLabel = cell?.viewWithTag(1) as! UILabel
        cellTitleLabel.text = message.message
        
        return cell!
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
