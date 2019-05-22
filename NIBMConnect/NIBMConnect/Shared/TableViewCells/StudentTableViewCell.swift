//
//  StudentTableViewCell.swift
//  NIBMConnect
//
//  Created by malith on 5/21/19.
//  Copyright © 2019 malith. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var cityName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //make image view rounded
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(_ image: UIImage, firstName: String, lastName: String, cityName: String){
        self.profileImage.image = image
        self.firstName.text = firstName
        self.lastName.text = lastName
        self.cityName.text = cityName
    }
    
}
