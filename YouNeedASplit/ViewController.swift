//
//  ViewController.swift
//  YNAS2
//
//  Created by Kelly Aileen Drumm on 5/21/20.
//  Copyright © 2020 KaiDrumm. All rights reserved.
//

import AuthenticationServices
import UIKit

class ViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    @IBOutlet weak var splitwiseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    var webAuthSession: ASWebAuthenticationSession?
    @available(iOS 12.0, *)
    @IBAction func splitwiseAuth(_ sender: UIButton){
        print("Splitwise Auth")
        
        let authURL = URL(string: "https://secure.splitwise.com/oauth/authorize?response_type=code&client_id=6UjFbDGvpDfEvYeCsUtAzdcI40dOfddRUzhmIBnA")
        let callbackUrlScheme = "NatKaiYNAS://callback"
        
        self.webAuthSession = ASWebAuthenticationSession.init(url: authURL!, callbackURLScheme: callbackUrlScheme, completionHandler: { (callBack:URL?, error:Error?) in
            print("handling callback")
            guard error == nil, let successURL = callBack else {
                return
            }
            let oauthToken = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "code"}).first
            print(oauthToken ?? "No OAuth Token")
        })
        self.webAuthSession?.presentationContextProvider = self
        self.webAuthSession?.start()
        print("session started")
    }

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }

}
