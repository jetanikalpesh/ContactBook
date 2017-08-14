//
//  DatabaseHelper.swift
//  ContactBook
//
//  Created by jetani kalpesh on 13/08/17.
//  Copyright © 2017 sigmacoder. All rights reserved.
//

import UIKit
import CoreData
import Contacts


class DatabaseHelper: NSObject {
    
    enum ContactState : String {
        case new = "new"
        case update = "updated"
        case old = "old"
        case delete = "deleted"
    }
    
    static let shared = DatabaseHelper()
    
    required override init() {
        //Required
    }
    
    func sycnronize(contact: ModelContact) {
        
        let state = self.getContactState(contact: contact)
        switch state {
        case .new:
            self.addNewContact(contact: contact)
        case .old:
            self.updateState(contact : contact)
        case .update:
            self.updateContact(contact: contact)
        default :
            break
        }
    }
    
    
    func getContactState(contact: ModelContact) -> ContactState {
        
        if let name = contact.name,
            let number = contact.number,
            let identifier = contact.identifier {
            
            let context = appDelegate.persistentContainer.viewContext
            let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
            let predicate = NSPredicate(format: "name == %@ and number == %@ and identifier == %@", identifier, number, name)
            request.predicate = predicate
            request.fetchLimit = 1
            
            do{
                let count = try context.count(for: request)
                
                if(count == 0) {
                    
                    let predicate = NSPredicate(format: "identifier == %@", identifier)
                    request.predicate = predicate
                    
                    let tempCount = try context.count(for: request)
                    
                    if(tempCount == 0) {
                        return ContactState.new
                    }
                    else {
                        return ContactState.update
                    }
                }
                else {
                    return ContactState.old
                }
            }
            catch {
                print("Error \(error as NSError)")
            }
        }
        
        return ContactState.new
        
    }
    
    func updateContact(contact: ModelContact) {
        
        if let name = contact.name,
            let number = contact.number,
            let identifier = contact.identifier {
            
            let context = appDelegate.persistentContainer.viewContext
            let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
            
            let predicate = NSPredicate(format: "identifier == %@", identifier)
            
            request.predicate = predicate
            request.fetchLimit = 1
            
            do{
                let contacts = try context.fetch(request)
                if let contact = contacts.first {
                    contact.name = name
                    contact.number = number
                    contact.identifier = identifier
                    contact.state = ContactState.update.rawValue
                    
                    let task = History(context: context)
                    task.name = name
                    task.number = number
                    task.state = ContactState.update.rawValue
                    
                    appDelegate.saveContext()
                }
            }
            catch {
                print("Error \(error as NSError)")
            }
        }
    }
    
    func addNewContact(contact: ModelContact) {
        
        if let name = contact.name,
            let number = contact.number,
            let identifier = contact.identifier {
            
            let context = appDelegate.persistentContainer.viewContext
            let contact = Contacts(context: context)
            contact.name = name
            contact.number = number
            contact.identifier = identifier
            contact.state = ContactState.new.rawValue
            
            let contactHistory = History(context: context)
            contactHistory.name = name
            contactHistory.number = number
            contactHistory.state = ContactState.new.rawValue
            
            appDelegate.saveContext()
        }
    }
    
    func updateState(contact: ModelContact) {
        
        if let identifier = contact.identifier,
            let state = contact.state {
            
            let context = appDelegate.persistentContainer.viewContext
            let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
            
            request.fetchLimit = 1
            
            let predicate = NSPredicate(format: "identifier == %@", identifier)
            request.predicate = predicate
            
            do{
                let contacts = try context.fetch(request)
                if let contact = contacts.first {
                    contact.state = state
                    appDelegate.saveContext()
                }
            }
            catch {
                print("Error \(error as NSError)")
            }
        }
        
    }
    
    func deleteContact(model : ModelContact) {
        
        let context = appDelegate.persistentContainer.viewContext
        let contactHistory = History(context: context)
        contactHistory.name = model.name
        contactHistory.number = model.number
        contactHistory.state = ContactState.delete.rawValue
        
        appDelegate.saveContext()
    }
    
    func getHistoryContacts() -> [ModelContact] {
        
        var arrList : [ModelContact] = []
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<History> = History.fetchRequest()
        
        do{
            let contacts = try context.fetch(request)
            for contact in contacts.enumerated() {
                
                let newContact = ModelContact()
                newContact.name = contact.element.name
                newContact.number = contact.element.number
                newContact.state = contact.element.state
                arrList.append(newContact)
            }
        }
        catch {
            print("unable to fetch \(error as NSError)")
        }
        return arrList
    }
}
