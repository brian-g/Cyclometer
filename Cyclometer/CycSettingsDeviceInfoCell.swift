//
//  CycSettingsDeviceInfoCell.swift
//  Cyclometer
//
//  Created by Brian on 1/13/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import UIKit


class CylSettingsDeviceInfoCell : UITableViewCell {
    
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var deviceCapabilities: UILabel!
    @IBOutlet weak var isConnected: UIImageView!
    @IBOutlet var isRemembered: UISwitch!
    
    var peripheral : NSUUID!
    
    @IBAction func toggleRemembered(sender: AnyObject) {
        NSLog("Nothing hooked up to CylSettingsInfoCell")
    }
}
