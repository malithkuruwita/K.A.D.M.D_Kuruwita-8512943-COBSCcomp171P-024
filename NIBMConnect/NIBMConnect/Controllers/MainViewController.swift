//
//  MainViewController.swift
//  NIBMConnect
//
//  Created by malith on 5/19/19.
//  Copyright © 2019 malith. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //check internet
        checkInternet()
    }
    
    func showAlert(){
        print("show alert ---------------------------------------------------")
        DispatchQueue.main.async {
            // Declare Alert
            let dialogMessage = UIAlertController(title: "Internet", message: "No Internet Connection !", preferredStyle: .alert)
            // Create OK button with action handler
            let reload = UIAlertAction(title: "Reload", style: .default, handler: { (action) -> Void in
                print("reload button click...")
                self.checkInternet()
            })
            //Add OK and Cancel button to dialog message
            dialogMessage.addAction(reload)
            // Present dialog message to user
            self.present(dialogMessage, animated: true, completion: nil)
        }
        
    }
    
    //internet check and firebase authenticate
    func checkInternet(){
        Reachability.isInternetAvailable(webSiteToPing: nil) { (isInternetAvailable) in
            guard isInternetAvailable else {
                // Inform user about the internet connection
                print("no internet connection -------------------------------------------")
                self.showAlert()
                return
            }
            
            // Do some action if there is Internet
            self.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
                if(user != nil){
                    self.performSegue(withIdentifier: "mainToHome", sender: nil)
                }else{
                    self.performSegue(withIdentifier: "mainToSignIn", sender: nil)
                }
            }
        }
    }
    



}
