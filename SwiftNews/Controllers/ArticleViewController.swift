//
//  ArticleViewController.swift
//  SwiftNews
//
//  Created by Hamed Seyf on 9/29/19.
//  Copyright © 2019 SwiftNews. All rights reserved.
//

import Foundation
import UIKit

class ArticleViewController : BaseViewController {
    
    private(set) var article: ArticleEntity?
    
    required init(articleObject: ArticleEntity) {
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissPressed))
        navigationItem.title = articleObject.title
        
        setArticle(articleObject: articleObject)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
    }
    
    private func setArticle(articleObject: ArticleEntity) {
        article = articleObject
    }
    
    @objc private func dismissPressed() {
        dismiss(animated: true, completion: nil)
    }
    
}
