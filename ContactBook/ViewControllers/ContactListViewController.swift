//
//  ViewController.swift
//  ContactBook
//
//  Created by jetani kalpesh on 13/08/17.
//  Copyright © 2017 sigmacoder. All rights reserved.
//

import UIKit

class ContactListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView : UITableView!
    var arrayContact : [ModelContact] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("FetchContactRequestCompleted"), object: nil, queue: OperationQueue.main) { [unowned self] (notification) in
            
            if let error : NSError = notification.object as? NSError {
                let controller = UIAlertController(title: "Contact Book", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                controller.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(controller, animated: true, completion: nil)
            }
            else if let array : [ModelContact] = notification.object as? [ModelContact] {
                for contact in array{
                    DatabaseHelper.shared.sycnronize(contact: contact)
                }
                self.arrayContact = array
            }
        }
        ContactBookManager.shared.getContactList()
        
        self.tableView.estimatedRowHeight = 54
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrayContact.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell : ContactListCell = tableView.dequeueReusableCell(withIdentifier: "ContactListCell") as! ContactListCell
        cell.setUpCell(model: arrayContact[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
    
        if editingStyle == .delete{
            let modelContact = arrayContact[indexPath.row]
            ContactBookManager.shared.removeContact(model: modelContact, completionHandler: { (error) in
                if error != nil{
                    let controller = UIAlertController(title: "Contact Book", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    controller.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(controller, animated: true, completion: nil)
                }
                else {
                    DatabaseHelper.shared.deleteContact(model: modelContact)
                }
            })
        }
    }
    
    //MARK:- App Navigation
    @IBAction func unwindSegueToContactListViewController(segue : UIStoryboardSegue){
        print("Segue: Back to \(#file)")
    }
    
}

