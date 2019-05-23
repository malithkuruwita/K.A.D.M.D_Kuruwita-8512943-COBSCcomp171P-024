//
//  CheckIdentityViewController.swift
//  NIBMConnect
//
//  Created by malith on 5/20/19.
//  Copyright © 2019 malith. All rights reserved.
//

import UIKit
import LocalAuthentication

class CheckIdentityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //nav bar styles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.green]
    }
    
    //check user tuchid function
    @IBAction func touchIdAction(_ sender: Any) {
        print("You have clicked the touch ID")
        
        let myContext = LAContext()
        let myLocalizedReasonString = "Biometric Authntication testing !! "
        
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    
                    DispatchQueue.main.async {
                        if success {
                            // User authenticated successfully, take appropriate action
                            print("Awesome!!... User authenticated successfully")
                            self.performSegue(withIdentifier: "checkIdentityToMyProfile", sender: nil)
                        } else {
                            // User did not authenticate successfully, look at error and take appropriate action
                            print("Sorry!!... User did not authenticate successfully")
                        }
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
                print("Sorry!!.. Could not evaluate policy.")
            }
        } else {
            // Fallback on earlier versions
            print("Ooops!!.. This feature is not supported.")
        }
        
        
    }
    
    
}
    
    
    




