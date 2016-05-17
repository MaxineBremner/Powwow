import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation 

class ShowsViewContoller: UIViewController {
    
    var shows = [Show]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(.GET, "http://kylegoslan.co.uk/powwow/programs.php").response { request, response, data, error in
            if let data = data {
                let json = JSON(data: data)
                for program in json["Programs"].arrayValue {
                    let newShow = Show(data: program)
                    self.shows.append(newShow)
                }
                
                self.tableView.reloadData()
            }
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowChat" {
            let vc = segue.destinationViewController as! ChatViewController
            vc.show = sender as! Show
        }
    }

}


extension ShowsViewContoller: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let show = shows[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        

        let cellTitleLabel = cell?.viewWithTag(1) as! UILabel
        cellTitleLabel.text = show.title + " \(show.id)"
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
}

extension ShowsViewContoller: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let show = shows[indexPath.row]
        performSegueWithIdentifier("ShowChat", sender: show)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    

    
}
