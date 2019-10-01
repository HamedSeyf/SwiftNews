//
//  ArticleView.swift
//  SwiftNews
//
//  Created by Hamed Seyf on 9/29/19.
//  Copyright © 2019 SwiftNews. All rights reserved.
//

import Foundation
import WebKit
import PINRemoteImage
import MBProgressHUD

class ArticleView : UIView, WKNavigationDelegate {
    
    private static let sideMargins: CGFloat     = 12.0
    private static let verticalMargins: CGFloat = 10.0
    private static let verticalGap: CGFloat		= 10.0
    private static let titleFontSize: CGFloat	= 14.0
    private static let loadingArticleCaption 	= "Loading Article"
    
    private var scrollView: UIScrollView!
    private var webView: WKWebView?
    private var imageView: UIImageView?
    private var article: ArticleEntity!
    private var progressBar: MBProgressHUD?
    private var webViewContentHeight: CGFloat?
    
    init(frame: CGRect, articleObject: ArticleEntity) {
        super.init(frame: frame)
        
        article = articleObject
        
        scrollView = UIScrollView()
        scrollView.bounces = true
        addSubview(scrollView!)
        
        if let imageURL = articleObject.imageURL() {
            imageView = UIImageView(frame: CGRect.zero)
            imageView!.backgroundColor = UIColor.gray
            scrollView.addSubview(imageView!)
            imageView!.pin_setImage(from: imageURL)
        }
        
        initWebViewAndSpinner()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
		super.layoutSubviews()
        
        scrollView.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height)
        
        let netWidth = scrollView.frame.width - 2.0 * ArticleView.verticalMargins
        
        if let imageHeightToWidthRatio = article.imageHeightToWidthRatio() {
        	imageView?.frame = CGRect(
                x: ArticleView.sideMargins,
                y: ArticleView.verticalMargins,
                width: netWidth,
                height: netWidth * imageHeightToWidthRatio)
        } else {
            imageView?.frame = CGRect.zero
        }
        
        let webViewTop = getWebViewTopPosition()
        webView?.frame = CGRect(
            x: ArticleView.sideMargins,
            y: webViewTop,
            width: netWidth,
            height: scrollView.frame.height - webViewTop)
        
        updateScrollViewsContentSize()
    }
    
    private func initWebViewAndSpinner() {
		if let htmlBody = article?.htmlBody {
            progressBar = MBProgressHUD(view: self)
            if let infantProgressBar = progressBar{
                infantProgressBar.label.text = ArticleView.loadingArticleCaption
                infantProgressBar.mode = .indeterminate
                addSubview(infantProgressBar)
                infantProgressBar.show(animated: true)
            }
            
            let webViewConfiguration = WKWebViewConfiguration()
            let preference = WKPreferences()
            preference.minimumFontSize = 12.0
            preference.javaScriptEnabled = true
            preference.javaScriptCanOpenWindowsAutomatically = false
            webViewConfiguration.preferences = preference
            
            webView = WKWebView(frame: CGRect.zero, configuration: webViewConfiguration)
            webView?.allowsBackForwardNavigationGestures = false
            webView?.navigationDelegate = self
            scrollView.addSubview(webView!)
			webView!.loadHTMLString(htmlBody, baseURL: nil)
        }
    }
    
    private func getWebViewTopPosition() -> CGFloat {
    	return (imageView != nil) ? (imageView!.frame.maxY + ArticleView.verticalGap) : ArticleView.verticalMargins
    }
    
    private func updateScrollViewsContentSize() {
        let scrollViewContentHeight = getWebViewTopPosition() + (webViewContentHeight ?? 0.0)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollViewContentHeight)
    }
    
    // MARK: WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView === self.webView {
        	progressBar?.hide(animated: true)
        	
            webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { [weak self] (height, error) in
                self?.webViewContentHeight = height as? CGFloat
                self?.updateScrollViewsContentSize()
            })
        }
    }
    
}
