//
//  DashboardView.swift
//  Cyclometer
//
//  Created by Brian on 1/14/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import UIKit

class CylCardView : UIView {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var primaryData: UILabel!
    @IBOutlet weak var secondaryData: UILabel!
    @IBOutlet weak var seconaryDataMeasure: UILabel!
    @IBOutlet weak var tertiaryData: UILabel!
    @IBOutlet weak var tertiaryDataMeasure: UILabel!
    
    @IBOutlet weak var sparkLine: UIView!
}
