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

    private lazy var avgSpeedCaption = UILabel(frame: CGRectZero)
    private lazy var maxSpeedCaption = UILabel(frame: CGRectZero)
    
    lazy var speed = UILabel(frame:CGRectZero)
    lazy var speedUnits = UILabel(frame: CGRectZero)
    lazy var maxSpeed = UILabel(frame: CGRectZero)
    lazy var avgSpeed = UILabel(frame: CGRectZero)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {

        speed.font = UIFont(name:"GillSans-Light", size:heroFontSize)
        speed.setTranslatesAutoresizingMaskIntoConstraints(false)
        speed.adjustsFontSizeToFitWidth = true
        speed.text = "0"
        
        speedUnits.font = UIFont(name:"GillSans-Light", size:captionFontSize)
        speedUnits.setTranslatesAutoresizingMaskIntoConstraints(false)
        speedUnits.adjustsFontSizeToFitWidth = false
        speedUnits.textColor = captionColor
        speedUnits.text = "MPH"
        
        maxSpeed.font = UIFont(name:"GillSans-Light", size:minorFontSize)
        maxSpeed.setTranslatesAutoresizingMaskIntoConstraints(false)
        maxSpeed.adjustsFontSizeToFitWidth = false
        maxSpeed.text = "-"
        
        maxSpeedCaption.font = UIFont(name: "GillSans-Light", size: captionFontSize)
        maxSpeedCaption.setTranslatesAutoresizingMaskIntoConstraints(false)
        maxSpeedCaption.textColor = captionColor
        maxSpeedCaption.text = "MAX"

        avgSpeed.font = UIFont(name:"GillSans-Light", size:minorFontSize)
        avgSpeed.setTranslatesAutoresizingMaskIntoConstraints(false)
        avgSpeed.adjustsFontSizeToFitWidth = false
        avgSpeed.text = "-"
        
        avgSpeedCaption.font = UIFont(name: "GillSans-Light", size: captionFontSize)
        avgSpeedCaption.setTranslatesAutoresizingMaskIntoConstraints(false)
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
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: speed,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: speedUnits,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: speed,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: speedUnits,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: speed,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 24.0))

        addConstraint(NSLayoutConstraint(item: avgSpeedCaption,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: avgSpeedCaption,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: avgSpeed,
            attribute: NSLayoutAttribute.Baseline,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: avgSpeed,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: avgSpeed,
            attribute: NSLayoutAttribute.Baseline,
            relatedBy: NSLayoutRelation.Equal,
            toItem: speed,
            attribute: NSLayoutAttribute.Baseline,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: maxSpeedCaption,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: maxSpeedCaption,
            attribute: NSLayoutAttribute.Baseline,
            relatedBy: NSLayoutRelation.Equal,
            toItem: speed,
            attribute: NSLayoutAttribute.CenterY,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: maxSpeed,
            attribute: NSLayoutAttribute.Baseline,
            relatedBy: NSLayoutRelation.Equal,
            toItem: maxSpeedCaption,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: maxSpeed,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0.0))

        super.updateConstraints()
        
    }
}

@IBDesignable class CylDistanceTimeDashboardView : UIView {

    private lazy var moduleCaption = UILabel(frame:CGRectZero)
    private lazy var durationCaption = UILabel(frame:CGRectZero)
    
