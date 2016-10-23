//
//  HistoryCell.swift
//  Cyclometer
//
//  Created by Brian on 10/21/16.
//  Copyright © 2016 Brian Glaeske. All rights reserved.
//

import UIKit

class HistoryCell : UITableViewCell {
    
    @IBOutlet weak var _title: UILabel!
    @IBOutlet weak var _secondTitle: UILabel!
    @IBOutlet weak var _distance: UILabel!
    @IBOutlet weak var _mapImage: UIImageView!

    private var distanceFormatter = NumberFormatter()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        distanceFormatter.allowsFloats = true
        distanceFormatter.minimumIntegerDigits = 1
        distanceFormatter.maximumFractionDigits = 2
        distanceFormatter.minimumFractionDigits = 2
    }
    
    var title : String {
        get { return _title!.text! }
        set { _title!.text! = newValue }
    }
    
    override var description : String {
        get { return _secondTitle!.text! }
        set { _secondTitle!.text! = newValue }
    }
    
    var distance : Double {
        get { return 0 }
        set {
            _distance!.text = distanceFormatter.string(from: NSNumber(value: Measure.distance(newValue)))
        }
    }

    var mapImage : UIImage? {
        get { return _mapImage!.image }
        set { _mapImage.image = newValue }
    }
}
