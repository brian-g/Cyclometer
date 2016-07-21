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
    

    private let numberLabel: UILabel = UILabel(frame:CGRect.zero)
    private let labelLabel: UILabel = UILabel(frame:CGRect.zero)
    private var caption : String!
    private var unitofmeasure : String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    func commonInit() {
        
        self.label = "CAPTION"
        self.units = "ft"
        self.number = "0987654321"
        
        labelLabel.textColor = UIColor(white: 0.25, alpha: 1.0)

        labelLabel.font = UIFont(name:fontName, size:11.0)
        numberLabel.font = UIFont(name:fontName, size:56.0)

        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        labelLabel.translatesAutoresizingMaskIntoConstraints = false
        
        numberLabel.adjustsFontSizeToFitWidth = true
        numberLabel.minimumScaleFactor = 0.5
        numberLabel.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]

        addSubview(numberLabel)
        addSubview(labelLabel)

        setNeedsUpdateConstraints()
    }
  
    override func updateConstraints() {
       
        let v = [ "number" : numberLabel, "label" : labelLabel]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(-10)-[number]-(-10)-[label]",
            options: NSLayoutFormatOptions(),
            metrics: nil,
            views: v))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[number]|",
            options: NSLayoutFormatOptions(),
            metrics: nil,
            views: v))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|",
            options: NSLayoutFormatOptions(),
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
            labelLabel.text = newValue.uppercased()
            labelLabel.sizeToFit()
        }
    }
    
    @IBInspectable var units : String {
        get {
            return unitofmeasure
        }
        
        set {
            unitofmeasure = newValue
            labelLabel.text = label.uppercased() + " (" + units + ")"
            labelLabel.sizeToFit()
        }
    }
}
