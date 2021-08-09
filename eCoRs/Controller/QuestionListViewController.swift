//
//  QuestionListViewController.swift
//  eCoRs
//
//  Created by She Razon-Bulalaque on 14/08/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class QuestionListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    /*** IB OUTLETS ***/
    @IBOutlet weak var tblQuestionList: UITableView!
    @IBOutlet weak var lblQuestionListTitle: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnEnd: UIButton!
    
    /***  GLOBAL DECLARES ***/
    //storage for selected table indexes
    var selectedIndexes:[Int] = Array()
    
    //initialize workflow data
    var workflowQuestionsIndex = 0
    var numRows = _workflowQuestions.count
    
    //utils
    let utils = Utils()
    let dataController = DataController()
    
    /********************************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()

        //set page title
        lblQuestionListTitle.text = _title
        
        //instantiate tableview
        tblQuestionList.dataSource = self
        tblQuestionList.delegate = self
        
        //set height
        tblQuestionList.rowHeight = UITableView.automaticDimension
        tblQuestionList.estimatedRowHeight = 600
        
        //register tableview cells
        tblQuestionList.register(UINib.init(nibName:"CellWithCheckbox", bundle: nil), forCellReuseIdentifier: "CellWithCheckbox")
        tblQuestionList.register(UINib.init(nibName:"CellWithUserInput", bundle: nil), forCellReuseIdentifier: "CellWithUserInput")
        tblQuestionList.register(UINib.init(nibName:"CellWithLabel", bundle: nil), forCellReuseIdentifier: "CellWithLabel")
        tblQuestionList.register(UINib.init(nibName:"CellWithToggleSwitch", bundle: nil), forCellReuseIdentifier: "CellWithToggleSwitch")
        tblQuestionList.register(UINib.init(nibName:"CellWithDatePicker", bundle: nil), forCellReuseIdentifier: "CellWithDatePicker")
        tblQuestionList.register(UINib.init(nibName:"CellWithNumberInput", bundle: nil), forCellReuseIdentifier: "CellWithNumberInput")
        tblQuestionList.register(UINib.init(nibName:"CellWithDecimalInput", bundle: nil), forCellReuseIdentifier: "CellWithDecimalInput")

        //TEMP: for debugging
        print("<<<<<< I AM ON QUESTION LIST VIEW CONTROLLER <<<<<<<<<")
        //get maxmimum number of roww
//        print("NUMBER OF ROWS ON TABLE = ", _workflowQuestions.count)
//
//        print(">> WORKFLOW DATA <<")
//        print("_totalNumberOfWorkflows -> ", _totalNumberOfWorkflows)
//        print("_workflowIndex -> ", _workflowIndex)
//        print("_title -> ", _title)
//        print("_enforced -> ", _enforced)
//        print("_isLastWorkflow -> ", _isLastWorkflow)
//
//        print(">>>>>>>>>>>>> WORKFLOW QUESTIONS <<<<<<<<<<<<<<")
//        for ctr in 0..<_workflowQuestions.count {
//            print(">>>>>>> ctr -> ", ctr, " <<<<<<<<<")
//            print("workflowId -> ", _workflowQuestions[ctr]["workflowId"]!)
//            print("questionId -> ", _workflowQuestions[ctr]["questionId"]!)
//            print("type -> ", _workflowQuestions[ctr]["type"]!)
//            print("order -> ", _workflowQuestions[ctr]["order"]!)
//            print("question -> ", _workflowQuestions[ctr]["question"]!)
//        }
        
        print(">>>>>>>>>>>>> WORKFLOW ANSWERS <<<<<<<<<<<<<<")
        for ctr in 0..<_workflowAnswers.count {
            print(">>>>>>> ctr -> ", ctr, " <<<<<<<<<")
            print("workflowId -> ", _workflowAnswers[ctr]["workflowId"]!)
            print("questionId -> ", _workflowAnswers[ctr]["questionId"]!)
            print("type -> ", _workflowAnswers[ctr]["type"]!)
            print("response -> ", _workflowAnswers[ctr]["response"]!)
        }
        
    }
    
    /*************************
    * TABLEVIEW FUNCTIONS
    *************************/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return numRows
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("draw cell ", indexPath.row)
        print("question type ->", _workflowQuestions[indexPath.row]["type"]!)
        /*
         o    Flag – Radio Button *
         o    Text – Edit Text *
         o    number – Number Keyboard
         o    Toggle – Switch Control *
         o    None  - Just Display Title without any input field *
         o    Time – Clock control *
         o    numberDecimal – Number Keyboard with decimal input
         */
        
        //if workflowQuestions[workflowQuestionsIndex][indexPath.row] == "switch" {
        if _workflowQuestions[indexPath.row]["type"] as! String == "Toggle" {
            print("TOGGLE")
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellWithToggleSwitch") as! CellWithToggleSwitch
            cell.lblQuestion.text = _workflowQuestions[indexPath.row]["question"] as? String
            cell.lblQuestionId.text = _workflowQuestions[indexPath.row]["questionId"] as? String
            cell.selectionStyle = .none
            return cell
        }
        //else if workflowQuestions[workflowQuestionsIndex][indexPath.row] == "text" {
        else if _workflowQuestions[indexPath.row]["type"] as! String == "Text" {
            print("TEXT INPUT")
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellWithUserInput") as! CellWithUserInput
            cell.lblQuestion.text = _workflowQuestions[indexPath.row]["question"] as? String
            cell.lblQuestionId.text = _workflowQuestions[indexPath.row]["questionId"] as? String
            cell.selectionStyle = .none
            return cell
        }
        //else if workflowQuestions[workflowQuestionsIndex][indexPath.row] == "number" {
        else if _workflowQuestions[indexPath.row]["type"] as! String == "number" {
            print("NUMBER INPUT")
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellWithUserInput") as! CellWithUserInput
            cell.lblQuestion.text = _workflowQuestions[indexPath.row]["question"] as? String
            cell.lblQuestionId.text = _workflowQuestions[indexPath.row]["questionId"] as? String
            cell.lblAnswer.keyboardType = .numberPad
            cell.selectionStyle = .none
            return cell
        }
        //else if workflowQuestions[workflowQuestionsIndex][indexPath.row] == "numberDecimal" {
        else if _workflowQuestions[indexPath.row]["type"] as! String == "numberDecimal" {
            print("NUMBER INPUT")
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellWithUserInput") as! CellWithUserInput
            cell.lblQuestion.text = _workflowQuestions[indexPath.row]["question"] as? String
            cell.lblQuestionId.text = _workflowQuestions[indexPath.row]["questionId"] as? String
            cell.lblAnswer.keyboardType = .decimalPad
            cell.selectionStyle = .none
            return cell
        }
        //else if workflowQuestions[workflowQuestionsIndex][indexPath.row] == "flag" {
        else if _workflowQuestions[indexPath.row]["type"] as! String == "Flag" {
            print("FLAG")
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellWithCheckbox") as! CellWithCheckbox
            cell.lblQuestions.text = _workflowQuestions[indexPath.row]["question"] as? String
            cell.lblQuestionId.text = _workflowQuestions[indexPath.row]["questionId"] as? String
            cell.selectionStyle = .none
            //cell.btnCheckbox.addTarget(self, action: #selector(checkboxClicked(sender:)), for: .touchUpInside)
            //cell.btnCheckbox.tag = indexPath.row
//            cell.btnCheckbox.isSelected = false
//
//                if selectedIndexes.contains(indexPath.row) {
//                    cell.btnCheckbox.isSelected = true
//                }
            return cell
        }
        //else if workflowQuestions[workflowQuestionsIndex][indexPath.row] == "time" {
        else if _workflowQuestions[indexPath.row]["type"] as! String == "Time" {
            print("TIME")
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellWithDatePicker") as! CellWithDatePicker
            cell.lblQuestion.text = _workflowQuestions[indexPath.row]["question"] as? String
            cell.lblQuestionId.text = _workflowQuestions[indexPath.row]["questionId"] as? String
            cell.selectionStyle = .none

            //set timepicker
            cell.txtfldTime.addTarget(self, action: #selector(txtFieldTimeEvent(sender:)), for: .editingDidBegin)
            return cell
        }
        else {  //cell with text only
            print("TEXT DISPLAY ONLY")
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellWithLabel") as! CellWithLabel
            cell.lblInfo.text = _workflowQuestions[indexPath.row]["question"] as? String
            cell.selectionStyle = .none
            return cell
        }
    }
    
    /**************************
     * EVENT HANDLERS
     ***************************/
    //btnComment
    @IBAction func btnComment(_ sender: UIButton) {
        
        
    }
    
    //btnCamera
    @IBAction func btnCamera(_ sender: UIButton) {
        print("open camera")
        //openCamera()
    }
    
    //bntNext
    @IBAction func btnNext(_ sender: UIButton) {
        print("NEXT BUTTON PRESSED")
        
        //TEMP
        for ctr in 0..<_workflowAnswers.count {
            print(">>>>>>> ctr -> ", ctr, " <<<<<<<<<")
            print("workflowId -> ", _workflowAnswers[ctr]["workflowId"]!)
            print("questionId -> ", _workflowAnswers[ctr]["questionId"]!)
            print("type -> ", _workflowAnswers[ctr]["type"]!)
            print("response -> ", _workflowAnswers[ctr]["response"]!)
        }
        
       self.btnNextRoutine()
        
    }
    
    //btnEnd
    @IBAction func btnEnd(_ sender: UIButton) {
        print("END BUTTON PRESSED")
        //return to main screen
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    //chechkbox click event
    @objc func checkboxClicked( sender: UIButton) {
        print("button presed")
        
        if sender.isSelected {
            //uncheck the butoon
            sender.isSelected = false
            
            var indx = 0
            for id in selectedIndexes {
                if id == sender.tag {
                    selectedIndexes.remove(at: indx)
                    break
                }
                indx = indx +  1
            }
        } else {
            // checkmark it
            sender.isSelected = true
            selectedIndexes.append(sender.tag)
            
        }
    }
    */
    
    //txtfld-datepicker 
    @objc func txtFieldTimeEvent( sender: UITextField) {
        print("buttonevent")
        
        //create picker
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.time
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)

        //create toolbar
        let datePickerToolbar = UIToolbar()
        datePickerToolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        doneButton.tag = sender.tag
        datePickerToolbar.setItems([doneButton], animated: false)
        datePickerToolbar.isUserInteractionEnabled = true
        sender.inputAccessoryView = datePickerToolbar
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        let indexPath = self.tblQuestionList.indexPathForSelectedRow
        let cell = self.tblQuestionList.cellForRow(at: indexPath!) as! CellWithDatePicker
        cell.txtfldTime.text = dateFormatter.string(from: sender.date)
        print(dateFormatter.string(from: sender.date))
    }
    
    @objc func dismissKeyboard(on: UIButton){
        view.endEditing(true)
    }
    
    
    /**************************
     * USER DEFINED FUNCTIONS
     ***************************/
    func btnNextRoutine() {
        
        print(">>>>>>>> NEXT BUTTON ROUTINE <<<<<<<<")
        //check if response is complete
        let dataController = DataController()
        let mainController = MainViewController()
        
        if dataController.checkUserResponse() == true {
            //send workflow
            mainController.sendWorkflowResponse()
        }
        
        /*
        //check if user response is complete
        if dataController.checkUserResponse() == true {
            //send response
            let responseCode = mainController.sendWorkflowResponse()
            if responseCode == 401 {
                _requestType = "POST"
                //request new connection
                mainController.requestAzureADBConnection()
             } else if responseCode == 200 {
                 //check if last workflow
                 if _isLastWorkflow == false {
                 
                     //request next workflow
                     mainController.getWorkflow()
                 
                 } else {
                    //return to main screen
                    if let view = self.view {
                        view.removeFromSuperview()
                    }
                }
             } else {
    
                 //return to Main Screen
                utils.showOKAlert(title: "eCoRs", message: "Unable to connect to server. Please try again later.")
            }
        } else {
            utils.showOKAlert(title: "eCoRs", message: "Plese fill out all the required information.")
        }
    */
    }
    
    
    
    //clear tableview cells
    func clearTableViewCells() {
        numRows = 0
        tblQuestionList.dataSource = self  //clear tableview data source to clear table
        tblQuestionList.reloadData() // reload tableview
    }
    
    //reload tableview
    func reloadTableView() {
        numRows = _workflowQuestions.count
        tblQuestionList.dataSource = self
        tblQuestionList.reloadData()
    }
        
    //open camera
    /*private func openCamera()
    {
        print("camera")
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    */
}
