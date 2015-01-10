//
//  CardViewController.swift
//  Cyclometer
//
//  Created by Brian on 1/3/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import UIKit

enum CardWidth {
    case Half, Full
}

class CardViewController: UIViewController {

    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    var width : CardWidth = .Full

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
