//
//  DataModels.swift
//  ContactBook
//
//  Created by jetani kalpesh on 15/08/17.
//  Copyright © 2017 sigmacoder. All rights reserved.
//

import UIKit

class ModelContact: NSObject {
    
    struct keys {
        static let name = "name"
        static let number = "number"
        static let identifier = "identifier"
        static let state = "state"
    }
    
    var name: String?
    var number: String?
    var identifier: String?
    var state: String?
}

