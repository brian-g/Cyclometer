//
//  UIKitExtensions.swift
//  Cyclometer
//
//  Created by Brian on 1/18/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    func hide() {
        self.isEnabled = false
        self.image = nil
        self.title = nil
    }
    
    func show(_ image: UIImage?, title: String?) {
        
        self.isEnabled = true
        
        if image != nil {
            self.image = image
            self.width = 0.0
        }
        
        if title != nil {
            self.title = title
        }
    }
}
