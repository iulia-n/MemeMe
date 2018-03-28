//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Iulia Nitulescu on 28/03/2018.
//  Copyright © 2018 Iulia Nitulescu. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Delete default text when editing begins
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide keyboard on return
        textField.resignFirstResponder()
        return true
    }
}
