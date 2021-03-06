//
//  Extensions.swift
//  SwiftNews
//
//  Created by Hamed Seyf on 9/29/19.
//  Copyright © 2019 SwiftNews. All rights reserved.
//

import UIKit
import WebKit

extension String {

    // https://stackoverflow.com/questions/30450434/figure-out-size-of-uilabel-based-on-string-in-swift
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    // https://stackoverflow.com/questions/25607247/how-do-i-decode-html-entities-in-swift
    func decodedHTML(wrapInBody: Bool) -> String? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }
        
        if wrapInBody {
            return """
<html><body><h1>
""" + attributedString.string + """
                </body></html>
                """
        } else {
            return attributedString.string
        }
    }
}

// https://stackoverflow.com/questions/30503254/get-frame-height-without-navigation-bar-height-and-tab-bar-height-in-deeper-view/37142755
extension UIViewController {
    
    var navigationBarTotalHeight: CGFloat {
        let height = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height ?? 0.0)
        return height
    }
}


extension WKUserContentController {
    
    // https://gist.github.com/pkuecuekyan/f70096218a6b969e0249427a7d324f91
    static func viewPortScript() -> WKUserScript {
        let viewPortScript = """
        var meta = document.createElement('meta');
        meta.setAttribute('name', 'viewport');
        meta.setAttribute('content', 'width=device-width');
        meta.setAttribute('initial-scale', '1.0');
        meta.setAttribute('maximum-scale', '1.0');
        meta.setAttribute('minimum-scale', '1.0');
        meta.setAttribute('user-scalable', 'no');
        document.getElementsByTagName('head')[0].appendChild(meta);
    """
        return WKUserScript(source: viewPortScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
}
