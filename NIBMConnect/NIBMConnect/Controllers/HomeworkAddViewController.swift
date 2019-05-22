//
//  HomeworkAddViewController.swift
//  NIBMConnect
//
//  Created by malith on 5/22/19.
//  Copyright © 2019 malith. All rights reserved.
//

import UIKit

class HomeworkAddViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

   
    @IBOutlet weak var homeworkTitle: UITextField!
    @IBOutlet weak var homeworkDescription: UITextView!
    //get user default instence
    let userDefaults = UserDefaults.standard
    //homework class array instance
    var homeworkData = [Homework]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //part of keyboard dismiss
        self.homeworkTitle.delegate = self
        self.homeworkDescription.delegate = self
        
        //homeworks user default array
        if UserDefaults.standard.object(forKey: "homeworks") != nil {
        self.homeworkData = NSKeyedUnarchiver.unarchiveObject(with: (userDefaults.object(forKey: "homeworks") as! NSData) as Data) as! [Homework]
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //keyboard dismiss
    override func touchesBegan(_: Set<UITouch>, with: UIEvent?) {
        homeworkTitle.resignFirstResponder()
        homeworkDescription.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    //nav bar styles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.green]
    }
    
   //add homework
    @IBAction func addHomework(_ sender: Any) {
        
        //validate textfields
        if homeworkTitle.text?.isEmpty ?? true || homeworkDescription.text?.isEmpty ?? true {
            let alertController = UIAlertController(title: "Error", message: "Empty fields are not allowed", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
        let homework = Homework(title: self.homeworkTitle.text!, details: self.homeworkDescription.text!, date: Date())
        self.homeworkData.append(homework)
        userDefaults.setValue(NSKeyedArchiver.archivedData(withRootObject: self.homeworkData), forKey: "homeworks")
        userDefaults.synchronize()
        _ = navigationController?.popToRootViewController(animated: true)
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
