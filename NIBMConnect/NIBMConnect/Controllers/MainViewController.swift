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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if(user != nil){
                self.performSegue(withIdentifier: "mainToHome", sender: nil)
            }else{
                self.performSegue(withIdentifier: "mainToSignIn", sender: nil)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
