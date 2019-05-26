//
//  SignInViewController.swift
//  NIBMConnect
//
//  Created by malith on 5/19/19.
//  Copyright © 2019 malith. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController, UITextFieldDelegate, GIDSignInDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var signInButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //part of keyboard dismiss
        self.email.delegate = self
        self.password.delegate = self
        
        //google
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signOut()
        
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
    
    //google authentication method
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
            //show spinner
            self.showSpinner(onView: self.view)
        
        
        if let err = error{
            print("Failed to log into Google: ", err)
            //hide spinner
            self.removeSpinner()
            return
        }
        print("Successfully logged into Google", user.profile.name)
        //handle the username and imageurl to save
        var googleName: String
        let imgUrl: String = user.profile.imageURL(withDimension: 100).absoluteString
        //var fullName: Array<Any>
        if user.profile.name != "" {
            googleName = user.profile.name
            //fullName = googleName.components(separatedBy: " ")
        }else{
            googleName = "Undefined"
            //fullName = googleName.components(separatedBy: " ")
        }
        
        //check whether the token is available to authenticate
        guard let idToken = user.authentication.idToken else {return}
        guard let accessToken = user.authentication.accessToken else {return}
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        //firebase authentication
        Auth.auth().signInAndRetrieveData(with: credentials, completion: { (user, error) in
            if let err = error{
                print("Faild to create a firebase User with Google account: ", err)
                //hide spinner
                self.removeSpinner()
                return
            }else{
                guard let uid = user?.user.uid else {return}
                print("Successfully logged into Firebase with Google", uid)
                self.saveGoogleProfile(name: googleName, url: imgUrl)
            }
        })
    }
    //save user profile
    func saveGoogleProfile(name: String, url: String){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("user/profile/\(uid)")
        let userObject = [
            "photoURL": url,
            "name": name,
            "age": "Undefined",
            "birthdate": "Undefined",
            "phoneNumber": "Undefined"
            ] as [String:Any]
        databaseRef.setValue(userObject){ error, ref in
            if error != nil {
                print("some thing went wrong")
                //hide spinner
                self.removeSpinner()
            }else{
                print("success")
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                let initial = storyboard.instantiateInitialViewController()
                UIApplication.shared.keyWindow?.rootViewController = initial
            }
        }
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
                    //hide spinner
                    self.removeSpinner()
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    


}
