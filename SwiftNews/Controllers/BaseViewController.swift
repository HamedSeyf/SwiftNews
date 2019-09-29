//
//  ViewController.swift
//  SwiftNews
//
//  Created by Hamed Seyf on 9/28/19.
//  Copyright © 2019 SwiftNews. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var dismissCallback: ((_ toBeDismissedVC: BaseViewController) -> Void)?
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissCallback?(self)
        
        super.dismiss(animated: flag, completion: completion)
    }
    
    func showAlert(title: String?, message: String?, options: [String], dismissCallback: @escaping (_ : Int) -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for currentOption in options {
            alertVC.addAction(
                UIAlertAction(title: currentOption, style: .default) { (action) in
                    dismissCallback(options.firstIndex(of: currentOption)!)
                }
            )
        }
        present(alertVC, animated: true, completion: nil)
    }

}
