//
//  MainViewController.swift
//  SwiftNews
//
//  Created by Hamed Seyf on 9/28/19.
//  Copyright © 2019 SwiftNews. All rights reserved.
//

import CoreData
import UIKit

class MainViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let articleCellsIdentifier = "SwiftNews_CellReuseIdentifier_Article"
    private let titleString = "Swift News"
    
    private var tableView: ArticleTableView!
    private var articles: [ArticleEntity]!
    private var newsUpdateTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = titleString
        
        articles = [ArticleEntity]()
        
        tableView = ArticleTableView(frame: CGRect.zero)
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: articleCellsIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (newsUpdateTime == nil) {
            refreshNews()
        }
    }
    
    func updateWithArticles(newArticles: [ArticleEntity]) {
        articles = newArticles
        newsUpdateTime = Date()
        tableView.reloadData()
    }
    
    private func refreshNews() {
    	// TODO
    }
    
    // MARK: ArticleTableView's delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var retVal: ArticleTableViewCell?
        
        let rawCell = tableView.dequeueReusableCell(withIdentifier: articleCellsIdentifier)
        
        if let typedCell = rawCell as? ArticleTableViewCell {
            typedCell.updateWithArticle(article: articles[indexPath.startIndex])
            retVal = typedCell
        } else {
            retVal = ArticleTableViewCell()
        }
        
        assert(rawCell != nil, "Something went wrong trying to recover a reusable article cell!")
        
        return retVal!
    }

}