    lazy var distance = UILabel(frame:CGRectZero)
    lazy var distanceUnits = UILabel(frame:CGRectZero)
    lazy var duration = UILabel(frame:CGRectZero)
    lazy var paceCaption = UILabel(frame:CGRectZero)
    lazy var pace = UILabel(frame:CGRectZero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {

        setTranslatesAutoresizingMaskIntoConstraints(false)
        
        moduleCaption.font = UIFont(name: fontName, size: captionFontSize)
        moduleCaption.setTranslatesAutoresizingMaskIntoConstraints(false)
        moduleCaption.adjustsFontSizeToFitWidth = false
        moduleCaption.textColor = globalTintColor
        moduleCaption.text = "DISTANCE"

        distance.font = UIFont(name: fontName, size: majorFontSize)
        distance.setTranslatesAutoresizingMaskIntoConstraints(false)
        distance.adjustsFontSizeToFitWidth = false
        distance.text = "85.41"

        distanceUnits.font = UIFont(name: fontName, size: captionFontSize)
        distanceUnits.setTranslatesAutoresizingMaskIntoConstraints(false)
        distanceUnits.adjustsFontSizeToFitWidth = false
        distanceUnits.textColor = captionColor
        distanceUnits.text = "MILES"

        duration.font = UIFont(name: fontName, size: majorFontSize)
        duration.setTranslatesAutoresizingMaskIntoConstraints(false)
        duration.adjustsFontSizeToFitWidth = false
        duration.text = "5:30.10"
        
        durationCaption.font = UIFont(name: fontName, size: captionFontSize)
        durationCaption.setTranslatesAutoresizingMaskIntoConstraints(false)
        durationCaption.adjustsFontSizeToFitWidth = false
        durationCaption.textColor = globalTintColor
        durationCaption.text = "DURATION"

        pace.font = UIFont(name: fontName, size: minorFontSize)
        pace.setTranslatesAutoresizingMaskIntoConstraints(false)
        pace.adjustsFontSizeToFitWidth = false
        pace.text = "85.41"
        
        paceCaption.font = UIFont(name: fontName, size: captionFontSize)
        paceCaption.setTranslatesAutoresizingMaskIntoConstraints(false)
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
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: moduleCaption,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: distance,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: moduleCaption,
            attribute: NSLayoutAttribute.Baseline,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: distance,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: distanceUnits,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: distance,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: distanceUnits,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: distance,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 9.0))

        addConstraint(NSLayoutConstraint(item: durationCaption,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: durationCaption,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: distance,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: 8.0))

        addConstraint(NSLayoutConstraint(item: duration,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: durationCaption,
            attribute: NSLayoutAttribute.Baseline,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: duration,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: pace,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: pace,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: distance,
            attribute: NSLayoutAttribute.Baseline,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: paceCaption,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: paceCaption,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: pace,
            attribute: NSLayoutAttribute.Baseline,
            multiplier: 1.0,
            constant: 0.0))

        super.updateConstraints()
    }
    
}

@IBDesignable class CylCadenceDashboardView : UIView {
 
    private lazy var moduleCaption = UILabel(frame: CGRectZero)
    private lazy var avgCaption = UILabel(frame: CGRectZero)
    private lazy var maxCaption = UILabel(frame: CGRectZero)
    
    lazy var cadence = UILabel(frame: CGRectZero)
    lazy var cadenceUnits = UILabel(frame: CGRectZero)
    lazy var avg = UILabel(frame: CGRectZero)
    lazy var max = UILabel(frame: CGRectZero)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
    
        moduleCaption.font = UIFont(name: fontName, size: captionFontSize)
        moduleCaption.setTranslatesAutoresizingMaskIntoConstraints(false)
        moduleCaption.adjustsFontSizeToFitWidth = false
        moduleCaption.textColor = globalTintColor
        moduleCaption.text = "CADENCE"

        cadence.font = UIFont(name: fontName, size: majorFontSize)
        cadence.setTranslatesAutoresizingMaskIntoConstraints(false)
        cadence.adjustsFontSizeToFitWidth = false
        cadence.text = "76"

        cadenceUnits.font = UIFont(name: fontName, size: captionFontSize)
        cadenceUnits.setTranslatesAutoresizingMaskIntoConstraints(false)
        cadenceUnits.adjustsFontSizeToFitWidth = false
        cadenceUnits.textColor = captionColor
        cadenceUnits.text = "RPM"

        max.font = UIFont(name: fontName, size: minorFontSize)
        max.setTranslatesAutoresizingMaskIntoConstraints(false)
        max.adjustsFontSizeToFitWidth = false
        max.text = "120"
        
        maxCaption.font = UIFont(name: fontName, size: captionFontSize)
        maxCaption.setTranslatesAutoresizingMaskIntoConstraints(false)
        maxCaption.adjustsFontSizeToFitWidth = false
        maxCaption.textColor = captionColor
        maxCaption.text = "MAX"

