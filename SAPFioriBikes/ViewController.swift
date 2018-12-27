//
//  ViewController.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 11/14/18.
//  Copyright © 2018 Takahashi, Alex. All rights reserved.
//

import UIKit
import MapKit
import SAPFiori

class ViewController: FUIMKMapFloorplanViewController, MKMapViewDelegate, SearchResultsProducing, CLLocationManagerDelegate {
    
    var mapModel = FioriBikeMapModel()
    let isClusteringStations = true
    
    // SearchResultsProducing Protocol
    var searchResults: SearchResults!
    var isFiltered: Bool = false
    
    // Show Current Location
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation? {
        didSet {
            mapModel.userLocation = currentLocation
        }
    }
    
    var stationModel: [BikeStationAnnotation] {
        get {
            return mapModel.stationModel
        }
    }
    
    var filteredResults: [BikeStationAnnotation] = []
    
    var tableView: UITableView? {
        get {
            return detailPanel.searchResults.tableView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Model Setup
        mapModel.delegate = self
        mapModel.loadData()
        
        // MARK: Standard Map Setup
        title = mapModel.title
        mapView.delegate = self
        mapView.setRegion(mapModel.region, animated: true)
        mapView.mapType = mapModel.mapType
        mapView.register(BikeStationAnnotationView.self, forAnnotationViewWithReuseIdentifier: "BikeStationAnnotationView")
        
        // MARK: FUIMKMapViewDataSource
        self.dataSource = self

        // MARK: FUIMapLegend
        legend.headerTextView.text = mapModel.legendTitle
        legend.items = mapModel.legendModel
        
        // MARK: UserLocation
        mapView.showsUserLocation = true
        // SOURCE: https://stackoverflow.com/questions/25449469/show-current-location-and-update-location-in-mkmapview-in-swift
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        searchResults = SearchResults(self)
        detailPanel.searchResults.tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier: FUIObjectTableViewCell.reuseIdentifier)
        detailPanel.searchResults.tableView.dataSource = searchResults
        detailPanel.searchResults.searchBar.delegate = searchResults
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let _ = annotation as? MKUserLocation { return nil }
        guard !(annotation is MKClusterAnnotation) else {
            if isClusteringStations {
                let clusterAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView
                clusterAnnotationView?.markerTintColor = Colors.lightBlue
                clusterAnnotationView?.titleVisibility = .hidden
                clusterAnnotationView?.subtitleVisibility = .hidden
                return clusterAnnotationView
            } else {
                let bikeStationAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "BikeStationAnnotationView") as? BikeStationAnnotationView
                bikeStationAnnotationView?.displayPriority = .required
                return bikeStationAnnotationView
            }
        }
        if let bikeStationAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "BikeStationAnnotationView", for: annotation) as? BikeStationAnnotationView {
            bikeStationAnnotationView.clusteringIdentifier = "bike"
            bikeStationAnnotationView.canShowCallout = true
            bikeStationAnnotationView.displayPriority = .defaultLow
            return bikeStationAnnotationView
        }
        return nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer {
            currentLocation = locations.last
        }
        
        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
                mapView.setRegion(viewRegion, animated: false)
            }
        }
    }
}

// MARK: FUIMKMapViewDataSource

extension ViewController: FUIMKMapViewDataSource {
    
    func mapView(_ mapView: MKMapView, geometriesForLayer layer: FUIGeometryLayer) -> [FUIAnnotation] {
        return mapModel.stationModel
    }
    
    func numberOfLayers(in mapView: MKMapView) -> Int {
        return mapModel.layerModel.count
    }
    
    func mapView(_ mapView: MKMapView, layerAtIndex index: Int) -> FUIGeometryLayer {
        return mapModel.layerModel[index]
    }
}
