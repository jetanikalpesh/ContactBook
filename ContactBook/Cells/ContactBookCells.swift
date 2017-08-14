//
//  ContactListCell.swift
//  ContactBook
//
//  Created by jetani kalpesh on 13/08/17.
//  Copyright © 2017 sigmacoder. All rights reserved.
//

import UIKit

class ContactListCell: UITableViewCell {

    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelNumber: UILabel!
    
    func setUpCell(model : ModelContact){
        
        labelName.text = model.name
        labelNumber.text = model.number
    }
}

class ContactHistoryCell: ContactListCell {
    
    @IBOutlet var labelState: UILabel!
    
    override func setUpCell(model : ModelContact){
        super.setUpCell(model: model)
        labelState.text = model.state
    }
}
