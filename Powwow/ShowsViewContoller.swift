import UIKit
import Alamofire
import SwiftyJSON

class ShowsViewContoller: UIViewController {
    
    var shows = [Show]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(.GET, "http://kylegoslan.co.uk/shows.json").response { request, response, data, error in
            if let data = data {
                let json = JSON(data: data)
                
                for show in json {
                    let newShow = Show(data: show.1)
                    self.shows.append(newShow)
                }
                
                self.tableView.reloadData()
            }
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
    
    
}
