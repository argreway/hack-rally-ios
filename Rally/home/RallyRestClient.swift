//
//  RallyRestClient.swift
//  Rally
//
//  Created by Tony Greway on 2/4/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class RallyRestClient {
    
    static let instance:RallyRestClient = RallyRestClient()
    
//    var baseURI:String = "http://localhost:7001"
    var baseURI:String = "https://rally1.rallydev.com"
    
    var username:String = ""
    var password:String = ""
    var securityKey:String = ""

    func securityAuthorize(username:String, password:String, viewController: LoginViewController) {
        let headers: HTTPHeaders = [
            .authorization(username: username, password: password),
            .accept("application/json")
        ]
        
        self.username = username
        self.password = password

        AF.request("\(baseURI)/slm/webservice/v2.x/security/authorize", headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                    case .success(let value):

                        self.SaveCookie(response: response)
                        let jsonValue = JSON(value)
//                        debugPrint(response)
//                        print(jsonValue)
                        
                        if let key = jsonValue["OperationResult"]["SecurityToken"].string {
//                            print("got key \(key)")
                            self.securityKey = key
                            viewController.failedLabel.isHidden = true
                            viewController.performSegue(withIdentifier: "loginToTabSegue", sender: viewController)
                        }
                    case let .failure(error):
                        print("failed to authorize")
                        viewController.failedLabel.isHidden = false
               }
            }
        
    }
    
    func get(path:String, queryParams:[String: String], completion:@escaping (JSON) -> Void)  {
        
        var parameters = queryParams
        parameters["key"] = securityKey

        let headers: HTTPHeaders = [
            .authorization(username: self.username, password: self.password),
            .accept("application/json")
        ]
        
        AF.request("\(baseURI)\(String(path))",parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                    case .success(let value):
//                        debugPrint(response)
//                        print(jsonValue)
                        self.SaveCookie(response: response)
                        let jsonValue = JSON(value)
                        completion(jsonValue)
                    case let .failure(error):
                        print(error)
               }
        }
    }
    
    func post(path:String, payload:JSON, completion:@escaping (JSON) -> Void)  {
        
        let headers: HTTPHeaders = [
            .authorization(username: self.username, password: self.password),
            .accept("application/json")
        ]
        
        AF.request("\(baseURI)\(String(path))?key=\(securityKey)", method: .post, parameters: payload, encoder: JSONParameterEncoder.default, headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                    case .success(let value):
//                        debugPrint(response)
//                        print(jsonValue)
                        self.SaveCookie(response: response)
                        let jsonValue = JSON(value)
                        completion(jsonValue)
                    case let .failure(error):
                        print(error)
               }
        }
    }
    
    func SaveCookie(response:AFDataResponse<Any>){
          let headerFields = response.response?.allHeaderFields as! [String: String]
          let url = response.request?.url
          let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url!)
          var cookieArray = [ [HTTPCookiePropertyKey : Any ] ]()
          for cookie in cookies {
              cookieArray.append(cookie.properties!)
          }
          UserDefaults.standard.set(cookieArray, forKey: "tokens")
      }
    
}
