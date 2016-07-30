//
//  CylDashboardCards.swift
//  Cyclometer
//
//  Created by Brian on 1/19/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import Foundation
import UIKit

class CylDashboardView : UIView {

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


@IBDesignable class CylSpeedDashboardView : CylDashboardView {

    private var avgSpeedCaption = UILabel(frame: CGRect.zero)
    private var maxSpeedCaption = UILabel(frame: CGRect.zero)
    private var _speedLabel = UILabel(frame:CGRect.zero)
    private var _speedUnitsLabel = UILabel(frame: CGRect.zero)
    private var maxSpeed = UILabel(frame: CGRect.zero)
    private var avgSpeed = UILabel(frame: CGRect.zero)
    private var _units : Units = .imperial
    private var _numberFormatter = NumberFormatter()
    private var _avgNumberFormatter = NumberFormatter()
    
    private var _maxSpeed : Double = 0.0
    private var _avgSpeed : Double = 0.0
    
    var speed : Double {
        set {
            if (units == .imperial) {
                _speedLabel.text = _numberFormatter.string(from: newValue.inMilesPerHour())
            } else {
                _speedLabel.text = _numberFormatter.string(from: newValue.inKiloMetersPerHour())
            }
            
            if (newValue > _maxSpeed) {
                _maxSpeed = newValue
                if (units == .imperial) {
                    maxSpeed.text = _avgNumberFormatter.string(from:_maxSpeed.inMilesPerHour())
                } else {
                    maxSpeed.text = _avgNumberFormatter.string(from:_maxSpeed)
                }
            }
        }
        get {
            return 0.0
        }
    }
    
