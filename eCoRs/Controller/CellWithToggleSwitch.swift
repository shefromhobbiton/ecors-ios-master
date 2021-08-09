//
//  CellWithToggleSwitch.swift
//  eCoRs
//
//  Created by She Razon-Bulalaque on 22/08/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class CellWithToggleSwitch: UITableViewCell {

    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var toggleYesNo: UISwitch!
    @IBOutlet weak var lblQuestionId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func toggleSwitch(_ sender: UISwitch) {
        var val: Bool = false
        if toggleYesNo.isOn {
            val = true
        } else {
            val = false
        }
        
        let dataController = DataController()
        dataController.setUserResponse(response: val, id: lblQuestionId.text!)
    }
}
