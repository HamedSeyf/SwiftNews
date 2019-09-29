//
//  BaseEntity.swift
//  SwiftNews
//
//  Created by Hamed Seyf on 9/29/19.
//  Copyright © 2019 SwiftNews. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseEntity : Mappable {
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        // Nothing in the base class
    }
    
}
