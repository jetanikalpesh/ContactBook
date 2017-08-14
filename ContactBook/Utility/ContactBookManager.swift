//
//  ContactBookManager.swift
//  ContactBook
//
//  Created by jetani kalpesh on 13/08/17.
//  Copyright © 2017 sigmacoder. All rights reserved.
//

import UIKit
import Contacts

class ContactBookManager {
    
    static let shared = ContactBookManager.init()
    lazy var store : CNContactStore = CNContactStore()
    
    //MARK:- Stay Awaken
    required init() {
        NotificationCenter.default.addObserver(self, selector: #selector(getContactList), name: NSNotification.Name.CNContactStoreDidChange, object: nil)
    }
    
    //MARK:-
    @objc func getContactList() {
        //completionHandler : ((Bool, [ModelContact]?)->())? = nil
        
        let contactStore = CNContactStore.init()
        
        contactStore.requestAccess(for: .contacts, completionHandler: {
            granted, error in
            
            guard granted else {
                NotificationCenter.default.post(name: NSNotification.Name.init("FetchContactRequestCompleted"), object: error)
                return
            }
            
            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactPhoneNumbersKey
                ] as [Any]
            
            let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
            var arrContactList : [ModelContact] = []
            
            do {
                try contactStore.enumerateContacts(with: request){
                    (contact, cursor) -> Void in
                    
                    let model = ModelContact()
                    model.name = contact.givenName
                    model.identifier = contact.identifier
                    if let firstNumer = contact.phoneNumbers.first?.value {
                        model.number = firstNumer.stringValue
                    }else{
                        model.number = "Unknown"
                    }
                    arrContactList.append(model)
                }
            } catch let error {
                NSLog("Fetch contact error: \(error)")
            }
            
            arrContactList.sort(by: {
                return $0.name ?? "Unknown" < $1.name ?? "Unknown"
            })
            
            NotificationCenter.default.post(name: NSNotification.Name.init("FetchContactRequestCompleted"), object: arrContactList)
        })
    }
    
    func addContact(model: ModelContact, completionHandler : ((NSError?)->())? = nil) {
        
        if let name = model.name,
            let number = model.number{
            
            let newDetail = CNMutableContact()
            newDetail.givenName = name
            
            let contactNumber = CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: number))
            newDetail.phoneNumbers = [contactNumber]
            
            let request = CNSaveRequest()
            request.add(newDetail, toContainerWithIdentifier: nil)
            
            do{
                try store.execute(request)
                 completionHandler?(nil)
            } catch {
                completionHandler?(error as NSError)
            }
        }
        
    }
    
    func removeContact(model : ModelContact, completionHandler : ((NSError?)->())? = nil){
        
        if let identifier = model.identifier {
            let predicate = CNContact.predicateForContacts(withIdentifiers: [identifier])
            do {
                let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor])
                
                guard let contact = contacts.first else{
                    completionHandler?(NSError(domain: "ContactBook", code: -400, userInfo: [NSLocalizedDescriptionKey : "Contact is not available in phone book"]))
                    return
                }
                
                let req = CNSaveRequest()
                let mutableContact = contact.mutableCopy() as! CNMutableContact
                req.delete(mutableContact)
                
                do{
                    try store.execute(req)
                    completionHandler?(nil)
                } catch {
                    completionHandler?(error as NSError)
                }
            }
            catch {
                completionHandler?(error as NSError)
            }
        }
    }
}
