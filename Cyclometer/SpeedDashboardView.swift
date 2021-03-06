//
//  SpeedDashboardView.swift
//  Cyclometer
//
//  Created by Brian on 7/30/16.
//  Copyright © 2016 Brian Glaeske. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class SpeedDashboardView : DashboardView, UnitsView {
    
    private var avgSpeedCaption = UILabel(frame: CGRect.zero)
    private var maxSpeedCaption = UILabel(frame: CGRect.zero)
    private var _speedLabel = UILabel(frame:CGRect.zero)
    private var _speedUnitsLabel = UILabel(frame: CGRect.zero)
    private var maxSpeed = UILabel(frame: CGRect.zero)
    private var avgSpeed = UILabel(frame: CGRect.zero)
    private var _numberFormatter = NumberFormatter()
    private var _avgNumberFormatter = NumberFormatter()
    
    private var _maxSpeed : Double = 0.0
    
    var speed : MetersPerSecond = 0.0 {
        didSet {
            _speedLabel.text = _numberFormatter.string(from: NSNumber(value: Measure.velocity(speed)))
            
            if (speed > _maxSpeed) {
                _maxSpeed = speed
                maxSpeed.text = _avgNumberFormatter.string(from: NSNumber(value: Measure.velocity(_maxSpeed)))
            }
        }
    }
    
    var average : MetersPerSecond = 0.0 {
        didSet {
            avgSpeed.text = _avgNumberFormatter.string(from: NSNumber(value: Measure.velocity(average)))
        }
    }
    
    var units : Units = .imperial {
        didSet {
            _speedUnitsLabel.text = Measure.speedLabel.uppercased()
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
        
        units = Measure.currentUnits
        
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
        _speedLabel.text = "—.–"
        
        _speedUnitsLabel.font = UIFont(name:"GillSans-Light", size:captionFontSize)
        _speedUnitsLabel.translatesAutoresizingMaskIntoConstraints = false
        _speedUnitsLabel.adjustsFontSizeToFitWidth = false
        _speedUnitsLabel.textColor = captionColor
        
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
