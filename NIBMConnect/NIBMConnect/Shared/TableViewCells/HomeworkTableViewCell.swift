//
//  HomeworkTableViewCell.swift
//  NIBMConnect
//
//  Created by malith on 5/22/19.
//  Copyright © 2019 malith. All rights reserved.
//

import UIKit

class HomeworkTableViewCell: UITableViewCell {

    @IBOutlet weak var tittle: UILabel!
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(_ tittle: String, date: String){
        self.tittle.text = tittle
        self.date.text = date
    }
    
}
