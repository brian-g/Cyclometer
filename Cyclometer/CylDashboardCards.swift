//
//  CylDashboardCards.swift
//  Cyclometer
//
//  Created by Brian on 1/19/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import Foundation
import UIKit


let fontName = "GillSans-Light"
let captionFontSize : CGFloat = 14.0
let heroFontSize : CGFloat = 128.0
let majorFontSize : CGFloat = 56.0
let minorFontSize : CGFloat = (heroFontSize / 4)
//let globalTintColor = UIColor(red: 0.0, green: 0.75, blue: 0.86, alpha: 1.0)
let globalTintColor = UIColor(red:0, green:0.532, blue:0.679, alpha:1.0)
let captionColor = UIColor(white: 0.25, alpha: 1.0)

@IBDesignable class CylSpeedDashboardView : UIView {

    private lazy var avgSpeedCaption = UILabel(frame: CGRect.zero)
    private lazy var maxSpeedCaption = UILabel(frame: CGRect.zero)
    
    lazy var speed = UILabel(frame:CGRect.zero)
    lazy var speedUnits = UILabel(frame: CGRect.zero)
    lazy var maxSpeed = UILabel(frame: CGRect.zero)
    lazy var avgSpeed = UILabel(frame: CGRect.zero)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {

        speed.font = UIFont(name:"GillSans-Light", size:heroFontSize)
        speed.translatesAutoresizingMaskIntoConstraints = false
        speed.adjustsFontSizeToFitWidth = true
        speed.text = "0"
        
        speedUnits.font = UIFont(name:"GillSans-Light", size:captionFontSize)
        speedUnits.translatesAutoresizingMaskIntoConstraints = false
        speedUnits.adjustsFontSizeToFitWidth = false
        speedUnits.textColor = captionColor
        speedUnits.text = "MPH"
        
        maxSpeed.font = UIFont(name:"GillSans-Light", size:minorFontSize)
        maxSpeed.translatesAutoresizingMaskIntoConstraints = false
        maxSpeed.adjustsFontSizeToFitWidth = false
        maxSpeed.text = "-"
        
        maxSpeedCaption.font = UIFont(name: "GillSans-Light", size: captionFontSize)
        maxSpeedCaption.translatesAutoresizingMaskIntoConstraints = false
        maxSpeedCaption.textColor = captionColor
        maxSpeedCaption.text = "MAX"

        avgSpeed.font = UIFont(name:"GillSans-Light", size:minorFontSize)
        avgSpeed.translatesAutoresizingMaskIntoConstraints = false
        avgSpeed.adjustsFontSizeToFitWidth = false
        avgSpeed.text = "-"
        
        avgSpeedCaption.font = UIFont(name: "GillSans-Light", size: captionFontSize)
        avgSpeedCaption.translatesAutoresizingMaskIntoConstraints = false
        avgSpeedCaption.textColor = captionColor
        avgSpeedCaption.text = "AVG"

        addSubview(speed)
        addSubview(speedUnits)
        addSubview(maxSpeed)
        addSubview(maxSpeedCaption)
        addSubview(avgSpeed)
        addSubview(avgSpeedCaption)
        
        setNeedsUpdateConstraints()
        
    }
    
