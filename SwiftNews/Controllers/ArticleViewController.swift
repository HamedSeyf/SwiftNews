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
    private var articleView: ArticleView?
    
    required init(articleObject: ArticleEntity) {
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissPressed))
        navigationItem.title = articleObject.title
        
        article = articleObject
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        if let validArticle = article {
        	articleView = ArticleView(frame: CGRect.zero, articleObject: validArticle)
     		
        	view.addSubview(articleView!)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        articleView?.frame = CGRect(
            x: 0.0,
            y: navigationBarTotalHeight,
            width: view.frame.width,
            height: view.frame.height - navigationBarTotalHeight
        )
    }
    
    @objc private func dismissPressed() {
        dismiss(animated: true, completion: nil)
    }
    
}
