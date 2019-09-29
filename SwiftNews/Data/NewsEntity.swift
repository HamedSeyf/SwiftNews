//
//  NewsEntity.swift
//  SwiftNews
//
//  Created by Hamed Seyf on 9/29/19.
//  Copyright © 2019 SwiftNews. All rights reserved.
//

import Foundation
import ObjectMapper

class NewsEntity: BaseEntity {
    
    var articles: [ArticleEntity]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        articles <- map["data.children"]
    }
    
}
