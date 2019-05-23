//
//  SignUpViewController.swift
//  NIBMConnect
//
//  Created by malith on 5/19/19.
//  Copyright © 2019 malith. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var birthdate: UITextField!
    
    var imagePicker:UIImagePickerController!
    var datePicker:UIDatePicker?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //make image view rounded
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        
        
        // create tap gesture recognizer for imageview
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        // add it to the image view
        imageView.addGestureRecognizer(tapGesture1)
        // make sure imageView can be interacted with by user
        imageView.isUserInteractionEnabled = true
        
        
        // create tap gesture recognizer for mainview
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture2)
        
        
        //initialize image picker
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        //initialize date picker
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        birthdate.inputView = datePicker
        
        //dismiss date picker
        datePicker?.addTarget(self, action: #selector(dismissDatePicker(datePicker:)), for: .valueChanged)
        
        //move viewup when editing
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    // Move view 150 points upward
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -150
    }
    // Move view to original position
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    //dismiss date picker function
    @objc func dismissDatePicker(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        birthdate.text = dateFormatter.string(from: datePicker.date)
    }
    
    //imageView tapped function
    @objc func imageTapped() {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //view tapped function
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //go to signin window
    @IBAction func goToSignIn(_ sender: Any) {
        self.performSegue(withIdentifier: "signUpToSignIn", sender: nil)
    }
    
    //signup function
    @IBAction func signUp(_ sender: Any) {
        //validations
        /*guard (self.name.text) != nil else { return }
        guard (self.age.text) != nil else { return }
        guard (self.phoneNumber.text) != nil else { return }
        guard (self.birthdate.text) != nil else { return }*/
        guard let image = imageView.image else { return }
        
        if email.text?.isEmpty ?? true || password.text?.isEmpty ?? true || confirmPassword.text?.isEmpty ?? true{
            let alertController = UIAlertController(title: "Error", message: "email, password, confirm password is required", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        if (self.password.text) != (self.confirmPassword.text) {
            let alertController = UIAlertController(title: "Error", message: "password and confirm password must match", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        //show spinner
        self.showSpinner(onView: self.view)
        
        //firebase email signup function
        Auth.auth().createUser(withEmail: self.email.text!, password: self.password.text!) { user, error in
            if error == nil && user != nil {
                print("user created!")
                self.uploadProfileImage(image){ url in
                    if url != nil{
                        //call userprofile save function
                        self.saveProfile(profileImageURL: url!){ success in
                            
                            if success{
                                //everything is succeded
                                //go to home window
                                self.performSegue(withIdentifier: "signUpToHome", sender: nil)
                                
                            }
                        }
                    }else{
                        //error unable to upload profile image
                        //remove spinner
                        self.removeSpinner()
                        
                        //show alert
                        let alertController = UIAlertController(title: "Error", message: "Unable to upload profile image", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }else{
                print("Error: \(error!.localizedDescription)")
                //remove spinner
                self.removeSpinner()
                
                //show alert
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    //upload image
    func uploadProfileImage(_ image: UIImage, completion: @escaping ((_ url:URL?)->())){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.75) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData){ metaData, error in
            if error == nil, metaData != nil {
                //success
                storageRef.downloadURL(completion: { (url, error) in
                    if let urlText = url {
                        completion(urlText)
                    }else{
                        completion(nil)
                    }
                })
            }else{
                completion(nil)
            }
        }
        
        
    }
    
    //save user profile
    func saveProfile(profileImageURL: URL, completion: @escaping ((_ sucess:Bool)->())){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("user/profile/\(uid)")
        let userObject = [
            "photoURL": profileImageURL.absoluteString,
            "name": self.name.text as Any,
            "age": self.age.text as Any,
            "birthdate": self.birthdate.text as Any,
            "phoneNumber": self.phoneNumber.text as Any
            ] as [String:Any]
        databaseRef.setValue(userObject){ error, ref in
            completion(error == nil)
        }
    }
    
    
    

}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
