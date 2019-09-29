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
    private var currentArticleService: ArticleService?
    private var newsUpdateTime: Date?
    private weak var currentArticleNC: ArticleNavController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = titleString
        
        articles = [ArticleEntity]()
        
        tableView = ArticleTableView(frame: CGRect.zero, style: .plain)
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
            softRefreshNews()
        }
    }
    
    func updateWithArticles(newArticles: [ArticleEntity]?) {
        articles = newArticles ?? [ArticleEntity]()
        newsUpdateTime = Date()
        tableView.reloadData()
    }
    
    private func hardRefreshNews() {
        invalidateArticleService()
        
        softRefreshNews()
    }
    
    private func softRefreshNews() {
        if (currentArticleService == nil) {
            currentArticleService = ArticleService.fetchNews(completionHandler: { [weak self] (service, newsEntity, error) in
                if service === self?.currentArticleService {
                    self?.invalidateArticleService()
                    if error == nil {
                        self?.updateWithArticles(newArticles: newsEntity?.articles)
                    }
                }
            })
        }
    }
    
    private func invalidateArticleService() {
        currentArticleService?.invalidate()
        currentArticleService = nil
    }
    
    // MARK: ArticleTableView's UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var retVal: ArticleTableViewCell?
        
        let rawCell = tableView.dequeueReusableCell(withIdentifier: articleCellsIdentifier)
        
        if let typedCell = rawCell as? ArticleTableViewCell {
            typedCell.updateWithArticle(article: articles[indexPath.row])
            retVal = typedCell
        } else {
            retVal = ArticleTableViewCell()
        }
        
        assert(rawCell != nil, "Something went wrong trying to recover a reusable article cell!")
        
        return retVal!
    }
    
    // MARK: ArticleTableView's UITableViewDelegate
	
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ArticleTableViewCell.estimatedHeight(tableView: tableView, article: articles[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentArticleNC == nil {
            let newArticleNC = ArticleNavController(articleObject: articles[indexPath.row])
            newArticleNC.mainArticleVC.dismissCallback = { [weak self] (toBeDismissedVC: BaseViewController) in
                self?.currentArticleNC = nil
            }
            currentArticleNC = newArticleNC
            
            newArticleNC.modalPresentationStyle = .popover
            present(newArticleNC, animated: true, completion: nil)
        }
    }
    
}
