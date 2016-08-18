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
        
        if let cg = UIGraphicsGetCurrentContext() {
            if (superview?.subviews.last != self) {
                cg.setLineWidth(1.0);
                cg.setStrokeColor(gray: 0.752, alpha: 1.0)
                cg.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y + rect.size.height))
                cg.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height))
                cg.strokePath()
            }
        }
    }
}
