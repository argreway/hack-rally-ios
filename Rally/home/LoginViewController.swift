//
//  LoginViewController.swift
//  Rally
//
//  Created by Tony Greway on 2/4/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var homeTabItem: UITabBarItem!
    @IBOutlet weak var failedLabel: UILabel!
    
    @IBAction func loginButton(_ sender: Any) {
        
        let rest:RallyRestClient = RallyRestClient.instance
//        print("username: \(username.text ?? "") password: \(password.text ?? "")" )
        rest.securityAuthorize(username: (username.text ?? ""),  password: (password.text ?? "" ), viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
