//
//  CylDashboardCards.swift
//  Cyclometer
//
//  Created by Brian on 1/19/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import UIKit

enum CylCardSize {
    case Full, Half
}

@IBDesignable class CylDashboardView : UIView {

    var size = CylCardSize.Full
    
    var title : String?
    
    @IBOutlet weak var titleLabel : UILabel?
    
    override init() {
        super.init()
        
        NSLog("init")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class CylSpeedDashboardView : CylDashboardView {
    
}

class CylTimeDashboardView : CylDashboardView {

}

