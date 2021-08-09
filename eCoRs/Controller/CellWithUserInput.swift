//
//  CellWithUserInput.swift
//  eCoRs
//
//  Created by She Razon-Bulalaque on 22/08/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class CellWithUserInput: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblAnswer: UITextField!
    @IBOutlet weak var lblQuestionId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblAnswer.delegate = self
        addDoneButtonOnKeyboard()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //add done button
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        lblAnswer.inputAccessoryView = doneToolbar
    }
    
    //done button action
    @objc func doneButtonAction(){
        lblAnswer.resignFirstResponder()
        
        //get user answer
        let answer = lblQuestionId.text
        let dataController = DataController()
        dataController.setUserResponse(response: answer ?? "no answer", id: lblQuestionId.text!)
    }
}

