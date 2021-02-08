//
//  SearchTableViewController.swift
//  Rally
//
//  Created by Tony Greway on 2/5/21.
//

import UIKit
import SwiftyJSON

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet var searchTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
    }
    
    var searchingStories:[JSON] = []
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchingStories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artifactCell", for: indexPath)

        let story = self.searchingStories[indexPath.row]
        let fid = story["FormattedID"].stringValue
        let name = story["Name"].stringValue
        cell.textLabel!.text = "(\(fid)) \(name)"

        return cell
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == "" ) {
            searchBarCancelButtonClicked(searchBar)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let rest: RallyRestClient = RallyRestClient.instance
        let parameters: [String: String] = [ "fetch": "true", "query":"(Name contains \(searchBar.text!))" ]
        rest.get(path: "/slm/webservice/v2.x/artifact", queryParams: parameters) { (stories) in
            let arry = stories["QueryResult"]["Results"].arrayValue
            self.searchingStories = arry
            self.searchTable.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchingStories = []
        self.searchTable.reloadData()
    }
}
