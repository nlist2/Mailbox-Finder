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

// Note some code has been referenced from Apple's Documentation, Ray Wenderlich and StackOverflow, as noted below
class FirstViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    // Connecting Map to the code
    @IBOutlet weak var mainMap: MKMapView!
    
    // Defining global/static variables
    let chicago_center = CLLocation(latitude: 41.8781, longitude: -87.6298)
    static var week_hours = "N/A"
    static var sat_hours = "N/A"
    static var sun_hours = "N/A"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connecting our map to the CustomAnnotationView
        mainMap.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        // Setting default location to the center of the map
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: chicago_center.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mainMap.setRegion(coordinateRegion, animated: true)
        
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
            annotation.subtitle = "Collection hours: Mon-Fri: " + Data.week_hours[index] + " Sat: " + Data.sat_hours[index] + " Sun: " + Data.sun_hours[index]
            
            mainMap.addAnnotation(annotation)
            index += 1
        }
    }
    
}

// Overriding classic annotation view so that we can customize
class CustomAnnotationView: MKMarkerAnnotationView{
    // Override code referenced from Apple's documentation
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

    @available(*, unavailable)
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    
    // Function for when annotation view is clicked: send an alert
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        // Grabs the MapView as the topController
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
        // Creating the alertview
        let message = (self.annotation?.subtitle)!

        let refreshAlert = UIAlertController(title: (self.annotation?.title)!, message: message, preferredStyle: UIAlertController.Style.alert)

        // If user clicks the Directions button, navigate to Maps app
        refreshAlert.addAction(UIAlertAction(title: "Directions", style: .default, handler: { (action: UIAlertAction!) in
            
                let replaced = (self.annotation?.title)!?.replacingOccurrences(of: " ", with: "%20", options: NSString.CompareOptions.literal, range: nil)

                if let url = URL(string: "http://maps.apple.com/?address=" + replaced!){
                    UIApplication.shared.open(url)
                }
        }))
        
        // If they click Cancel, dismiss the alert
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                topController.dismiss(animated: true)
        }))
            
        topController.present(refreshAlert, animated: true, completion: nil)
        }
    }
}
