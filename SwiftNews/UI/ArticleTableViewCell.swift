//
//  ArticleCell.swift
//  SwiftNews
//
//  Created by Hamed Seyf on 9/28/19.
//  Copyright © 2019 SwiftNews. All rights reserved.
//

import UIKit

class ArticleTableViewCell : UITableViewCell {
    
    private var titleLabel: UILabel!
    private var articleImageView: UIImageView!
    
    private static let sideMargins: CGFloat		= 10.0
    private static let verticalMargins: CGFloat	= 10.0
    private static let verticalGap: CGFloat		= 10.0
    private static let titleFontSize: CGFloat	= 12.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .gray
        
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
        // TODO: Setting image URL to nil just in case it's still loading
    }
    
    override func sizeToFit() {
        titleLabel.sizeToFit()
		
        super.sizeToFit()
    }
    
    static func estimatedHeight(tableView: UITableView, article: ArticleEntity) -> CGFloat {
        // This approach is way faster than forcing the cell object to layout its views with the article first using and then get its height. Cons here being that we end up with two duplicated logic in the code and should manually be on gaurd for them
        var retVal: CGFloat = 0.0
        let effectiveWidth = tableView.frame.width - 2.0 * sideMargins
        
        if ArticleTableViewCell.articleHasValidTitle(article: article) {
            retVal += (verticalMargins + article.title!.height(withConstrainedWidth: effectiveWidth, font: titleFont()))
        }
        
        if ArticleTableViewCell.imageURLIsValid(article: article) {
            let topGap = (retVal == 0.0) ? ArticleTableViewCell.verticalMargins : ArticleTableViewCell.verticalGap
            retVal += (topGap + ArticleTableViewCell.imageHeight(article: article, width: effectiveWidth))
        }
        
        retVal += ArticleTableViewCell.verticalMargins
        
        return retVal
    }
    
    func updateWithArticle(article: ArticleEntity) {
        titleLabel.text = article.title
        
        // TODO: Passing up the image URL here
        assert(true, "articleImageView has a valid URL already. Make sure cell is reused properly or call updateWithArticle just once.")
        
        updateUI(article: article)
    }
    
    private func updateUI(article: ArticleEntity) {
        titleLabel.isHidden = !ArticleTableViewCell.articleHasValidTitle(article: article)
        articleImageView.isHidden = !ArticleTableViewCell.imageURLIsValid(article: article)
        
        // TODO: get the correct value from the entity
        let imageWidthToHeight: CGFloat = 1.5
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ArticleTableViewCell.verticalMargins).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: (-2.0 * ArticleTableViewCell.sideMargins)).isActive = true
        
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        articleImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        articleImageView.widthAnchor.constraint(equalTo: widthAnchor, constant: (-2.0 * ArticleTableViewCell.sideMargins)).isActive = true
        articleImageView.topAnchor.constraint(
            equalTo: (ArticleTableViewCell.articleHasValidTitle(article: article) ? titleLabel.bottomAnchor : topAnchor),
            constant: (ArticleTableViewCell.articleHasValidTitle(article: article) ? ArticleTableViewCell.verticalGap : ArticleTableViewCell.verticalMargins))
            .isActive = true
        articleImageView.heightAnchor.constraint(equalTo: articleImageView.widthAnchor, multiplier: (1.0 / imageWidthToHeight)).isActive = true
        
        sizeToFit()
    }
    
    private static func titleFont() -> UIFont {
        return UIFont.systemFont(ofSize: ArticleTableViewCell.titleFontSize)
    }
    
    private static func articleHasValidTitle(article: ArticleEntity) -> Bool {
        return (article.title != nil) && (article.title!.count > 0)
    }
    
    private static func imageURLIsValid(article: ArticleEntity) -> Bool {
        return (article.imageURL != nil) && (article.imageURL!.count > 0)
    }
    
    private static func imageHeight(article: ArticleEntity, width: CGFloat) -> CGFloat {
        var retVal: CGFloat = 0.0
        
        // TODO: get the correct value from the entity
        let imageWidthToHeight: CGFloat = 1.5
        // TODO: Move this whole func into the entity obj itself
    	let shouldShowImage = ArticleTableViewCell.imageURLIsValid(article: article) && (imageWidthToHeight > 0.0)
        if shouldShowImage {
            retVal = width / imageWidthToHeight
        }
        
        return retVal
    }
    
}