    override func updateConstraints() {
        
        addConstraint(NSLayoutConstraint(item: speed,
            attribute: NSLayoutAttribute.top,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.top,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: speed,
            attribute: NSLayoutAttribute.leading,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.leading,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: speedUnits,
            attribute: NSLayoutAttribute.left,
            relatedBy: NSLayoutRelation.equal,
            toItem: speed,
            attribute: NSLayoutAttribute.right,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: speedUnits,
            attribute: NSLayoutAttribute.top,
            relatedBy: NSLayoutRelation.equal,
            toItem: speed,
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
            toItem: speed,
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
            toItem: speed,
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

@IBDesignable class CylDistanceTimeDashboardView : UIView {

    private lazy var moduleCaption = UILabel(frame:CGRect.zero)
    private lazy var durationCaption = UILabel(frame:CGRect.zero)
    
    lazy var distance = UILabel(frame:CGRect.zero)
    lazy var distanceUnits = UILabel(frame:CGRect.zero)
    lazy var duration = UILabel(frame:CGRect.zero)
    lazy var paceCaption = UILabel(frame:CGRect.zero)
    lazy var pace = UILabel(frame:CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {

        translatesAutoresizingMaskIntoConstraints = false
        
        moduleCaption.font = UIFont(name: fontName, size: captionFontSize)
        moduleCaption.translatesAutoresizingMaskIntoConstraints = false
        moduleCaption.adjustsFontSizeToFitWidth = false
        moduleCaption.textColor = globalTintColor
        moduleCaption.text = "DISTANCE"

        distance.font = UIFont(name: fontName, size: majorFontSize)
        distance.translatesAutoresizingMaskIntoConstraints = false
        distance.adjustsFontSizeToFitWidth = false
        distance.text = "85.41"

        distanceUnits.font = UIFont(name: fontName, size: captionFontSize)
        distanceUnits.translatesAutoresizingMaskIntoConstraints = false
        distanceUnits.adjustsFontSizeToFitWidth = false
        distanceUnits.textColor = captionColor
        distanceUnits.text = "MILES"

        duration.font = UIFont(name: fontName, size: majorFontSize)
        duration.translatesAutoresizingMaskIntoConstraints = false
        duration.adjustsFontSizeToFitWidth = false
        duration.text = "5:30.10"
        
        durationCaption.font = UIFont(name: fontName, size: captionFontSize)
        durationCaption.translatesAutoresizingMaskIntoConstraints = false
        durationCaption.adjustsFontSizeToFitWidth = false
        durationCaption.textColor = globalTintColor
        durationCaption.text = "DURATION"

        pace.font = UIFont(name: fontName, size: minorFontSize)
        pace.translatesAutoresizingMaskIntoConstraints = false
        pace.adjustsFontSizeToFitWidth = false
        pace.text = "85.41"
        
        paceCaption.font = UIFont(name: fontName, size: captionFontSize)
        paceCaption.translatesAutoresizingMaskIntoConstraints = false
        paceCaption.adjustsFontSizeToFitWidth = false
        paceCaption.textColor = captionColor
        paceCaption.text = "MIN/MILE"
        
        addSubview(moduleCaption)
        addSubview(distance)
        addSubview(distanceUnits)
        addSubview(durationCaption)
        addSubview(duration)
        addSubview(pace)
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

        addConstraint(NSLayoutConstraint(item: distance,
            attribute: NSLayoutAttribute.top,
            relatedBy: NSLayoutRelation.equal,
            toItem: moduleCaption,
            attribute: NSLayoutAttribute.lastBaseline,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: distance,
            attribute: NSLayoutAttribute.leading,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.leading,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: distanceUnits,
            attribute: NSLayoutAttribute.left,
            relatedBy: NSLayoutRelation.equal,
            toItem: distance,
            attribute: NSLayoutAttribute.right,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: distanceUnits,
            attribute: NSLayoutAttribute.top,
            relatedBy: NSLayoutRelation.equal,
            toItem: distance,
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
            toItem: distance,
            attribute: NSLayoutAttribute.bottom,
            multiplier: 1.0,
            constant: 8.0))

        addConstraint(NSLayoutConstraint(item: duration,
            attribute: NSLayoutAttribute.top,
            relatedBy: NSLayoutRelation.equal,
            toItem: durationCaption,
            attribute: NSLayoutAttribute.lastBaseline,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: duration,
            attribute: NSLayoutAttribute.leading,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.leading,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: pace,
            attribute: NSLayoutAttribute.right,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.right,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: pace,
            attribute: NSLayoutAttribute.top,
            relatedBy: NSLayoutRelation.equal,
            toItem: distance,
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
            toItem: pace,
            attribute: NSLayoutAttribute.lastBaseline,
            multiplier: 1.0,
            constant: 0.0))

        super.updateConstraints()
    }
    
}

@IBDesignable class CylCadenceDashboardView : UIView {
 
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

@IBDesignable class CylHeartRateDashboardView : UIView {

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

@IBDesignable class CylGeoDashboardView : UIView {

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
