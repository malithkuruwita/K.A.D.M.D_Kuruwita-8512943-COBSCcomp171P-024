//
//  HomeworkViewController.swift
//  NIBMConnect
//
//  Created by malith on 5/22/19.
//  Copyright © 2019 malith. All rights reserved.
//

import UIKit

class HomeworkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var homeworkTable: UITableView!
    //get user default instence
    let userDefaults = UserDefaults.standard
    //homework class array instance
    var homeworkData = [Homework]()
    var id :Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        homeworkTable.dataSource = self
        homeworkTable.delegate = self
        
        let homeworkNib = UINib(nibName: "HomeworkTableViewCell", bundle: nil)
        homeworkTable.register(homeworkNib, forCellReuseIdentifier: "homeworkTableViewCell")
        homeworkTable.tableFooterView = UIView()
        
        //sepatrators go edge to edge
        homeworkTable.layoutMargins = UIEdgeInsets.zero
        homeworkTable.separatorInset = UIEdgeInsets.zero
        //tableviewcell border
        homeworkTable.separatorColor = UIColor.green
        
        //show spinner
        self.showSpinner(onView: self.view)
        //load homework from userdefaults
        getHomework()
        
    }
    
    func getHomework(){
        if UserDefaults.standard.object(forKey: "homeworks") != nil{
            self.homeworkData = NSKeyedUnarchiver.unarchiveObject(with: (userDefaults.object(forKey: "homeworks") as! NSData) as Data) as! [Homework]
        }else{
            //hide spinner
            self.removeSpinner()
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
        //call getHomework method to update inserted data
        getHomework()
        //reload table
        homeworkTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeworkData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeworkTableViewCell", for: indexPath) as! HomeworkTableViewCell
        //sepatrators go edge to edge
        cell.layoutMargins = UIEdgeInsets.zero
        
        let homeworkdata = homeworkData[indexPath.item]
        //convert date to string
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let now = df.string(from: homeworkdata.date!)
        
        cell.commonInit(homeworkdata.title!, date: now)
            //hide spinner
            self.removeSpinner()
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.id = indexPath.item
        self.performSegue(withIdentifier: "homeworkToHomeworkDetails", sender: nil)
        self.homeworkTable.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            
            // Declare Alert
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete ?", preferredStyle: .alert)
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button click...")
                self.homeworkData.remove(at: indexPath.item)
                //set homework data after delete
                self.userDefaults.setValue(NSKeyedArchiver.archivedData(withRootObject: self.homeworkData), forKey: "homeworks")
                self.userDefaults.synchronize()
                self.homeworkTable.deleteRows(at: [indexPath], with: .automatic)
            })
            // Create Cancel button with action handlder
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                print("Cancel button click...")
            }
            //Add OK and Cancel button to dialog message
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            // Present dialog message to user
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "homeworkToHomeworkDetails") {
            let vc = segue.destination as! HomeworkDetailsViewController
            vc.homeworkId = self.id
        }
    }
    



}
