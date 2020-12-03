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

class FirstViewController: UIViewController, CLLocationManagerDelegate {

    
    // Connecting SearchBar and Map to the code
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mainMap: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting map region: From Ray Wenderlich
        let chicago_center = CLLocation(latitude: 41.8781, longitude: -87.6298)
        let region = MKCoordinateRegion(center: chicago_center.coordinate, latitudinalMeters: 5000, longitudinalMeters: 6000)
        mainMap.setCameraBoundary(
          MKMapView.CameraBoundary(coordinateRegion: region),
          animated: true)
        
        // Setting Zoom range of the map
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 50000)
        mainMap.setCameraZoomRange(zoomRange, animated: true)
        
        // Setting default location to the center of the map
        self.centerMapOnLocation(location: chicago_center)
        
        // Search bar styling
        searchBar.barTintColor = UIColor.clear
        searchBar.backgroundColor = UIColor.systemGray4
        searchBar.isTranslucent = false
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.searchTextField.layer.cornerRadius = 18
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.backgroundColor = UIColor.white
        searchBar.layer.cornerRadius = 27
        
        // Importing our data
        
        
        // Put all of the pins down
        for item in items {
            
        }
    }


     func centerMapOnLocation(location: CLLocation) {
        
        // Opening animation referenced from StackOverflow
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        DispatchQueue.main.async {
            self.mainMap.setRegion(region, animated: true)
        }
    }

}

