//
//  SignInViewController.swift
//  NIBMConnect
//
//  Created by malith on 5/19/19.
//  Copyright © 2019 malith. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class SignInViewController: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var signInButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //part of keyboard dismiss
        self.email.delegate = self
        self.password.delegate = self
        
        //google button initialize
        setupGoogleButton()
    }
    
    //add google sign button
    fileprivate func setupGoogleButton(){
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 58, y: 500, width: view.frame.width - 120, height: 50)
        view.addSubview(googleButton)
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //keyboard dismiss
    override func touchesBegan(_: Set<UITouch>, with: UIEvent?) {
        email.resignFirstResponder()
        password.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    //go to signup window
    @IBAction func goToSignUp(_ sender: Any) {
        self.performSegue(withIdentifier: "signInToSignUp", sender: nil)
    }
    //go to resetpassword window
    @IBAction func goToResetPassword(_ sender: Any) {
        self.performSegue(withIdentifier: "signInToResetPassword", sender: nil)
    }
    
    
    //signin function
    @IBAction func signIn(_ sender: Any) {
        //button animation
        signInButton.shake()
        //validate textfields
        if email.text?.isEmpty ?? true || password.text?.isEmpty ?? true {
            let alertController = UIAlertController(title: "Error", message: "Empty fields are not allowed", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //dismiss keyboard
            self.view.endEditing(true)
            //show spinner
            self.showSpinner(onView: self.view)
            Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
                
                if error == nil{
                    //go to home window
                    self.performSegue(withIdentifier: "signInToHome", sender: nil)
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
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