        avg.font = UIFont(name: fontName, size: minorFontSize)
        avg.setTranslatesAutoresizingMaskIntoConstraints(false)
        avg.adjustsFontSizeToFitWidth = false
        avg.text = "79.5"

        avgCaption.font = UIFont(name: fontName, size: captionFontSize)
        avgCaption.setTranslatesAutoresizingMaskIntoConstraints(false)
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
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: moduleCaption,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: cadence,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: moduleCaption,
            attribute: NSLayoutAttribute.Baseline,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: cadence,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: cadenceUnits,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: cadence,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: cadenceUnits,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: cadence,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 9.0))

        addConstraint(NSLayoutConstraint(item: max,
            attribute: NSLayoutAttribute.Baseline,
            relatedBy: NSLayoutRelation.Equal,
            toItem: cadence,
            attribute: NSLayoutAttribute.Baseline,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: max,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1.50,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: maxCaption,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: max,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: -9.0))
        
        addConstraint(NSLayoutConstraint(item: maxCaption,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: max,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: avg,
            attribute: NSLayoutAttribute.Baseline,
            relatedBy: NSLayoutRelation.Equal,
            toItem: cadence,
            attribute: NSLayoutAttribute.Baseline,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: avg,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0.0))

        addConstraint(NSLayoutConstraint(item: avgCaption,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: avg,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: -9.0))
        
        addConstraint(NSLayoutConstraint(item: avgCaption,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: avg,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0.0))

        super.updateConstraints()
    }
}

@IBDesignable class CylHeartRateDashboardView : UIView {

    private lazy var moduleCaption = UILabel(frame: CGRectZero)
    private lazy var hrUnits = UILabel(frame: CGRectZero)
    private lazy var avgCaption = UILabel(frame: CGRectZero)
    private lazy var maxCaption = UILabel(frame: CGRectZero)
    
    lazy var hr = UILabel(frame: CGRectZero)
    lazy var avg = UILabel(frame: CGRectZero)
    lazy var max = UILabel(frame: CGRectZero)


    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        moduleCaption.font = UIFont(name: fontName, size: captionFontSize)
        moduleCaption.setTranslatesAutoresizingMaskIntoConstraints(false)
        moduleCaption.adjustsFontSizeToFitWidth = false
        moduleCaption.textColor = globalTintColor
        moduleCaption.text = "HEART RATE"
        
        hr.font = UIFont(name: fontName, size: majorFontSize)
        hr.setTranslatesAutoresizingMaskIntoConstraints(false)
        hr.adjustsFontSizeToFitWidth = false
        hr.text = "161"
        
        hrUnits.font = UIFont(name: fontName, size: captionFontSize)
        hrUnits.setTranslatesAutoresizingMaskIntoConstraints(false)
        hrUnits.adjustsFontSizeToFitWidth = false
        hrUnits.textColor = captionColor
        hrUnits.text = "BPM"
        
        max.font = UIFont(name: fontName, size: minorFontSize)
        max.setTranslatesAutoresizingMaskIntoConstraints(false)
        max.adjustsFontSizeToFitWidth = false
        max.text = "170"
        
        maxCaption.font = UIFont(name: fontName, size: captionFontSize)
        maxCaption.setTranslatesAutoresizingMaskIntoConstraints(false)
        maxCaption.adjustsFontSizeToFitWidth = false
        maxCaption.textColor = captionColor
        maxCaption.text = "MAX"
        
        avg.font = UIFont(name: fontName, size: minorFontSize)
        avg.setTranslatesAutoresizingMaskIntoConstraints(false)
        avg.adjustsFontSizeToFitWidth = false
        avg.text = "99.5"
        
