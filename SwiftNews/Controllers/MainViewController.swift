//
//  MainViewController.swift
//  SwiftNews
//
//  Created by Hamed Seyf on 9/28/19.
//  Copyright © 2019 SwiftNews. All rights reserved.
//

import CoreData
import UIKit
import MBProgressHUD

class MainViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private static let articleCellsIdentifier = "SwiftNews_CellReuseIdentifier_Article"
    private static let titleString = "Swift News"
    private static let loadingNewsCaption = "Loading News"
    private static let loadingArticleCaption = "Loading Article"
    private static let reloadNewsCaption = "Refresh"
    
    private var tableView: NewsTableView!
    private var articles: [ArticleEntity]!
    private var currentArticleService: ArticleService?
    private var newsUpdateTime: Date?
    private weak var currentArticleNC: ArticleNavController?
    private var progressBar: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: MainViewController.reloadNewsCaption, style: .plain, target: self, action: #selector(softRefreshNews))
        
        title = MainViewController.titleString
        
        articles = [ArticleEntity]()
        
        tableView = NewsTableView(frame: CGRect.zero, style: .plain)
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: MainViewController.articleCellsIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        progressBar = MBProgressHUD(view: view)
        progressBar.mode = .indeterminate
        view.addSubview(progressBar)
        progressBar.hide(animated: false)
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
    
    @objc private func softRefreshNews() {
        if (currentArticleService == nil) {
            updateLoadingSpinnerStatus(shouldShow: true, caption: MainViewController.loadingNewsCaption)
            
            currentArticleService = ArticleService.fetchNews(completionHandler: { [weak self] (service, newsEntity, error) in
                if service === self?.currentArticleService {
                    self?.updateLoadingSpinnerStatus(shouldShow: false)
                    self?.invalidateArticleService()
                    
                    if error == nil {
                        self?.updateWithArticles(newArticles: newsEntity?.articles)
                    } else {
                        self?.showAlert(title: "Oooops!", message: "Something went wrong trying to load the news.\nShow the already saved articles?", options: ["No", "Saved articles"], dismissCallback: { (userPrompt: Int) in
                            if userPrompt == 1 {
                                let savedArticles = PersistentStoreManager.sharedInstance?.loadEntities(type: ArticleEntity.self) as? [ArticleEntity]
                                
                                self?.updateWithArticles(newArticles: savedArticles)
                            }
                        })
                    }
                }
            })
        }
    }
    
    private func updateLoadingSpinnerStatus(shouldShow: Bool, caption: String? = nil) {
        if shouldShow {
            progressBar.label.text = caption
            progressBar.show(animated: true)
        } else {
            progressBar.hide(animated: true)
        }
    }
    
    private func invalidateArticleService() {
        currentArticleService?.invalidate()
        currentArticleService = nil
    }
    
    // MARK: NewsTableView's UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var retVal: NewsTableViewCell?
        
        let rawCell = tableView.dequeueReusableCell(withIdentifier: MainViewController.articleCellsIdentifier)
        
        if let typedCell = rawCell as? NewsTableViewCell {
            typedCell.updateWithArticle(article: articles[indexPath.row])
            retVal = typedCell
        } else {
            retVal = NewsTableViewCell()
        }
        
        assert(rawCell != nil, "Something went wrong trying to recover a reusable article cell!")
        
        return retVal!
    }
    
    // MARK: NewsTableView's UITableViewDelegate
	
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsTableViewCell.estimatedHeight(tableView: tableView, article: articles[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentArticleNC == nil {
            updateLoadingSpinnerStatus(shouldShow: true, caption: MainViewController.loadingArticleCaption)
            
            let newArticleNC = ArticleNavController(articleObject: articles[indexPath.row])
            newArticleNC.mainArticleVC.dismissCallback = { [weak self] (toBeDismissedVC: BaseViewController) in
                self?.currentArticleNC = nil
            }
            currentArticleNC = newArticleNC
            
            newArticleNC.modalPresentationStyle = .popover
            present(newArticleNC, animated: true, completion: { [weak self] in
                self?.updateLoadingSpinnerStatus(shouldShow: false)
            })
        }
    }
    
}
