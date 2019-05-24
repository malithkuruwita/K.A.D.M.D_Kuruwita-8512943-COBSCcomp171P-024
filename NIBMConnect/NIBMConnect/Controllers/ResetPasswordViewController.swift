//
//  ResetPasswordViewController.swift
//  NIBMConnect
//
//  Created by malith on 5/20/19.
//  Copyright © 2019 malith. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var passwordReset: UITextField!
    
    
    @IBOutlet weak var sendEmailButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //part of keyboard dismiss
        self.passwordReset.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //keyboard dismiss
    override func touchesBegan(_: Set<UITouch>, with: UIEvent?) {
        passwordReset.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    //go to signin window
    @IBAction func goToSignIn(_ sender: Any) {
        self.performSegue(withIdentifier: "resetPasswordToSignIn", sender: nil)
    }
    
    //send mail to email address
    @IBAction func sendResetMail(_ sender: Any) {
        //button shake
        sendEmailButton.shake()
        //validate
        if passwordReset.text?.isEmpty ?? true{
            let alertController = UIAlertController(title: "Error", message: "email field is required", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //dismiss keyboard
            self.view.endEditing(true)
            //show spinner
            self.showSpinner(onView: self.view)
            Auth.auth().sendPasswordReset(withEmail: passwordReset.text!) { error in
                if error == nil {
                    //hide spinner
                    self.removeSpinner()
                    
                    //show success alert
                    let alertController = UIAlertController(title: "Success", message: "Email has sent, check it out", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    //clear textfield
                    self.passwordReset.text = ""
                    
                }else{
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
