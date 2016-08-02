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

typealias QuickMeasure = MKPolyline
typealias Route = MKPolyline

class MapAndRouteController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var measureView: UIView!
    @IBOutlet weak var measureLabel: UILabel!
    
    var ride : RideManager?
    var routePoints : [CLLocationCoordinate2D] = []
    var measurePoints : [CLLocationCoordinate2D] = []
    
    var routeOverlay : MKPolyline?
    var measureOverlay : MKPolyline?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        measureView!.isHidden = true
        mapView!.delegate = self
        mapView!.userTrackingMode = .followWithHeading
        mapView!.showsCompass = true
        
        if (ride != nil) {
            routePoints = ride!.coordinates
            routeOverlay = MKPolyline(coordinates: routePoints, count: routePoints.count)
            routeOverlay!.subtitle = "Route"
            mapView!.add(routeOverlay!, level: .aboveLabels)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        
        if overlay.subtitle! == "Route" {
    
            polylineRenderer.strokeColor = #colorLiteral(red: 0.3449069262, green: 0.7287212014, blue: 0.01709888875, alpha: 1)
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        
        if overlay.subtitle! == "Distance" {
            polylineRenderer.strokeColor = #colorLiteral(red: 0.04085352272, green: 0.3748033047, blue: 0.998357594, alpha: 1)
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

        var distance : Double = 0.0
        
        if sender.state == .began || sender.state == .changed {

            measurePoints.append(mapView!.convert(sender.location(in: mapView!), toCoordinateFrom: mapView!))
            
            if measureOverlay != nil {
                mapView!.remove(measureOverlay!)
            }
            measureOverlay = MKPolyline(coordinates: measurePoints, count: measurePoints.count)
            measureOverlay!.subtitle = "Distance"
            mapView!.add(measureOverlay!, level: .aboveLabels)

            var lastPoint : CLLocation?
            
            for point in measurePoints {

                let currentPoint = CLLocation(latitude: point.latitude, longitude: point.longitude)
                
                if (lastPoint != nil) {
                    distance = distance + currentPoint.distance(from: lastPoint!)
                }
                lastPoint = currentPoint
            }
            
            let distanceString = (UIApplication.shared.delegate as! AppDelegate).distanceFormatter.string(from: distance.miles)
            
            measureLabel!.text = distanceString!.appending(" miles")
            measureView!.isHidden = false
        }
    }
    
    @IBAction func clearMeasure(_ sender: AnyObject) {
     
        if (measureOverlay != nil) {
            mapView!.remove(measureOverlay!)
        }
        measureView!.isHidden = true
    }
}
