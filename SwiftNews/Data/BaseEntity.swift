//
//  BaseEntity.swift
//  SwiftNews
//
//  Created by Hamed Seyf on 9/29/19.
//  Copyright © 2019 SwiftNews. All rights reserved.
//

import Foundation
import ObjectMapper
import Realm
import RealmSwift

class BaseEntity : Object, Mappable {
    
    required init?(map: Map) {
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    func mapping(map: Map) {
        // Nothing in the base class
    }
    
}
