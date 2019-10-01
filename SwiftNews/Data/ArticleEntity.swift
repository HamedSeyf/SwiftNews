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
    @objc dynamic var imageAddress: String?
    @objc dynamic var imageWidth: NSNumber = 0.0
    @objc dynamic var imageHeight: NSNumber = 0.0
    @objc dynamic var htmlBody: String?
    
    override class func primaryKey() -> String? {
        return "title"
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        title <- map["data.title"]
        imageAddress <- map["data.thumbnail"]
        imageWidth <- map["data.thumbnail_width"]
        imageHeight <- map["data.thumbnail_height"]
        htmlBody <- map["data.selftext_html"]
        htmlBody = htmlBody?.decodedHTML(wrapInBody: true)
    }
    
    // MARK: Helper functions
    
    func hasValidTitle() -> Bool {
        return (title != nil) && (title!.count > 0)
    }
    
    func hasValidArticleBody() -> Bool {
        return (htmlBody != nil) && (htmlBody!.count > 0)
    }
    
    func imageURL() -> URL? {
        var retVal: URL? = nil
        
        if let validImageAddress = imageAddress {
            if (validImageAddress.count > 0) &&
                (imageWidth.intValue > 0) &&
                (imageHeight.intValue > 0) &&
                (!ArticleEntity.unAcceptableImageURLs.contains(validImageAddress)) {
                
                retVal = URL(string: validImageAddress)
            }
        }
        
        return retVal
    }
    
    func imageHeightToWidthRatio() -> CGFloat? {
        return (imageURL() != nil) ? CGFloat(imageHeight.floatValue / imageWidth.floatValue) : nil
    }
    
    func imageHeightForWidth(width: CGFloat) -> CGFloat {
        var retVal: CGFloat = 0.0
        
        if let imageHeightToWidthRatio = imageHeightToWidthRatio() {
            retVal = width * imageHeightToWidthRatio
        }
        
        return retVal
    }
    
}
