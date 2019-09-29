//
//  ArticleService.swift
//  SwiftNews
//
//  Created by Hamed Seyf on 9/29/19.
//  Copyright © 2019 SwiftNews. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class ArticleService: BaseService {
    
    private static let newsURL = "https://www.reddit.com/r/swift/.json"
    private static let successStatusCodes = [200]
    
    private var dataRequest: DataRequest?
    
    static func fetchNews(completionHandler: @escaping (ArticleService?, NewsEntity?, Error?) -> Void) -> ArticleService {
        let service = ArticleService()
        weak var weakService = service
        
        service.dataRequest = Alamofire.request(newsURL, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                if let status = response.response?.statusCode,
                    let newsResponse = response.result.value,
                    let newsEntity = Mapper<NewsEntity>().map(JSONObject: newsResponse),
                    successStatusCodes.contains(status) {
                    completionHandler(weakService, newsEntity, nil)
                } else {
                    completionHandler(weakService, nil, NSError(domain:errorDomain, code:response.response?.statusCode ?? defaultErrorCode, userInfo: nil))
                }
        }
        
        return service
    }
    
    override func invalidate() {
        dataRequest?.cancel()
    }
    
}
