//
//  UIImagePickerControllerExtension.swift
//  MemeMe
//
//  Created by Iulia Nitulescu on 29/03/2018.
//  Copyright © 2018 Iulia Nitulescu. All rights reserved.
//

import Foundation
import UIKit

extension UIImagePickerController
{
    override open var shouldAutorotate: Bool {
        return true
    }
    override open var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .all
    }
}
