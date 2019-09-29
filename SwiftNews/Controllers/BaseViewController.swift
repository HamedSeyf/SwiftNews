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

}
