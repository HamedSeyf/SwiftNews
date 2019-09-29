//
//  ArticleCell.swift
//  SwiftNews
//
//  Created by Hamed Seyf on 9/28/19.
//  Copyright © 2019 SwiftNews. All rights reserved.
//

import UIKit
import PINRemoteImage

class ArticleTableViewCell : UITableViewCell {
    
    private var titleLabel: UILabel!
    private var articleImageView: UIImageView!
    
    private static let sideMargins: CGFloat		= 10.0
    private static let verticalMargins: CGFloat	= 10.0
    private static let verticalGap: CGFloat		= 10.0
    private static let titleFontSize: CGFloat	= 12.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        titleLabel = UILabel()
        titleLabel.font = ArticleTableViewCell.titleFont()
        titleLabel.textAlignment = .left
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        
        articleImageView = UIImageView()
        addSubview(articleImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        articleImageView.pin_setImage(from: URL(string: ""))
    }
    
    override func sizeToFit() {
        titleLabel.sizeToFit()
		
        super.sizeToFit()
    }
    
    static func estimatedHeight(tableView: UITableView, article: ArticleEntity) -> CGFloat {
        // This approach is way faster than forcing the cell object to layout its views with the article first using and then get its height. Cons here being that we end up with two duplicated logic in the code and should manually be on gaurd for them
        var retVal: CGFloat = 0.0
        let effectiveWidth = tableView.frame.width - 2.0 * sideMargins
        
        if article.hasValidTitle() {
            retVal += (verticalMargins + article.title!.height(withConstrainedWidth: effectiveWidth, font: titleFont()))
        }
        
        if article.imageURL() != nil {
            let topGap = (retVal == 0.0) ? ArticleTableViewCell.verticalMargins : ArticleTableViewCell.verticalGap
            retVal += (topGap + article.imageHeightForWidth(width: effectiveWidth))
        }
        
        retVal += ArticleTableViewCell.verticalMargins
        
        return retVal
    }
    
    func updateWithArticle(article: ArticleEntity) {
        titleLabel.text = article.title
        
        articleImageView?.pin_setImage(from: article.imageURL())
        
        updateUI(article: article)
    }
    
    private func updateUI(article: ArticleEntity) {
        titleLabel.isHidden = !article.hasValidTitle()
        articleImageView.isHidden = (article.imageURL() == nil)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ArticleTableViewCell.verticalMargins).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: (-2.0 * ArticleTableViewCell.sideMargins)).isActive = true
        
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        articleImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        articleImageView.widthAnchor.constraint(equalTo: widthAnchor, constant: (-2.0 * ArticleTableViewCell.sideMargins)).isActive = true
        articleImageView.topAnchor.constraint(
            equalTo: (article.hasValidTitle() ? titleLabel.bottomAnchor : topAnchor),
            constant: (article.hasValidTitle() ? ArticleTableViewCell.verticalGap : ArticleTableViewCell.verticalMargins))
            .isActive = true
        articleImageView.heightAnchor.constraint(equalTo: articleImageView.widthAnchor, multiplier: (article.imageHeightToWidthRatio() ?? 0.0)).isActive = true
        
        sizeToFit()
    }
    
    private static func titleFont() -> UIFont {
        return UIFont.systemFont(ofSize: ArticleTableViewCell.titleFontSize)
    }
    
}
