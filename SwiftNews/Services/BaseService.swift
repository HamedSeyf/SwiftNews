//
//  BaseService.swift
//  SwiftNews
//
//  Created by Hamed Seyf on 9/29/19.
//  Copyright © 2019 SwiftNews. All rights reserved.
//

import Foundation

class BaseService {
    
    public static let errorDomain: String	= "SwiftNewsErrorDomain"
    public static let defaultErrorCode		= -1
    
    func invalidate() {
        // To be overriden by subclasses
    }
    
}
