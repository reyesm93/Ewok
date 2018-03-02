//
//  PlaidClient.swift
//  Ewok
//
//  Created by Arturo Reyes on 2/16/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import LinkKit

class PlaidClient : NSObject {
    
    static let sharedInstance = PlaidClient()
    var session = URLSession.shared
    
    func setupPlaidLinkWithSharedConfiguration() {
        // <!-- SMARTDOWN_SETUP_SHARED -->
        // With shared configuration from Info.plist
        PLKPlaidLink.setup { (success, error) in
            if (success) {
                // Handle success here, e.g. by posting a notification
                NSLog("Plaid Link setup was successful")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PLDPlaidLinkSetupFinished"), object: self)
            }
            else if let error = error {
                NSLog("Unable to setup Plaid Link due to: \(error.localizedDescription)")
            }
            else {
                NSLog("Unable to setup Plaid Link")
            }
        }
        // <!-- SMARTDOWN_SETUP_SHARED -->
    }
    
    func makeRequest(withPath: String, publicToken: String? = nil, completionHandlerForRequest: @escaping (_ result: AnyObject?, _ error: NSError?, _ errorString: String?) -> Void) {
        
        var components = URLComponents()
        
        components.scheme = Constants.Request.Client.APIScheme
        components.host = Constants.Request.Client.APIHost
        components.path = withPath
        
        print("url: \(components.url)")
        
        let request = NSMutableURLRequest(url: components.url!)
        request.httpMethod = Constants.Request.Client.Post
        request.addValue(Constants.JSON.App, forHTTPHeaderField: Constants.JSON.Content)
        request.addValue(Constants.JSON.App, forHTTPHeaderField: Constants.JSON.Accept)
        
        if publicToken != nil {
            let clientId = "5a0792cfbdc6a46838fe5e57"
            let secret = "2aa4ea0c53b1c57903692e80bc7471"
            
            let parameters = ["client_id" : clientId, "secret": secret, "public_token": publicToken]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            
            print("request: \(request)")
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForRequest(nil, NSError(domain: "makeRequest", code: 1, userInfo: userInfo), error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request")
                return
            }
            
            let http = response as? HTTPURLResponse
            print("status code: \(http!.statusCode)")
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard data != nil else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.parseDataWithCompletionHandler(data!, completionHandlerForParse: completionHandlerForRequest)
        }
        
        task.resume()
        
    }
    
    func parseDataWithCompletionHandler(_ data: Data, completionHandlerForParse: @escaping (_ result: AnyObject?, _ error: NSError?, _ errorString: String?) -> Void) {
        
        var parsedResult: [String:AnyObject]! = nil
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForParse(nil, NSError(domain: "parseDataWithCompletionHandler", code: 1, userInfo: userInfo), "Could not parse the data as JSON")
        }
        
        completionHandlerForParse(parsedResult as AnyObject, nil, nil)
    }
    
}
