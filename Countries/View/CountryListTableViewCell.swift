//
//  CountryListTableViewCell.swift
//  Countries
//
//  Created by admin on 21/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class CountryListTableViewCell: UITableViewCell {
    
    @IBOutlet var countrynameLbl :UILabel!
    @IBOutlet var countryflagIV : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
