//
//  DataController.swift
//  eCoRs
//
//  Created by She Razon-Bulalaque on 05/09/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import Foundation
import UIKit

struct workflowData: Decodable {
    var totalNumberOfWorkflows: Int
    var workflowIndex: Int
    var title: String
    var enforced: Bool
    var workflowQuestions:[workflowQuestions]
    var isLastWorkflow: Bool
}

struct workflowQuestions: Decodable {
    var workflowId: String
    var questionId: String
    var type: String
    var order: Int
    var  question: String
}


class DataController: NSObject {
    
    //parse JSON Data and store to data model
    func parseJSONData(JSONData: Data) {
        
        print("Parse JSON Data")
        print(JSONData)
        
        //clear data containers
        self.clearDataContainers()
        
        do {
            let workflowdata = try JSONDecoder().decode(workflowData.self, from: JSONData)
            
            print(">>>>>>>>>>> WORKFLOW DATA <<<<<<<<<<<<<")
            print(workflowdata)

            _totalNumberOfWorkflows = workflowdata.totalNumberOfWorkflows
            _workflowIndex = workflowdata.workflowIndex
            _title = workflowdata.title
            _enforced = workflowdata.enforced
            _isLastWorkflow = workflowdata.isLastWorkflow
            
            //questions
            var tempResponse: Any
            for ndx in 0..<workflowdata.workflowQuestions.count {

                _workflowQuestions.append(["workflowId": workflowdata.workflowQuestions[ndx].workflowId,
                                           "questionId": workflowdata.workflowQuestions[ndx].questionId,
                                           "type": workflowdata.workflowQuestions[ndx].type,
                                           "order": workflowdata.workflowQuestions[ndx].order,
                                           "question": workflowdata.workflowQuestions[ndx].question])
                
                //set up and initialize container for answers
                switch _workflowQuestions[ndx]["type"] as! String {
                    case "Flag", "Toggle":
                        tempResponse = false
                    case "Text":
                        tempResponse = ""
                    case "number", "Time", "numberDecimal":
                        tempResponse = 0
                    default:
                        tempResponse = ""
                }
                
                _workflowAnswers.append(["workflowId": workflowdata.workflowQuestions[ndx].workflowId,
                                            "questionId": workflowdata.workflowQuestions[ndx].questionId,
                                            "type": workflowdata.workflowQuestions[ndx].type,
                                            "response": tempResponse])
            }
            
            
        } catch let jsonErr {
            print("Error decoding json data: ", jsonErr)
            
        }
    }
    
    //set user selection
    func setUserResponse(response: Any, id: String) {
        for ctr in 0..<_workflowAnswers.count {
            if id == _workflowAnswers[ctr]["questionId"] as? String {
                _workflowAnswers[ctr]["response"] = response
                print("ctr -> ", ctr)
                print("response -> ", _workflowAnswers[ctr]["response"] as Any)
                break
            }
        }
    }
    
    //check user response
    func checkUserResponse()->Bool {
        
        print(">>>>>>>>> CHECK USER RESPONSE <<<<<<<<<<")
        var valid: Bool = false
        
        outer: for ndx in 0..<_workflowAnswers.count {
            switch _workflowAnswers[ndx]["type"] as! String {
            case "Flag", "Toggle":
                print("flag, toggle")
                if _workflowAnswers[ndx]["response"] as! Bool == false {
                    valid = false
                    break outer
                } else {
                    valid = true
                }
                break
            case "Text":
                let ans = _workflowAnswers[ndx]["response"] as? String
                print("text ->", ans as Any)
                if ans?.count == 0 {
                    valid = false
                    break outer
                } else {
                    valid = true
                }
                break
            case "number", "Time", "numberDecimal":
                let ans = _workflowAnswers[ndx]["response"] as? String
                print("numbers ->", ans as Any)
                //if _workflowAnswers[ndx]["response"] as! Int == 0 {
                if ans?.count == 0 {
                    valid = false
                    break outer
                } else {
                    valid = true
                }
                break
            default: //no response
                print("default")
                valid = true
                break outer
            }
        }
        return valid
    }
    
    //clear data containers
    func clearDataContainers() {
        
        //clear variables
        _totalNumberOfWorkflows = 0
        _workflowIndex = 0
        _title = ""
        _enforced = false
        _isLastWorkflow = false
        
        //clear dictionaries
        _workflowQuestions.removeAll()
        _workflowAnswers.removeAll()
        
    }
    
}
