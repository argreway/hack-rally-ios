//
//  HomeViewController.swift
//  Rally
//
//  Created by Tony Greway on 2/4/21.
//

import UIKit
import SwiftyJSON

class HomeViewController: UIViewController {

    
    @IBOutlet weak var displayNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    var userObjectID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetails()
    }
    
    func loadDetails(){
        let rest: RallyRestClient = RallyRestClient.instance
        let parameters: [String: String] = [ "fetch": "true" ]
        rest.get(path: "/slm/webservice/v2.x/user", queryParams: parameters) { (user) in
                if let dn = user["User"]["DisplayName"].string {
                    self.displayNameText.text = dn
                    self.userLabel.text = dn
                }
                if let email = user["User"]["UserName"].string {
                    self.emailText.text = email
                }
                if let first = user["User"]["FirstName"].string {
                    self.firstNameText.text = first
                }
                if let last = user["User"]["LastName"].string {
                    self.lastNameText.text = last
                }
                if let userID = user["User"]["ObjectID"].int {
                    print(
                    "-----> object ID \(userID)")
                    self.userObjectID = String(userID)
                }
                if let pi = user["User"]["ProfileImage"]["_refObjectUUID"].string {
                    rest.get(path: "/slm/webservice/v2.x/profileimage/\(pi)", queryParams: parameters) { (profile) in
                        if let content = profile["ProfileImage"]["Content"].string {
                            let dataDecoded : Data = Data(base64Encoded: content, options: .ignoreUnknownCharacters)!
                            self.userImage.image = UIImage(data: dataDecoded)
                        }
                    }
                }
            }
    }
    
    @IBAction func saveProfile(_ sender: Any) {
        let rest:RallyRestClient = RallyRestClient.instance
        
        let payload:JSON = [ "User": ["DisplayName": String(displayNameText.text!),
                                      "FirstName": String(firstNameText.text!),
                                      "LastName": String(lastNameText.text!),
                                      "EmailAddress": String(emailText.text!)]]
        rest.post(path: "/slm/webservice/v2.x/user/\(userObjectID)", payload: payload) { response in
            self.loadDetails()
        }
        
    }
    
}
