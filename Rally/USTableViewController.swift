//
//  USTableViewController.swift
//  Rally
//
//  Created by Tony Greway on 2/5/21.
//

import UIKit
import SwiftyJSON

class USTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var usTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        loadDetails()
    }
    
    var userStories:[JSON] = [JSON()]
    var searchingStories:[JSON] = [JSON()]
    
    func loadDetails(){
        print("loading")
        let rest: RallyRestClient = RallyRestClient.instance
        let parameters: [String: String] = [ "fetch": "true" ]
        rest.get(path: "/slm/webservice/v2.x/hierarchicalrequirement", queryParams: parameters) { (stories) in
            let arry = stories["QueryResult"]["Results"].arrayValue
            self.userStories = arry
            self.searchingStories = arry
            self.usTable.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchingStories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storyCell", for: indexPath)

        let story = self.searchingStories[indexPath.row]
        let fid = story["FormattedID"].stringValue
        let name = story["Name"].stringValue
        cell.textLabel!.text = "(\(fid)) \(name)"

        return cell
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("prefix \(searchText)")
        if(searchText == "" ) {
            searchBarCancelButtonClicked(searchBar)
        }
        else {
            searchingStories = self.userStories.filter({$0["Name"].stringValue.lowercased().contains(searchText.lowercased())})
            self.usTable.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchingStories = userStories
        self.usTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchingStories = userStories
        self.usTable.reloadData()
    }

}
