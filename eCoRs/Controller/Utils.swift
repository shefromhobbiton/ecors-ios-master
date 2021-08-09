//
//  Utils.swift
//  eCoRs
//
//  Created by She Razon-Bulalaque on 16/09/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class Utils: NSObject {

    //alert helper
    func showOKAlert(title: String, message: String) {
        //show alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
        //Cancel Action
        }))
    }
}
