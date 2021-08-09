//
//  eCoRsTests.swift
//  eCoRsTests
//
//  Created by She Razon-Bulalaque on 26/08/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import XCTest
@testable import eCoRs

class eCoRsTests: XCTestCase {

    /************ MARK: Questions Class Tests ************/
    
    // Confirm that the Questions initializer returns a Qeustions object when passed valid parameters.
    func testMealInitializationSucceeds() {
        //init?(workflowID: String, workflowTitle: String, questionID: String, questionType: String, questionDetails: String, response: String) {
            
        // no response
        let noAns = WorkflowQuestionsModel.init(workflowID: "1", workflowTitle: "Test Workflow", questionID: "1", questionType: "Test Question", questionDetails: "Question Details 1", response: "")
        XCTAssertNotNil(noAns)
        
        // with response
        let withAns = WorkflowQuestionsModel.init(workflowID: "1", workflowTitle: "Test Workflow", questionID: "1", questionType: "Test Question", questionDetails: "Question Details 1", response: "Answer 1")
        XCTAssertNotNil(withAns)
    }

}
