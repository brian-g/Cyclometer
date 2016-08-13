//
//  GeoDashboardView.swift
//  Cyclometer
//
//  Created by Brian on 7/30/16.
//  Copyright © 2016 Brian Glaeske. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class GeoDashboardView : DashboardView, UnitsView {
    
    private lazy var moduleCaption = UILabel(frame: CGRect.zero)
    private lazy var ascCaption = UILabel(frame: CGRect.zero)
    private lazy var desCaption = UILabel(frame: CGRect.zero)
    private lazy var el = UILabel(frame: CGRect.zero)
    private lazy var elUnits = UILabel(frame: CGRect.zero)
    private lazy var asc = UILabel(frame: CGRect.zero)
    private lazy var des = UILabel(frame: CGRect.zero)
    private var distanceFormatter = NumberFormatter()

    private var _currentElevation : Double = 0.0
    private var _ascent : Double = 0.0
    private var _descent : Double = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    var units : Units = .imperial {
        didSet {
            elUnits.text = Measure.smallDistanceLabel.uppercased()
        }
    }

    var elevation : Double = 0 {
        willSet {
            let diff = newValue - _currentElevation
            if (diff > 0) {
                _ascent = _ascent + diff
            } else {
                _descent = _descent - diff
            }

            el.text = distanceFormatter.string(from: Measure.distance(smallUnits: newValue))
            asc.text = distanceFormatter.string(from: Measure.distance(smallUnits: _ascent))
            des.text = distanceFormatter.string(from: Measure.distance(smallUnits: _descent))

        }
    }
    
    
    func commonInit() {

        distanceFormatter.allowsFloats = false

        moduleCaption.font = UIFont(name: fontName, size: captionFontSize)
        moduleCaption.translatesAutoresizingMaskIntoConstraints = false
        moduleCaption.adjustsFontSizeToFitWidth = false
        moduleCaption.textColor = globalTintColor
        moduleCaption.text = "ELEVATION"
        
        el.font = UIFont(name: fontName, size: majorFontSize)
        el.translatesAutoresizingMaskIntoConstraints = false
        el.adjustsFontSizeToFitWidth = false
        el.text = "0"
        
        elUnits.font = UIFont(name: fontName, size: captionFontSize)
        elUnits.translatesAutoresizingMaskIntoConstraints = false
        elUnits.adjustsFontSizeToFitWidth = false
        elUnits.textColor = captionColor
        elUnits.text = Measure.smallDistanceLabel.uppercased()
        
        
        asc.font = UIFont(name: fontName, size: minorFontSize)
        asc.translatesAutoresizingMaskIntoConstraints = false
        asc.adjustsFontSizeToFitWidth = false
        asc.text = "0"
        
        ascCaption.font = UIFont(name: fontName, size: captionFontSize)
        ascCaption.translatesAutoresizingMaskIntoConstraints = false
        ascCaption.adjustsFontSizeToFitWidth = false
        ascCaption.textColor = captionColor
        ascCaption.text = "ASCENT"
        
        des.font = UIFont(name: fontName, size: minorFontSize)
        des.translatesAutoresizingMaskIntoConstraints = false
        des.adjustsFontSizeToFitWidth = false
        des.text = "0"
        
        desCaption.font = UIFont(name: fontName, size: captionFontSize)
        desCaption.translatesAutoresizingMaskIntoConstraints = false
        desCaption.adjustsFontSizeToFitWidth = false
        desCaption.textColor = captionColor
        desCaption.text = "DESCENT"
        
        addSubview(el)
        addSubview(elUnits)
        addSubview(moduleCaption)
        addSubview(asc)
        addSubview(ascCaption)
        addSubview(des)
        addSubview(desCaption)
        
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
        
        addConstraint(NSLayoutConstraint(item: el,
                                         attribute: NSLayoutAttribute.top,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: moduleCaption,
                                         attribute: NSLayoutAttribute.lastBaseline,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: el,
                                         attribute: NSLayoutAttribute.leading,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: self,
                                         attribute: NSLayoutAttribute.leading,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: elUnits,
                                         attribute: NSLayoutAttribute.left,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: el,
                                         attribute: NSLayoutAttribute.right,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: elUnits,
                                         attribute: NSLayoutAttribute.top,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: el,
                                         attribute: NSLayoutAttribute.top,
                                         multiplier: 1.0,
                                         constant: 9.0))
        
        addConstraint(NSLayoutConstraint(item: asc,
                                         attribute: NSLayoutAttribute.lastBaseline,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: el,
                                         attribute: NSLayoutAttribute.lastBaseline,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: asc,
                                         attribute: NSLayoutAttribute.right,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: self,
                                         attribute: NSLayoutAttribute.centerX,
                                         multiplier: 1.50,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: ascCaption,
                                         attribute: NSLayoutAttribute.top,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: asc,
                                         attribute: NSLayoutAttribute.bottom,
                                         multiplier: 1.0,
                                         constant: -9.0))
        
        addConstraint(NSLayoutConstraint(item: ascCaption,
                                         attribute: NSLayoutAttribute.right,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: asc,
                                         attribute: NSLayoutAttribute.right,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: des,
                                         attribute: NSLayoutAttribute.lastBaseline,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: el,
                                         attribute: NSLayoutAttribute.lastBaseline,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: des,
                                         attribute: NSLayoutAttribute.right,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: self,
                                         attribute: NSLayoutAttribute.right,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: desCaption,
                                         attribute: NSLayoutAttribute.top,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: des,
                                         attribute: NSLayoutAttribute.bottom,
                                         multiplier: 1.0,
                                         constant: -9.0))
        
        addConstraint(NSLayoutConstraint(item: desCaption,
                                         attribute: NSLayoutAttribute.right,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: des,
                                         attribute: NSLayoutAttribute.right,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        super.updateConstraints()
    }
}
