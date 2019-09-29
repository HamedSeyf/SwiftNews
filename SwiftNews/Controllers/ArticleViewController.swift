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
    private var articleView: ArticleView!
    
    required init(articleObject: ArticleEntity) {
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissPressed))
        navigationItem.title = articleObject.title
        
        articleView = ArticleView()
        article = articleObject
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
     	
        view.addSubview(articleView)
        articleView.translatesAutoresizingMaskIntoConstraints = false
        articleView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        articleView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        articleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        articleView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        if let htmlBody = article?.htmlBody {
            articleView.loadHTMLString(htmlBody, baseURL: nil)
        }
    }
    
    @objc private func dismissPressed() {
        dismiss(animated: true, completion: nil)
    }
    
}
