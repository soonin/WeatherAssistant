//
//  BookmarkedTools.swift
//  WeatherAssistant
//
//  Created by Pooya on 2018-09-27.
//  Copyright © 2018 Pooya. All rights reserved.
//

import UIKit
import CoreData

class BookmarkedTools {
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    
    // Save new record inside Entity with value >> locationName: String, lat: String, lon: String
    func saveDataToEntity(locationName: String, lat: String, lon: String) -> Bool {
        var saveDone = false
        let newData = NSEntityDescription.insertNewObject(forEntityName: "BookmarkedEntity", into: context)
        newData.setValue(locationName , forKey: "locationName")
        newData.setValue(lat, forKey: "lat")
        newData.setValue(lon, forKey: "lon")
        
        do {
            try context.save()
            saveDone = true
            
        } catch {
            print(error)
            saveDone = false
        }
        
        return saveDone
    }// End of saveDataToEntity(locationName: String, lat: String, lon: String)
    
    
    // search inside Entity for searchString and Type searchType e.g. contains case insensitive
    func searchInEntity(searchString: String, searchType : String = "") -> [BookmarkedEntity] {
        
        var outputArray : [BookmarkedEntity] = []
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BookmarkedEntity")
        
        switch searchType {
        case "CCI":
            request.predicate = NSPredicate(format: "locationName CONTAINS[cd] %@", searchString) // contains case insensitive
            break
        case "CCS":
            request.predicate = NSPredicate(format: "locationName CONTAINS %@", searchString)   // contains case sensitive
            break
        case "LCI":
            request.predicate = NSPredicate(format: "locationName LIKE[cd] %@", searchString)   // like case insensitive
            break
        case "ECI":
            request.predicate = NSPredicate(format: "locationName ==[cd] %@", searchString)     // equal case insensitive
            break
        case "ECS":
            request.predicate = NSPredicate(format: "locationName == %@", searchString)   // equal case sensitive
            break
        default:
            request.predicate = NSPredicate(format: "locationName CONTAINS[cd] %@", searchString) // contains case insensitive
        }
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                for oneLine in result {
                    outputArray.append(oneLine as! BookmarkedEntity)
                }
            } else {
                // "No match Found!"
            }
        } catch {
            print(error)
        }
        
        return outputArray
    } // End of searchInEntity(searchString: String, searchType : String = "")
    
    
    
    
    //MARK: Convert to Generic
    // feach all Entity Data to array
    func fetchData() -> [BookmarkedEntity] {
        
        var outputArray : [BookmarkedEntity] = []
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            outputArray = try context.fetch(BookmarkedEntity.fetchRequest())
        } catch {
            print(error)
        }
        return outputArray
    } // End of fetchData()
    
    
    
    
    //MARK: Convert to Generic
    // delete elemet of Entity array with index
    func deleteDataFromEntity(index : Int) {
        var tempList : [NSManagedObject]!
        do {
            tempList = try context.fetch(BookmarkedEntity.fetchRequest())
        } catch {
            print(error)
        }
        let deleteData = tempList[index]
        context.delete(deleteData)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    } // End of deleteDataFromEntity(index : Int)
    
    
    func deleteAllData(_ entity:String="BookmarkedEntity") {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
} // end of  class BookmarkedTools


