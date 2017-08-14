//
//  HistoryViewController.swift
//  ContactBook
//
//  Created by jetani kalpesh on 13/08/17.
//  Copyright © 2017 sigmacoder. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView : UITableView!
    var arrayContact : [ModelContact] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 54
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.reloadData()
        
        self.arrayContact = DatabaseHelper.shared.getHistoryContacts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrayContact.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell : ContactHistoryCell = tableView.dequeueReusableCell(withIdentifier: "ContactHistoryCell") as! ContactHistoryCell
        cell.setUpCell(model: arrayContact[indexPath.row])
        return cell
    }
    
}