        avgCaption.font = UIFont(name: fontName, size: captionFontSize)
        avgCaption.setTranslatesAutoresizingMaskIntoConstraints(false)
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
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: moduleCaption,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: hr,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: moduleCaption,
            attribute: NSLayoutAttribute.Baseline,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: hr,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: hrUnits,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: hr,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: hrUnits,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: hr,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 9.0))
        
        addConstraint(NSLayoutConstraint(item: max,
            attribute: NSLayoutAttribute.Baseline,
            relatedBy: NSLayoutRelation.Equal,
            toItem: hr,
            attribute: NSLayoutAttribute.Baseline,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: max,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1.50,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: maxCaption,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: max,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: -8.0))
        
        addConstraint(NSLayoutConstraint(item: maxCaption,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: max,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: avg,
            attribute: NSLayoutAttribute.Baseline,
            relatedBy: NSLayoutRelation.Equal,
            toItem: hr,
            attribute: NSLayoutAttribute.Baseline,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: avg,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: avgCaption,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: avg,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: -9.0))
        
        addConstraint(NSLayoutConstraint(item: avgCaption,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: avg,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0.0))

        super.updateConstraints()
    }
}

@IBDesignable class CylGeoDashboardView : UIView {

    private lazy var moduleCaption = UILabel(frame: CGRectZero)
    private lazy var ascCaption = UILabel(frame: CGRectZero)
    private lazy var desCaption = UILabel(frame: CGRectZero)
    
    lazy var el = UILabel(frame: CGRectZero)
    lazy var elUnits = UILabel(frame: CGRectZero)
    lazy var asc = UILabel(frame: CGRectZero)
    lazy var des = UILabel(frame: CGRectZero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {

        moduleCaption.font = UIFont(name: fontName, size: captionFontSize)
        moduleCaption.setTranslatesAutoresizingMaskIntoConstraints(false)
        moduleCaption.adjustsFontSizeToFitWidth = false
        moduleCaption.textColor = globalTintColor
        moduleCaption.text = "ELEVATION"

        el.font = UIFont(name: fontName, size: majorFontSize)
        el.setTranslatesAutoresizingMaskIntoConstraints(false)
        el.adjustsFontSizeToFitWidth = false
        el.text = "3452"
        
        elUnits.font = UIFont(name: fontName, size: captionFontSize)
        elUnits.setTranslatesAutoresizingMaskIntoConstraints(false)
        elUnits.adjustsFontSizeToFitWidth = false
        elUnits.textColor = captionColor
        elUnits.text = "FEET"

        asc.font = UIFont(name: fontName, size: minorFontSize)
        asc.setTranslatesAutoresizingMaskIntoConstraints(false)
        asc.adjustsFontSizeToFitWidth = false
        asc.text = "161"
        
        ascCaption.font = UIFont(name: fontName, size: captionFontSize)
        ascCaption.setTranslatesAutoresizingMaskIntoConstraints(false)
        ascCaption.adjustsFontSizeToFitWidth = false
        ascCaption.textColor = captionColor
        ascCaption.text = "ASCENT"
        
        des.font = UIFont(name: fontName, size: minorFontSize)
        des.setTranslatesAutoresizingMaskIntoConstraints(false)
        des.adjustsFontSizeToFitWidth = false
        des.text = "170"
        
        desCaption.font = UIFont(name: fontName, size: captionFontSize)
        desCaption.setTranslatesAutoresizingMaskIntoConstraints(false)
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
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: moduleCaption,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: el,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: moduleCaption,
            attribute: NSLayoutAttribute.Baseline,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: el,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: elUnits,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: el,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: elUnits,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: el,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 9.0))
        
        addConstraint(NSLayoutConstraint(item: asc,
            attribute: NSLayoutAttribute.Baseline,
            relatedBy: NSLayoutRelation.Equal,
            toItem: el,
            attribute: NSLayoutAttribute.Baseline,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: asc,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1.50,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: ascCaption,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: asc,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: -9.0))
        
        addConstraint(NSLayoutConstraint(item: ascCaption,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: asc,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: des,
            attribute: NSLayoutAttribute.Baseline,
            relatedBy: NSLayoutRelation.Equal,
            toItem: el,
            attribute: NSLayoutAttribute.Baseline,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: des,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: desCaption,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: des,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: -9.0))
        
        addConstraint(NSLayoutConstraint(item: desCaption,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: des,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0.0))
        
        super.updateConstraints()
    }

}