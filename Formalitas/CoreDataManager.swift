//
//  CoreDataManager.swift
//  Formalitas
//
//  Created by NOOR on 21/03/20.
//  Copyright © 2020 NOOR. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    //MARK:- Public Property
    
    static let shared = CoreDataManager()
    
    //MARK:- Public Method
    
    let persistenceContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UserData")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Loading of store failed \(error)")
            }
        }
        return container
    }()
    
    @discardableResult
    func createUser(name: String, email: String) -> User? {
        let context = persistenceContainer.viewContext
        
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
        user.name = name
        user.email = email

        do {
            try context.save()
            return user
        } catch let createError {
            print("Failed to create: \(createError)")
        }

        return nil
    }
    
    func fetchUser(id: String) -> User? {
        let context = persistenceContainer.viewContext
        
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let user = try context.fetch(fetchRequest)
            return user.first
        } catch let fetchError {
            print("Failed to fetch: \(fetchError)")
        }
        
        return nil
    }
 
    func updateUser(user: User) {
        let context = persistenceContainer.viewContext
        
        do {
            try context.save()
        } catch let createError {
            print("Failed to update: \(createError)")
        }
    }
    
    func deleteUser(user: User) {
        
        let context = persistenceContainer.viewContext
        context.delete(user)
        
        do {
            try context.save()
        } catch let createError {
            print("Failed to delete: \(createError)")
        }
    }
}
