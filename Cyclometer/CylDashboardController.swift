//
//  CylDashboardController.swift
//  Cyclometer
//
//  Created by Brian on 1/16/15.
//  Copyright (c) 2015 Brian Glaeske. All rights reserved.
//

import UIKit

let dashboardCellId = "CylDashboardCell"


class CylDashboardController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let Play = 0
    let Stop = 1
    let Pause = 2

    let playImage = UIImage(named: "Play")
    let pauseImage = UIImage(named: "Pause")
    let stopImage = UIImage(named: "Stop")
    
    @IBOutlet weak var firstButton: UIBarButtonItem!
    @IBOutlet weak var secondButton: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstButton.tag = Play
        firstButton.image = playImage
        
        secondButton.hide()

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleRideState(sender: UIBarButtonItem) {
        
        var buttonTag = sender.tag

        secondButton.hide()

        switch buttonTag {
            case Play:
                firstButton.tag = Pause
                firstButton.image = pauseImage
                
            case Stop:
                
                firstButton.tag = Play
                firstButton.image = playImage
                
            case Pause:
                firstButton.tag = Stop
                firstButton.image = stopImage
                
                secondButton.enabled = true
                secondButton.show(playImage, title:nil)
                secondButton.tag = Play
            
            default:
                NSLog("You're screwed")
            
        }
        
    }
    
    // UICollectionViewDataSource Protocol
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        var cell : UICollectionViewCell? = collectionView.dequeueReusableCellWithReuseIdentifier(dashboardCellId, forIndexPath: indexPath) as? UICollectionViewCell
        
        if cell === nil {
            cell = UICollectionViewCell()
        }
        return cell!

    }
}