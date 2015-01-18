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
                
                var alert = UIAlertController(title: "Save Ride?", message: "When you save your ride, results will also be posted to any accounts you have set up", preferredStyle: UIAlertControllerStyle.ActionSheet)
                
                alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { ( action: UIAlertAction? ) in
                    NSLog("Save")
                    
                    self.firstButton.tag = self.Play
                    self.firstButton.image = self.playImage

                }))

                alert.addAction(UIAlertAction(title: "Don't save", style: UIAlertActionStyle.Destructive, handler: { ( action: UIAlertAction? ) in
                    NSLog("Don't save")
                    
                    self.firstButton.tag = self.Play
                    self.firstButton.image = self.playImage

                }))

                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { ( action: UIAlertAction? ) in
                    
                    NSLog("Cancel")
                    
                    self.secondButton.show(self.playImage, title:nil)
                }))

                self.presentViewController(alert, animated: true, completion: { () in
                    NSLog("Done")
                })
                
            
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