//
//  HomeworkDetailsViewController.swift
//  NIBMConnect
//
//  Created by malith on 5/22/19.
//  Copyright © 2019 malith. All rights reserved.
//

import UIKit

class HomeworkDetailsViewController: UIViewController {

    @IBOutlet weak var homeworkTittle: UILabel!
    @IBOutlet weak var homeworkDescription: UILabel!
    @IBOutlet weak var homeworkDate: UILabel!
    //homework id
    var homeworkId: Int = 0
    //get user default instence
    let userDefaults = UserDefaults.standard
    //homework class array instance
    var homeworkData = [Homework]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //adjustfontsize
        homeworkDescription.adjustsFontSizeToFitWidth = true
        
        getHomework()
        self.homeworkTittle.text = homeworkData[self.homeworkId].title
        self.homeworkDescription.text = homeworkData[self.homeworkId].details
        
        //convert date to string
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let now = df.string(from: homeworkData[self.homeworkId].date!)
        
        self.homeworkDate.text = now
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getHomework(){
        if UserDefaults.standard.object(forKey: "homeworks") != nil {
            self.homeworkData = NSKeyedUnarchiver.unarchiveObject(with: (userDefaults.object(forKey: "homeworks") as! NSData) as Data) as! [Homework]
        }
    }
    
    //nav bar styles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.green]
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
