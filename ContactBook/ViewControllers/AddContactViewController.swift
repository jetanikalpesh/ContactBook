//
//  AddContactViewController.swift
//  ContactBook
//
//  Created by jetani kalpesh on 15/08/17.
//  Copyright © 2017 sigmacoder. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtNumber: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonSavePressed(_ sender: Any) {
        
        let name = txtName.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let number = txtNumber.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if(name.characters.count == 0) {
            //self.showAlertForValidation(strMsg: "Please enter name")
            let alert = UIAlertController.init(title: "Contact Book", message: "Please enter user name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else if(number.characters.count == 0) {
            let alert = UIAlertController.init(title: "Contact Book", message: "Please enter  phone number", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }
        else {

            let newContact = ModelContact()
            newContact.name = name
            newContact.number = number
            
            ContactBookManager.shared.addContact(model: newContact, completionHandler: {
                error in
                
                if (error != nil) {
                    let alert = UIAlertController.init(title: "Contact Book", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    //DatabaseHelper.shared.addNewContact(contact: newContact)
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    //MARK:- UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
