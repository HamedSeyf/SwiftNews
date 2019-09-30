//
//  PersistentStoreManager.swift
//  SwiftNews
//
//  Created by Hamed Seyf on 9/29/19.
//  Copyright © 2019 SwiftNews. All rights reserved.
//

import Foundation
import RealmSwift
import MapKit

class PersistentStoreManager {
    
    private var realmInstance: Realm?
    
    static let sharedInstance: PersistentStoreManager? = {
        let instance = PersistentStoreManager()
        return instance
    }()
    
    private init() {
        do {
            realmInstance = try Realm()
        } catch let error {
            print("Cound not initialize Realm with error: ", error)
        }
    }
    
    func loadEntities(type: Object.Type, filter: String? = nil) -> [Object]? {
        var retVal: [Object]?
        if let results = realmInstance?.objects(type) {
            let filteredResult = (filter == nil) ? results : results.filter(filter!)
            retVal = filteredResult.map{$0}
        }
        return retVal
    }
    
    func saveEntities(_ entities: [Object]) {
        do {
            try realmInstance?.write {
                for currentEntity in entities {
                    realmInstance?.add(currentEntity, update: true)
                }
            }
        } catch let error {
            print("Saving entities failed with error: ", error)
        }
    }
    
}
