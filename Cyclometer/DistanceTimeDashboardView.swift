//
//  DistanceTimeDashboardView.swift
//  Cyclometer
//
//  Created by Brian on 7/30/16.
//  Copyright © 2016 Brian Glaeske. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable class DistanceTimeDashboardView : DashboardView {
    
    private var moduleCaption = UILabel(frame:CGRect.zero)
    private var durationCaption = UILabel(frame:CGRect.zero)
    
    private var distanceLabel = UILabel(frame:CGRect.zero)
    private var distanceUnitsLabel = UILabel(frame:CGRect.zero)
    private var durationLabel = UILabel(frame:CGRect.zero)
    private var paceCaption = UILabel(frame:CGRect.zero)
    private var paceLabel = UILabel(frame:CGRect.zero)
    private var distanceFormatter = NumberFormatter()
    private var timeFormatter = DateComponentsFormatter()
    
    private var _units = Units.imperial
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    var distance : Double {
        get { return 0.0 }
        set {
            if (_units == .imperial) {
                distanceLabel.text = distanceFormatter.string(from: newValue.miles)
            } else {
                distanceLabel.text = distanceFormatter.string(from: newValue.km)
            }
        }
    }
    
    var duration : TimeInterval {
        get { return 0.0 }
        set {
            durationLabel.text = timeFormatter.string(from: newValue)
        }
    }
    
    var pace : Double {
        get { return 0.0 }
        set {
            
            if (_units == .imperial) {
                // We get seconds/meter. Need minutes/mile
                paceLabel.text = distanceFormatter.string(from: (newValue / 60) * kMetersInMile )
            } else {
                // We get seconds/meter. Need minutes/km
                paceLabel.text = distanceFormatter.string(from: newValue / 60 * kMetersInKm)
            }
        }
    }
    
    var units : Units {
        get { return _units }
        set {
            _units = newValue
            
            if (_units == .imperial) {
                distanceUnitsLabel.text = "MILES"
                paceCaption.text = "MIN/MILE"
            } else {
                distanceUnitsLabel.text = "KILOMETERS"
                paceCaption.text = "MIN/KM"
            }
        }
    }
    
    func commonInit() {
        
        timeFormatter.zeroFormattingBehavior = .pad
        timeFormatter.allowedUnits = [.hour,.minute,.second]
        timeFormatter.maximumUnitCount = 3
        timeFormatter.unitsStyle = .positional
        
        distanceFormatter.allowsFloats = true
        distanceFormatter.minimumIntegerDigits = 1
        distanceFormatter.maximumFractionDigits = 2
        distanceFormatter.minimumFractionDigits = 2
        
        units = Units.imperial
        
        moduleCaption.font = UIFont(name: fontName, size: captionFontSize)
        moduleCaption.translatesAutoresizingMaskIntoConstraints = false
        moduleCaption.adjustsFontSizeToFitWidth = false
        moduleCaption.textColor = globalTintColor
        moduleCaption.text = "DISTANCE"
        
        distanceLabel.font = UIFont(name: fontName, size: majorFontSize)
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.adjustsFontSizeToFitWidth = false
        distanceLabel.text = "85.41"
        
        distanceUnitsLabel.font = UIFont(name: fontName, size: captionFontSize)
        distanceUnitsLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceUnitsLabel.adjustsFontSizeToFitWidth = false
        distanceUnitsLabel.textColor = captionColor
        
        durationLabel.font = UIFont(name: fontName, size: majorFontSize)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.adjustsFontSizeToFitWidth = true
        durationLabel.text = "5:30.10"
        
        durationCaption.font = UIFont(name: fontName, size: captionFontSize)
        durationCaption.translatesAutoresizingMaskIntoConstraints = false
        durationCaption.adjustsFontSizeToFitWidth = false
        durationCaption.textColor = globalTintColor
        durationCaption.text = "DURATION"
        
        paceLabel.font = UIFont(name: fontName, size: minorFontSize)
        paceLabel.translatesAutoresizingMaskIntoConstraints = false
        paceLabel.adjustsFontSizeToFitWidth = false
        paceLabel.text = "85.41"
        
        paceCaption.font = UIFont(name: fontName, size: captionFontSize)
        paceCaption.translatesAutoresizingMaskIntoConstraints = false
        paceCaption.adjustsFontSizeToFitWidth = false
        paceCaption.textColor = captionColor
        
        addSubview(moduleCaption)
        addSubview(distanceLabel)
        addSubview(distanceUnitsLabel)
        addSubview(durationCaption)
        addSubview(durationLabel)
        addSubview(paceLabel)
        addSubview(paceCaption)
        
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
        
        addConstraint(NSLayoutConstraint(item: distanceLabel,
                                         attribute: NSLayoutAttribute.top,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: moduleCaption,
                                         attribute: NSLayoutAttribute.lastBaseline,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: distanceLabel,
                                         attribute: NSLayoutAttribute.leading,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: self,
                                         attribute: NSLayoutAttribute.leading,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: distanceUnitsLabel,
                                         attribute: NSLayoutAttribute.left,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: distanceLabel,
                                         attribute: NSLayoutAttribute.right,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: distanceUnitsLabel,
                                         attribute: NSLayoutAttribute.top,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: distanceLabel,
                                         attribute: NSLayoutAttribute.top,
                                         multiplier: 1.0,
                                         constant: 9.0))
        
        addConstraint(NSLayoutConstraint(item: durationCaption,
                                         attribute: NSLayoutAttribute.left,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: self,
                                         attribute: NSLayoutAttribute.left,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: durationCaption,
                                         attribute: NSLayoutAttribute.top,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: distanceLabel,
                                         attribute: NSLayoutAttribute.bottom,
                                         multiplier: 1.0,
                                         constant: 8.0))
        
        addConstraint(NSLayoutConstraint(item: durationLabel,
                                         attribute: NSLayoutAttribute.top,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: durationCaption,
                                         attribute: NSLayoutAttribute.lastBaseline,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: durationLabel,
                                         attribute: NSLayoutAttribute.leading,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: self,
                                         attribute: NSLayoutAttribute.leading,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: paceLabel,
                                         attribute: NSLayoutAttribute.right,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: self,
                                         attribute: NSLayoutAttribute.right,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: paceLabel,
                                         attribute: NSLayoutAttribute.top,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: distanceLabel,
                                         attribute: NSLayoutAttribute.lastBaseline,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: paceCaption,
                                         attribute: NSLayoutAttribute.right,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: self,
                                         attribute: NSLayoutAttribute.right,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: paceCaption,
                                         attribute: NSLayoutAttribute.top,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: paceLabel,
                                         attribute: NSLayoutAttribute.lastBaseline,
                                         multiplier: 1.0,
                                         constant: 0.0))
        
        super.updateConstraints()
    }
    
}
