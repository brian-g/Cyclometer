//
//  CylNumberCardView.swift
//  Cyclometer
//
//  Created by Brian on 2/8/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import Foundation
import UIKit

class CylNumberCardView : UIView {
    

    let number: UILabel = UILabel()
    let label: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
        label.font = UIFont(name:"Gill Sans Light", size:11.0)
        number.font = UIFont(name:"Gill Sans Light", size:48.0)
        
        addSubview(number)
        addSubview(label)
        
//        NSLayoutConstraint.constraintsWithVisualFormat(<#format: String#>,
//            options: <#NSLayoutFormatOptions#>,
//            metrics: <#[NSObject : AnyObject]?#>,
//            views: <#[NSObject : AnyObject]#>)
    }
}