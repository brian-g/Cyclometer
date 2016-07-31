//
//  NavigationController.swift
//  Cyclometer
//
//  Created by Brian on 7/30/16.
//  Copyright © 2016 Brian Glaeske. All rights reserved.
//

import Foundation
import UIKit

class NavigationController : UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationBar.barTintColor = globalTintColor
        
        self.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
        self.setNavigationBarHidden(false, animated: animated)
        
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let anObject = super.popViewController(animated: animated)
        
        if self.childViewControllers.count == 1 {
            
            self.setNavigationBarHidden(true, animated: animated)
        }
        
        return anObject
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog(segue.identifier!);
    }
}
