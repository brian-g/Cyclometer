//
//  CylMapAndRoute.swift
//  Cyclometer
//
//  Created by Brian on 7/30/16.
//  Copyright © 2016 Brian Glaeske. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapAndRouteController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var ride : RideManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView!.delegate = self
        
        let line = MKPolyline(coordinates: ride!.coordinates, count: ride!.coordinates.count)
        mapView!.add(line, level: .aboveLabels)
        mapView!.mapRectThatFits(line.boundingMapRect)
        mapView!.userTrackingMode = .followWithHeading
        mapView!.showsCompass = true
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        
        if overlay is MKPolyline {
    
            polylineRenderer.strokeColor = #colorLiteral(red: 0.3449069262, green: 0.7287212014, blue: 0.01709888875, alpha: 1)
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return polylineRenderer
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPoint(_ sender: UILongPressGestureRecognizer) {
        NSLog("long press baby!")
    }
}
