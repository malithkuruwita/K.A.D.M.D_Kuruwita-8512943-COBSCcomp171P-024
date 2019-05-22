//
//  NIBMStudentsViewController.swift
//  NIBMConnect
//
//  Created by malith on 5/20/19.
//  Copyright © 2019 malith. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NIBMStudentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var studentTableView: UITableView!
    
    var nibmStudents = [NibmStudents]()
    var id :String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        studentTableView.dataSource = self
        studentTableView.delegate = self
        
        let studentNib = UINib(nibName: "StudentTableViewCell", bundle: nil)
        studentTableView.register(studentNib, forCellReuseIdentifier: "studentTableViewCell")
        studentTableView.tableFooterView = UIView()
        
        //sepatrators go edge to edge
        studentTableView.layoutMargins = UIEdgeInsets.zero
        studentTableView.separatorInset = UIEdgeInsets.zero
        //tableviewcell border
        studentTableView.separatorColor = UIColor.green
        
        
        //load student data from firebase
        let databaseRef = Database.database().reference()
        //show spinner
        self.showSpinner(onView: self.view)
        databaseRef.child("nibmstudents").observe(.childAdded, with: {
            (snapshot) in
            print("key \(snapshot.key)")
            print("values\(snapshot.value as Any)")
            if !snapshot.exists(){return}
            let nibmStudents = NibmStudents(snap: snapshot)
            self.nibmStudents.append(nibmStudents)
            let myprofile = self.nibmStudents[0]
            print("\(myprofile.firstName)")
            
            
            self.studentTableView.reloadData()
            
        })
        
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nibmStudents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentTableViewCell", for: indexPath) as! StudentTableViewCell
        //sepatrators go edge to edge
        cell.layoutMargins = UIEdgeInsets.zero
        
        let nibmstudents = nibmStudents[indexPath.item]
        
        //load image and cache it
        imageService.getImage(withURL: nibmstudents.profileURL){
            image in
            cell.commonInit(image, firstName: nibmstudents.firstName,lastName: nibmstudents.lastName,cityName: nibmstudents.cityName)
            //hide spinner
            self.removeSpinner()
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nibmstudents = nibmStudents[indexPath.item]
        self.id = nibmstudents.key
        self.performSegue(withIdentifier: "nibmStudentsToProfile", sender: nil)
        self.studentTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "nibmStudentsToProfile") {
            let vc = segue.destination as! NIBMStudentsDetailsViewController
            vc.profileId = self.id
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
