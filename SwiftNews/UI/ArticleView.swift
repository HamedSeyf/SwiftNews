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

class ArticleView : UIView {
    
    private static let sideMargins: CGFloat     = 12.0
    private static let verticalMargins: CGFloat = 10.0
    private static let verticalGap: CGFloat		= 10.0
    private static let titleFontSize: CGFloat	= 14.0
    
    private var scrollView: UIScrollView!
    private var webView: WKWebView?
    private var imageView: UIImageView?
    private var article: ArticleEntity!
    
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
        
        let webViewConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect.zero, configuration: webViewConfiguration)
        scrollView.addSubview(webView!)
        if let htmlBody = article?.htmlBody {
            webView!.loadHTMLString(htmlBody, baseURL: nil)
        }
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
        
        let webViewTop = (imageView != nil) ? (imageView!.frame.maxY + ArticleView.verticalGap) : ArticleView.verticalMargins
        webView?.frame = CGRect(
            x: ArticleView.sideMargins,
            y: webViewTop,
            width: netWidth,
            height: scrollView.frame.height - webViewTop)
        
        updateScrollViewsContentSize()
    }
    
    private func updateScrollViewsContentSize() {
        // TODO: correct value
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: 1000.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
