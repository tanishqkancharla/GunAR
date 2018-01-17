//
//  PeripheralTableViewCell.swift
//  GunAR
//
//  Created by Tanishq Kancharla on 1/12/18.
//  Copyright © 2018 Tanishq Kancharla. All rights reserved.
//

import UIKit

class PeripheralTableViewCell: UITableViewCell {
    @IBOutlet weak var peripheralName: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
