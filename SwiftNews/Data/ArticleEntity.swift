//
//  ArticleEntity.swift
//  SwiftNews
//
//  Created by Hamed Seyf on 9/29/19.
//  Copyright © 2019 SwiftNews. All rights reserved.
//

import Foundation
import ObjectMapper

class ArticleEntity : BaseEntity {
    
    private static let unAcceptableImageURLs = ["self"]
    
    @objc dynamic var title: String?
    @objc dynamic var imageURL: String?
    @objc dynamic var imageWidth: NSNumber = 0.0
    @objc dynamic var imageHeight: NSNumber = 0.0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        title <- map["data.title"]
        imageURL <- map["data.thumbnail"]
        imageWidth <- map["data.thumbnail_width"]
        imageHeight <- map["data.thumbnail_height"]
    }
    
    // MARK: Helper functions
    
    func hasValidTitle() -> Bool {
        return (title != nil) && (title!.count > 0)
    }
    
    func imageURLIsValid() -> Bool {
        return (imageURL != nil) && (imageURL!.count > 0) &&
            (imageWidth.intValue > 0) &&
            (imageHeight.intValue > 0) &&
            (!ArticleEntity.unAcceptableImageURLs.contains(imageURL!))
    }
    
    func imageHeightToWidthRatio() -> CGFloat? {
        return imageURLIsValid() ? CGFloat(imageHeight.floatValue / imageWidth.floatValue) : nil
    }
    
    func imageHeightForWidth(width: CGFloat) -> CGFloat {
        var retVal: CGFloat = 0.0
        
        if let imageHeightToWidthRatio = imageHeightToWidthRatio() {
            retVal = width * imageHeightToWidthRatio
        }
        
        return retVal
    }
    
}
