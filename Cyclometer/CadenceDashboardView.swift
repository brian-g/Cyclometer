//
//  CadenceDashboardView.swift
//  Cyclometer
//
//  Created by Brian on 7/30/16.
//  Copyright © 2016 Brian Glaeske. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable class CadenceDashboardView : DashboardView {
    
    private lazy var moduleCaption = UILabel(frame: CGRect.zero)
    private lazy var avgCaption = UILabel(frame: CGRect.zero)
    private lazy var maxCaption = UILabel(frame: CGRect.zero)
    
    lazy var cadence = UILabel(frame: CGRect.zero)
    lazy var cadenceUnits = UILabel(frame: CGRect.zero)
    lazy var avg = UILabel(frame: CGRect.zero)
    lazy var max = UILabel(frame: CGRect.zero)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
        moduleCaption.font = UIFont(name: fontName, size: captionFontSize)
        moduleCaption.translatesAutoresizingMaskIntoConstraints = false
        moduleCaption.adjustsFontSizeToFitWidth = false
        moduleCaption.textColor = globalTintColor
        moduleCaption.text = "CADENCE"
        
        cadence.font = UIFont(name: fontName, size: majorFontSize)
        cadence.translatesAutoresizingMaskIntoConstraints = false
        cadence.adjustsFontSizeToFitWidth = false
        cadence.text = "0"
        
        cadenceUnits.font = UIFont(name: fontName, size: captionFontSize)
        cadenceUnits.translatesAutoresizingMaskIntoConstraints = false
        cadenceUnits.adjustsFontSizeToFitWidth = false
        cadenceUnits.textColor = captionColor
        cadenceUnits.text = "RPM"
        
        max.font = UIFont(name: fontName, size: minorFontSize)
        max.translatesAutoresizingMaskIntoConstraints = false
        max.adjustsFontSizeToFitWidth = false
        max.text = "0"
        
        maxCaption.font = UIFont(name: fontName, size: captionFontSize)
        maxCaption.translatesAutoresizingMaskIntoConstraints = false
        maxCaption.adjustsFontSizeToFitWidth = false
        maxCaption.textColor = captionColor
        maxCaption.text = "MAX"
        
        avg.font = UIFont(name: fontName, size: minorFontSize)
        avg.translatesAutoresizingMaskIntoConstraints = false
        avg.adjustsFontSizeToFitWidth = false
        avg.text = "0.0"
        
        avgCaption.font = UIFont(name: fontName, size: captionFontSize)
        avgCaption.translatesAutoresizingMaskIntoConstraints = false
        avgCaption.adjustsFontSizeToFitWidth = false
        avgCaption.textColor = captionColor
        avgCaption.text = "AVG"
        
        addSubview(moduleCaption)
        addSubview(cadence)
        addSubview(cadenceUnits)
        addSubview(max)
        addSubview(maxCaption)
        addSubview(avg)
        addSubview(avgCaption)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        
        addConstraint(NSLayoutConstraint(item: moduleCaption,
                                         attribute: NSLayoutAttribute.left,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: self,
                                         attribute: NSLayoutAttribute.left,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: moduleCaption,
                                         attribute: NSLayoutAttribute.top,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: self,
                                         attribute: NSLayoutAttribute.top,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: cadence,
                                         attribute: NSLayoutAttribute.top,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: moduleCaption,
                                         attribute: NSLayoutAttribute.lastBaseline,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: cadence,
                                         attribute: NSLayoutAttribute.leading,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: self,
                                         attribute: NSLayoutAttribute.leading,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: cadenceUnits,
                                         attribute: NSLayoutAttribute.left,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: cadence,
                                         attribute: NSLayoutAttribute.right,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: cadenceUnits,
                                         attribute: NSLayoutAttribute.top,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: cadence,
                                         attribute: NSLayoutAttribute.top,
                                         multiplier: 1.0,
                                         constant: 9.0))
        
        addConstraint(NSLayoutConstraint(item: max,
                                         attribute: NSLayoutAttribute.lastBaseline,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: cadence,
                                         attribute: NSLayoutAttribute.lastBaseline,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: max,
                                         attribute: NSLayoutAttribute.right,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: self,
                                         attribute: NSLayoutAttribute.centerX,
                                         multiplier: 1.50,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: maxCaption,
                                         attribute: NSLayoutAttribute.top,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: max,
                                         attribute: NSLayoutAttribute.bottom,
                                         multiplier: 1.0,
                                         constant: -9.0))
        
        addConstraint(NSLayoutConstraint(item: maxCaption,
                                         attribute: NSLayoutAttribute.right,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: max,
                                         attribute: NSLayoutAttribute.right,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: avg,
                                         attribute: NSLayoutAttribute.lastBaseline,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: cadence,
                                         attribute: NSLayoutAttribute.lastBaseline,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: avg,
                                         attribute: NSLayoutAttribute.right,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: self,
                                         attribute: NSLayoutAttribute.right,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: avgCaption,
                                         attribute: NSLayoutAttribute.top,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: avg,
                                         attribute: NSLayoutAttribute.bottom,
                                         multiplier: 1.0,
                                         constant: -9.0))
        
        addConstraint(NSLayoutConstraint(item: avgCaption,
                                         attribute: NSLayoutAttribute.right,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: avg,
                                         attribute: NSLayoutAttribute.right,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        super.updateConstraints()
    }
}
