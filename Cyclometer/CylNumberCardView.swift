//
//  CylNumberCardView.swift
//  Cyclometer
//
//  Created by Brian on 2/8/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CylNumberCardView : UIView {
    

    private let numberLabel: UILabel = UILabel(frame:CGRectZero)
    private let labelLabel: UILabel = UILabel(frame:CGRectZero)
    private var caption : String!
    private var unitofmeasure : String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
        self.label = "CAPTION"
        self.units = "ft"
        self.number = "0987654321"
        
//        numberLabel.backgroundColor = UIColor(red:0.8, green:0.5, blue:0.3, alpha: 1.0)
//        labelLabel.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.1, alpha: 1.0)

        labelLabel.textColor = UIColor(white: 0.25, alpha: 1.0)

        labelLabel.font = UIFont(name:"GillSans-Light", size:11.0)
        numberLabel.font = UIFont(name:"GillSans-Light", size:56.0)

        numberLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        labelLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        numberLabel.adjustsFontSizeToFitWidth = true
        numberLabel.minimumScaleFactor = 0.5
        numberLabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight

        addSubview(numberLabel)
        addSubview(labelLabel)

        setNeedsUpdateConstraints()
    }
  
    override func updateConstraints() {
       
        var v = [ "number" : numberLabel, "label" : labelLabel]
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(-10)-[number]-(-10)-[label]",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: v))
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[number]|",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: v))
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[label]|",
            options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
            metrics: nil,
            views: v))

        super.updateConstraints()
    }

    @IBInspectable var number : String {
        get {
            return numberLabel.text!
        }
        
        set {
            numberLabel.text = newValue
            numberLabel.sizeToFit()
        }
    }
    
    @IBInspectable var label : String {
        get {
            return caption
        }
        
        set {
            caption = newValue
            labelLabel.text = newValue.uppercaseString
            labelLabel.sizeToFit()
        }
    }
    
    @IBInspectable var units : String {
        get {
            return unitofmeasure
        }
        
        set {
            unitofmeasure = newValue
            labelLabel.text = label.uppercaseString + " (" + units + ")"
            labelLabel.sizeToFit()
        }
    }
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        
    }
}