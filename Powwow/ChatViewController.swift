import UIKit
import Alamofire
import SwiftyJSON

class ChatViewController: UIViewController {
    
    var messages = [Message]()
    var show: Show!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateChat()
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
        
        let parameters = [
            "program_id": "\(show.id)",
            "message": "some new message"
        ]
        
        Alamofire.request(.POST, "http://kylegoslan.co.uk/powwow/new-message.php", parameters: parameters).response { request, response, data, error in
            self.updateChat()
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
