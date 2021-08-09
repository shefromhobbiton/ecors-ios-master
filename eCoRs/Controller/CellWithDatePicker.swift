//
//  CellWithDatePicker.swift
//  eCoRs
//
//  Created by She Razon-Bulalaque on 28/08/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class CellWithDatePicker: UITableViewCell {

    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var txtfldTime: UITextField!
    @IBOutlet weak var lblQuestionId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
