//
//  ArticleNavController.swift
//  SwiftNews
//
//  Created by Hamed Seyf on 9/29/19.
//  Copyright © 2019 SwiftNews. All rights reserved.
//

import Foundation

class ArticleNavController : BaseNavController {
    
    private(set) var mainArticleVC: ArticleViewController!
    
    required init(articleObject: ArticleEntity) {
        let rootVCLocal = ArticleViewController(articleObject: articleObject)
        
        super.init(rootViewController: rootVCLocal)
        
        mainArticleVC = rootVCLocal
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
}
