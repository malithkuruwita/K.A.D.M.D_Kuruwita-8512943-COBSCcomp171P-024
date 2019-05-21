//
//  MyProfileViewController.swift
//  NIBMConnect
//
//  Created by malith on 5/20/19.
//  Copyright © 2019 malith. All rights reserved.
//

import UIKit
import Firebase

class MyProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var birthdate: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    
    var myProfile = [MyProfile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //make image view rounded
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
        profilePicture.layer.borderWidth = 3
        profilePicture.layer.borderColor = UIColor.white.cgColor
        //load myprofile data
        var dbRef : DatabaseReference!
        dbRef = Database.database().reference()
        //show spinner
        self.showSpinner(onView: self.view)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        dbRef.child("user/profile/\(uid)").observeSingleEvent(of: .value) {
            (snapshot) in
            if !snapshot.exists(){return}
            print(snapshot.value as Any)
            let myPro = MyProfile(snap: snapshot)
            self.myProfile.append(myPro)
            let myprofile = self.myProfile[0]
            //add data to labels
                self.name.text = myprofile.name
                self.age.text = myprofile.age
                self.birthdate.text = myprofile.birthdate
                self.phoneNumber.text = myprofile.phoneNumber
            //load image and cache it
            imageService.getImage(withURL: myprofile.photoURL){
                image in
                    self.profilePicture.image = image
                //hide spinner
                self.removeSpinner()
            }
            
        }
        
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
    
    //user signout function
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        self.performSegue(withIdentifier: "myProfileToSignIn", sender: nil)
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
