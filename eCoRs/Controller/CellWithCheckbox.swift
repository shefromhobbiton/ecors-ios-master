//
//  TableViewCell.swift
//  eCoRs
//
//  Created by She Razon-Bulalaque on 15/08/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class CellWithCheckbox: UITableViewCell {

    @IBOutlet weak var lblQuestions: UILabel!
    @IBOutlet weak var btnCheckbox: UIButton!
    @IBOutlet weak var lblQuestionId: UILabel!
    
    //current selection
    var val = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnCheckbox(_ sender: Any) {
        
        if btnCheckbox.isSelected == false {
            btnCheckbox.isSelected = true
            val = true
        } else {
            btnCheckbox.isSelected = false
            val = false
        }
        
        let dataController = DataController()
        dataController.setUserResponse(response: val, id: lblQuestionId.text!)
    }
    
}
