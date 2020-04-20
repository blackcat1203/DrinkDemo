//
//  Tool.swift
//  DrinkDemo
//
//  Created by Leon on 2020/4/19.
//  Copyright © 2020 Leon. All rights reserved.
//

import UIKit
import Foundation

class Tool {
    static func errorAlert(title:String, message:String) -> UIAlertController{
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "返回", style: .default, handler: nil)
        controller.addAction(okAction)
        return controller
    }
}
