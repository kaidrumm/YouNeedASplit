//
//  ViewController.swift
//  YNAS2
//
//  Created by Kelly Aileen Drumm on 5/21/20.
//  Copyright © 2020 KaiDrumm. All rights reserved.
//

import AuthenticationServices
import UIKit

class LoginViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    
    @IBOutlet weak var splitwiseButton: UIButton!
    @IBOutlet weak var ynabButton: UIButton!
    
    var webAuthSession: ASWebAuthenticationSession?
    let ynabClientID = "05e0bb8ba1c09f83796266ff0a5939f3435946376adb394af4187d2038a0e0de"
    let splitwiseClientID = "6UjFbDGvpDfEvYeCsUtAzdcI40dOfddRUzhmIBnA"
    let callbackURI = "NatKaiYNAS://callback"
    
    @available(iOS 12.0, *)
    @IBAction func splitwiseAuth(_ sender: UIButton){
        print("Splitwise Auth")
        
        let authURL = URL(string: "https://secure.splitwise.com/oauth/authorize?response_type=code&client_id=\(splitwiseClientID)")
        let callbackUrlScheme = callbackURI
        
        self.webAuthSession = ASWebAuthenticationSession.init(url: authURL!, callbackURLScheme: callbackUrlScheme, completionHandler: { (callBack:URL?, error:Error?) in
            print("handling splitwise callback")
            guard error == nil, let successURL = callBack else {
                return
            }
            let oauthToken = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "code"}).first
            print(oauthToken ?? "No OAuth Token")
            SplitwiseClient.SPLIT.token = oauthToken?.value ?? ""
            print(SplitwiseClient.SPLIT.token)
        })
        self.webAuthSession?.presentationContextProvider = self
        self.webAuthSession?.start()
        print("Splitwise session started")
    }

    @available(iOS 12.0, *)
    @IBAction func ynabAuth(_sender: UIButton){
        print("YNAB Auth")
        
        let authURL = URL(string: "https://app.youneedabudget.com/oauth/authorize?client_id=\(ynabClientID)&redirect_uri=\(callbackURI)&response_type=token")
        let callbackUrlScheme = callbackURI
        
        self.webAuthSession = ASWebAuthenticationSession.init(url: authURL!, callbackURLScheme: callbackUrlScheme, completionHandler: { (callBack:URL?, error:Error?) in
            print("Handling ynab callback")
            guard error == nil, let successURL = callBack else {
                return
            }
            let oauthToken = successURL.absoluteString.components(separatedBy: ["=", "&"])[1]
            YnabClient.YNAB.token = oauthToken
            print(YnabClient.YNAB.token)
        })
        self.webAuthSession?.presentationContextProvider = self
        self.webAuthSession?.start()
        print("YNAB session started")
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
      

}