    var units : Units {
        get {
            return _units
        }
        set {
            _units = newValue
            if (_units == .imperial) {
                _speedUnitsLabel.text = "MPH"
            } else {
                _speedUnitsLabel.text = "KPH"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {

        _numberFormatter.allowsFloats = true
        _numberFormatter.minimum = 0
        _numberFormatter.maximumIntegerDigits = 2
        _numberFormatter.minimumIntegerDigits = 1
        _numberFormatter.minimumFractionDigits = 1
        _numberFormatter.maximumFractionDigits = 1
        
        _avgNumberFormatter.allowsFloats = true
        _avgNumberFormatter.maximumIntegerDigits = 2
        _avgNumberFormatter.minimumIntegerDigits = 1
        _avgNumberFormatter.minimumFractionDigits = 1
        _avgNumberFormatter.maximumFractionDigits = 1
        _avgNumberFormatter.zeroSymbol = "—.–"
        
        _speedLabel.font = UIFont(name:"GillSans-Light", size:heroFontSize)
        _speedLabel.translatesAutoresizingMaskIntoConstraints = false
        _speedLabel.adjustsFontSizeToFitWidth = true
        _speedLabel.text = "0"
        
        _speedUnitsLabel.font = UIFont(name:"GillSans-Light", size:captionFontSize)
        _speedUnitsLabel.translatesAutoresizingMaskIntoConstraints = false
        _speedUnitsLabel.adjustsFontSizeToFitWidth = false
        _speedUnitsLabel.textColor = captionColor
        units = .imperial
        
        maxSpeed.font = UIFont(name:"GillSans-Light", size:minorFontSize)
        maxSpeed.translatesAutoresizingMaskIntoConstraints = false
        maxSpeed.adjustsFontSizeToFitWidth = false

        maxSpeedCaption.font = UIFont(name: "GillSans-Light", size: captionFontSize)
        maxSpeedCaption.translatesAutoresizingMaskIntoConstraints = false
        maxSpeedCaption.textColor = captionColor
        maxSpeedCaption.text = "MAX"
        maxSpeed.text = "—.–"
        
        avgSpeed.font = UIFont(name:"GillSans-Light", size:minorFontSize)
        avgSpeed.translatesAutoresizingMaskIntoConstraints = false
        avgSpeed.adjustsFontSizeToFitWidth = false
        avgSpeed.text = "—.–"

        avgSpeedCaption.font = UIFont(name: "GillSans-Light", size: captionFontSize)
        avgSpeedCaption.translatesAutoresizingMaskIntoConstraints = false
        avgSpeedCaption.textColor = captionColor
        avgSpeedCaption.text = "AVG"

        addSubview(_speedLabel)
        addSubview(_speedUnitsLabel)
        addSubview(maxSpeed)
        addSubview(maxSpeedCaption)
        addSubview(avgSpeed)
        addSubview(avgSpeedCaption)
        
        setNeedsUpdateConstraints()
        
    }
    
    override func updateConstraints() {
        
        addConstraint(NSLayoutConstraint(item: _speedLabel,
            attribute: NSLayoutAttribute.top,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.top,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: _speedLabel,
            attribute: NSLayoutAttribute.leading,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.leading,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: _speedUnitsLabel,
            attribute: NSLayoutAttribute.left,
            relatedBy: NSLayoutRelation.equal,
            toItem: _speedLabel,
            attribute: NSLayoutAttribute.right,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: _speedUnitsLabel,
            attribute: NSLayoutAttribute.top,
            relatedBy: NSLayoutRelation.equal,
            toItem: _speedLabel,
            attribute: NSLayoutAttribute.top,
            multiplier: 1.0,
            constant: 24.0))

        addConstraint(NSLayoutConstraint(item: avgSpeedCaption,
            attribute: NSLayoutAttribute.right,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.right,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: avgSpeedCaption,
            attribute: NSLayoutAttribute.top,
            relatedBy: NSLayoutRelation.equal,
            toItem: avgSpeed,
            attribute: NSLayoutAttribute.lastBaseline,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: avgSpeed,
            attribute: NSLayoutAttribute.right,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.right,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: avgSpeed,
            attribute: NSLayoutAttribute.lastBaseline,
            relatedBy: NSLayoutRelation.equal,
            toItem: _speedLabel,
            attribute: NSLayoutAttribute.lastBaseline,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: maxSpeedCaption,
            attribute: NSLayoutAttribute.right,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.right,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: maxSpeedCaption,
            attribute: NSLayoutAttribute.lastBaseline,
            relatedBy: NSLayoutRelation.equal,
            toItem: _speedLabel,
            attribute: NSLayoutAttribute.centerY,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: maxSpeed,
            attribute: NSLayoutAttribute.lastBaseline,
            relatedBy: NSLayoutRelation.equal,
            toItem: maxSpeedCaption,
            attribute: NSLayoutAttribute.top,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: maxSpeed,
            attribute: NSLayoutAttribute.right,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.right,
            multiplier: 1.0,
            constant: 0.0))

        super.updateConstraints()
        
    }
}

@IBDesignable class CylDistanceTimeDashboardView : CylDashboardView {

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
                distanceLabel.text = distanceFormatter.string(from: newValue.inMiles())
            } else {
                distanceLabel.text = distanceFormatter.string(from: newValue.inKM())
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
                paceLabel.text = distanceFormatter.string(from: newValue.inMiles())
            } else {
                paceLabel.text = distanceFormatter.string(from: newValue)
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
    
        distanceFormatter.allowsFloats = true
        distanceFormatter.minimumIntegerDigits = 1
        distanceFormatter.maximumFractionDigits = 2
        distanceFormatter.minimumFractionDigits = 2
        timeFormatter.zeroFormattingBehavior = .pad
        timeFormatter.allowedUnits = [.hour,.minute,.second]
        timeFormatter.maximumUnitCount = 3
        timeFormatter.unitsStyle = .positional

        
        
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

@IBDesignable class CylCadenceDashboardView : CylDashboardView {
 
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
        cadence.text = "76"

        cadenceUnits.font = UIFont(name: fontName, size: captionFontSize)
        cadenceUnits.translatesAutoresizingMaskIntoConstraints = false
        cadenceUnits.adjustsFontSizeToFitWidth = false
        cadenceUnits.textColor = captionColor
        cadenceUnits.text = "RPM"

        max.font = UIFont(name: fontName, size: minorFontSize)
        max.translatesAutoresizingMaskIntoConstraints = false
        max.adjustsFontSizeToFitWidth = false
        max.text = "120"
        
        maxCaption.font = UIFont(name: fontName, size: captionFontSize)
        maxCaption.translatesAutoresizingMaskIntoConstraints = false
        maxCaption.adjustsFontSizeToFitWidth = false
        maxCaption.textColor = captionColor
        maxCaption.text = "MAX"

        avg.font = UIFont(name: fontName, size: minorFontSize)
        avg.translatesAutoresizingMaskIntoConstraints = false
        avg.adjustsFontSizeToFitWidth = false
        avg.text = "79.5"

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

@IBDesignable class CylHeartRateDashboardView : CylDashboardView {

    private lazy var moduleCaption = UILabel(frame: CGRect.zero)
    private lazy var hrUnits = UILabel(frame: CGRect.zero)
    private lazy var avgCaption = UILabel(frame: CGRect.zero)
    private lazy var maxCaption = UILabel(frame: CGRect.zero)
    
    lazy var hr = UILabel(frame: CGRect.zero)
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
        moduleCaption.text = "HEART RATE"
        
        hr.font = UIFont(name: fontName, size: majorFontSize)
        hr.translatesAutoresizingMaskIntoConstraints = false
        hr.adjustsFontSizeToFitWidth = false
        hr.text = "161"
        
        hrUnits.font = UIFont(name: fontName, size: captionFontSize)
        hrUnits.translatesAutoresizingMaskIntoConstraints = false
        hrUnits.adjustsFontSizeToFitWidth = false
        hrUnits.textColor = captionColor
        hrUnits.text = "BPM"
        
        max.font = UIFont(name: fontName, size: minorFontSize)
        max.translatesAutoresizingMaskIntoConstraints = false
        max.adjustsFontSizeToFitWidth = false
        max.text = "170"
        
        maxCaption.font = UIFont(name: fontName, size: captionFontSize)
        maxCaption.translatesAutoresizingMaskIntoConstraints = false
        maxCaption.adjustsFontSizeToFitWidth = false
        maxCaption.textColor = captionColor
        maxCaption.text = "MAX"
        
        avg.font = UIFont(name: fontName, size: minorFontSize)
        avg.translatesAutoresizingMaskIntoConstraints = false
        avg.adjustsFontSizeToFitWidth = false
        avg.text = "99.5"
        
        avgCaption.font = UIFont(name: fontName, size: captionFontSize)
        avgCaption.translatesAutoresizingMaskIntoConstraints = false
        avgCaption.adjustsFontSizeToFitWidth = false
        avgCaption.textColor = captionColor
        avgCaption.text = "AVG"
        
        addSubview(moduleCaption)
        addSubview(hr)
        addSubview(hrUnits)
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
        
        addConstraint(NSLayoutConstraint(item: hr,
            attribute: NSLayoutAttribute.top,
            relatedBy: NSLayoutRelation.equal,
            toItem: moduleCaption,
            attribute: NSLayoutAttribute.lastBaseline,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: hr,
            attribute: NSLayoutAttribute.leading,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.leading,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: hrUnits,
            attribute: NSLayoutAttribute.left,
            relatedBy: NSLayoutRelation.equal,
            toItem: hr,
            attribute: NSLayoutAttribute.right,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: hrUnits,
            attribute: NSLayoutAttribute.top,
            relatedBy: NSLayoutRelation.equal,
            toItem: hr,
            attribute: NSLayoutAttribute.top,
            multiplier: 1.0,
            constant: 9.0))
        
        addConstraint(NSLayoutConstraint(item: max,
            attribute: NSLayoutAttribute.lastBaseline,
            relatedBy: NSLayoutRelation.equal,
            toItem: hr,
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
            constant: -8.0))
        
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
            toItem: hr,
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

@IBDesignable class CylGeoDashboardView : CylDashboardView {

    private lazy var moduleCaption = UILabel(frame: CGRect.zero)
    private lazy var ascCaption = UILabel(frame: CGRect.zero)
    private lazy var desCaption = UILabel(frame: CGRect.zero)
    
    lazy var el = UILabel(frame: CGRect.zero)
    lazy var elUnits = UILabel(frame: CGRect.zero)
    lazy var asc = UILabel(frame: CGRect.zero)
    lazy var des = UILabel(frame: CGRect.zero)

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
        moduleCaption.text = "ELEVATION"

        el.font = UIFont(name: fontName, size: majorFontSize)
        el.translatesAutoresizingMaskIntoConstraints = false
        el.adjustsFontSizeToFitWidth = false
        el.text = "3452"
        
        elUnits.font = UIFont(name: fontName, size: captionFontSize)
        elUnits.translatesAutoresizingMaskIntoConstraints = false
        elUnits.adjustsFontSizeToFitWidth = false
        elUnits.textColor = captionColor
        elUnits.text = "FEET"

        asc.font = UIFont(name: fontName, size: minorFontSize)
        asc.translatesAutoresizingMaskIntoConstraints = false
        asc.adjustsFontSizeToFitWidth = false
        asc.text = "161"
        
        ascCaption.font = UIFont(name: fontName, size: captionFontSize)
        ascCaption.translatesAutoresizingMaskIntoConstraints = false
        ascCaption.adjustsFontSizeToFitWidth = false
        ascCaption.textColor = captionColor
        ascCaption.text = "ASCENT"
        
        des.font = UIFont(name: fontName, size: minorFontSize)
        des.translatesAutoresizingMaskIntoConstraints = false
        des.adjustsFontSizeToFitWidth = false
        des.text = "170"
        
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
