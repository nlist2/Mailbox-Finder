//
//  FirstViewController.swift
//  Mailbox Finder
//
//  Created by Noah List and Eric Elliott on 11/12/20.
//  Copyright © 2020 Noah List and Eric Elliott. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation

class FirstViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    // Connecting Map to the code
    @IBOutlet weak var mainMap: MKMapView!
    let chicago_center = CLLocation(latitude: 41.8781, longitude: -87.6298)
    static var week_hours = "N/A"
    static var sat_hours = "N/A"
    static var sun_hours = "N/A"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainMap.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        // Setting default location to the center of the map
        self.centerMapOnLocation(chicago_center, mapView: mainMap)
        
        // Setting map region: From Ray Wenderlich
        let region = MKCoordinateRegion(center: chicago_center.coordinate, latitudinalMeters: 40000, longitudinalMeters: 20000)
        mainMap.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        
        // Setting Zoom range of the map
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 75000)
        mainMap.setCameraZoomRange(zoomRange, animated: true)
        
        // Put all of the pins down
        var index = 0
        for location in Data.latitudes {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location, longitude: Data.longitudes[index])
            annotation.title = Data.addresses[index]
            annotation.subtitle = "Collection hours: Mon-Fri: " + Data.week_hours[index] +  " Sat: " + Data.sat_hours[index] + " Sun: " + Data.sun_hours[index]

            mainMap.addAnnotation(annotation)
            index += 1
        }
    }

     func centerMapOnLocation(_ location: CLLocation, mapView: MKMapView) {
         let regionRadius: CLLocationDistance = 1000
         let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
         mapView.setRegion(coordinateRegion, animated: true)
     }
    
    class CustomAnnotationView: MKMarkerAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        canShowCallout = true
        titleVisibility = MKFeatureVisibility.hidden
        let mapButton = UIButton(type: .infoLight)
        mapButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        rightCalloutAccessoryView = mapButton
        markerTintColor = UIColor.blue
        glyphImage = UIImage(named: "mailboxiconfinal.png")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let replaced = (annotation?.title)!?.replacingOccurrences(of: " ", with: "%20", options: NSString.CompareOptions.literal, range: nil)

        if let url = URL(string: "http://maps.apple.com/?address=" + replaced!){
            UIApplication.shared.open(url)
        }
    }
    
    

}

}

