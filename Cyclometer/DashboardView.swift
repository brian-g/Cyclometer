//
//  CylDashboardCards.swift
//  Cyclometer
//
//  Created by Brian on 1/19/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import Foundation
import UIKit

class DashboardView : UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let cg = UIGraphicsGetCurrentContext()
        
        if (superview?.subviews.last != self) {
            cg!.setLineWidth(1.0);
            cg!.setStrokeColor(gray: 0.752, alpha: 1.0)
            cg!.moveTo(x: rect.origin.x, y: rect.origin.y + rect.size.height)
            cg!.addLineTo(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height)
            cg!.strokePath()
        }
    }
}