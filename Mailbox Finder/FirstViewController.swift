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
import SQLite3

class FirstViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mainMap: MKMapView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainMap.userTrackingMode = .follow
        // Seeting default location
        let initialLocation = CLLocation(latitude: 41.8781, longitude: -87.6298)
        self.centerMapOnLocation(location: initialLocation)
        
        // Search bar styling
        searchBar.barTintColor = UIColor.clear
        searchBar.backgroundColor = UIColor.systemGray4
        searchBar.isTranslucent = false
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.searchTextField.layer.cornerRadius = 18
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.backgroundColor = UIColor.white
        searchBar.layer.cornerRadius = 27
    }


     func centerMapOnLocation(location: CLLocation) {
        
        // Opening animation referenced from StackOverflow
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        DispatchQueue.main.async {
            self.mainMap.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            self.mainMap.addAnnotation(annotation)
        }
    }
/*
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {

        let location = locations.last! as CLLocation

        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        self.mainMap.setRegion(region, animated: true)
    }
    */

}

