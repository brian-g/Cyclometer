//
//  ViewController.swift
//  Cyclometer
//
//  Created by Brian on 12/31/14.
//  Copyright (c) 2014 Brian Glaeske. All rights reserved.
//

import UIKit

class CylNavigationController : UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.tintColor = UIColor(red:0.0, green:0.415, blue:0.431, alpha:1.0)
        self.navigationBar.barTintColor = UIColor(red:1.0, green:0.89, blue:0.639, alpha:1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func pushViewController(viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
        self.setNavigationBarHidden(false, animated: animated)

    }

    override func popViewControllerAnimated(animated: Bool) -> UIViewController? {
        var anObject = super.popViewControllerAnimated(animated)

//        NSLog("pop")
//        if self.childViewControllers?.count == 0 {
//            self.setNavigationBarHidden(true, animated: animated)
//        }
        
        return anObject
    }
}

class CylDashboardController : UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class CylHistoryController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

class CylSettingsController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}