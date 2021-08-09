//
//  WorkflowModel.swift
//  eCoRs
//
//  Created by She Razon-Bulalaque on 06/09/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import Foundation
import UIKit

//Workflow Details
public var testdata: String = ""
public var _totalNumberOfWorkflows: Int = 0
public var _workflowIndex: Int = 0
public var _title: String = ""
public var _enforced: Bool = false
public var _isLastWorkflow: Bool = false

//Workflow Questions
public var _workflowQuestions: [[String : Any]] = []

//Workflow Answers
public var _workflowAnswers: [[String : Any]] = []

//for sending request
public var _requestType:String = "GET"
public var _isInitialLoad:Bool = true

