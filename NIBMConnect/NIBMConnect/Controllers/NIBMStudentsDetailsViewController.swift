//
//  NIBMStudentsDetailsViewController.swift
//  NIBMConnect
//
//  Created by malith on 5/21/19.
//  Copyright © 2019 malith. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NIBMStudentsDetailsViewController: UIViewController {

    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var FBURL: UILabel!
    
    var profileId: String = ""
    var nibmStudent = [NibmStudents]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //make image view rounded
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = UIColor.white.cgColor
        
        //adjustfontsize
        FBURL.adjustsFontSizeToFitWidth = true
        
        //get data from firebase
        var dbRef : DatabaseReference!
        dbRef = Database.database().reference()
        //show spinner
        self.showSpinner(onView: self.view)
        let id = self.profileId
        print(id)
        dbRef.child("nibmstudents/\(id)").observeSingleEvent(of: .value) {
            (snapshot) in
            if !snapshot.exists(){return}
            let studentPro = NibmStudents(snap: snapshot)
            self.nibmStudent.append(studentPro)
            let nibmstudent = self.nibmStudent[0]
            //add data to labels
            self.firstName.text = nibmstudent.firstName
            self.lastName.text = nibmstudent.lastName
            self.cityName.text = nibmstudent.cityName
            self.phoneNumber.text = nibmstudent.phoneNumber
            self.FBURL.text = nibmstudent.FBprofileURL
            //load image and cache it
            imageService.getImage(withURL: nibmstudent.profileURL){
                image in
                self.profileImage.image = image
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
    
    func commonInit(profileId: String){
        self.profileId = profileId
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
