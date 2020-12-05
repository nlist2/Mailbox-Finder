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

class FirstViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    // Connecting SearchBar and Map to the code
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mainMap: MKMapView!
    let chicago_center = CLLocation(latitude: 41.8781, longitude: -87.6298)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        mainMap.delegate = self
        
        // Setting default location to the center of the map
        self.centerMapOnLocation(location: chicago_center)
        
        
        // Setting map region: From Ray Wenderlich
        let region = MKCoordinateRegion(center: chicago_center.coordinate, latitudinalMeters: 13500, longitudinalMeters: 30000)
        mainMap.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region),animated: true)
        
        // Setting Zoom range of the map
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 70000)
        mainMap.setCameraZoomRange(zoomRange, animated: true)
        
        // Search bar styling
        searchBar.barTintColor = UIColor.clear
        searchBar.backgroundColor = UIColor.systemGray4
        searchBar.isTranslucent = false
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.searchTextField.layer.cornerRadius = 18
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.backgroundColor = UIColor.white
        searchBar.layer.cornerRadius = 27
        
        // Put all of the pins down
        var index = 0
        for location in Data.latitudes {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location, longitude: Data.longitudes[index])
            annotation.title = Data.addresses[index]
            mainMap.addAnnotation(annotation)
            index += 1
        }
    }

     func centerMapOnLocation(location: CLLocation) {
        
        // Opening animation referenced from StackOverflow
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 13500, longitudinalMeters: 30000)
        DispatchQueue.main.async {
            self.mainMap.setRegion(region, animated: true)
        }
    }
    
    func mainMap(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        annotationView.glyphTintColor = UIColor.blue
        return annotationView
    }

}

