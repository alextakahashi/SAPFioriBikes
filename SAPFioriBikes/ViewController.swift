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

class ViewController: FUIMKMapFloorplanViewController, MKMapViewDelegate, SearchResultsProducing, CLLocationManagerDelegate, FUIMKMapViewDelegate {

    var mapModel = FioriBikeMapModel()
    let isClusteringStations = true
    
    // MARK: SearchResultsControllerObject and ContentControllerObject
    var searchResultsObject: SearchResultsControllerObject!
    var isFiltered: Bool = false
    var stationModel: [BikeStationAnnotation] { return mapModel.stationModel }
    var filteredResults: [BikeStationAnnotation] = []
    var searchResultsTableView: UITableView? { return detailPanel.searchResults.tableView }
    var didSelectBikeStationSearchResult: ((BikeStationAnnotation) -> Void)!
    var contentObject: ContentControllerObject! {
        didSet {
            detailPanel.content.tableView.dataSource = contentObject
            detailPanel.content.tableView.reloadData()
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
        mapView.showsUserLocation = true
        locationManager = CLLocationManager() //¹
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        // MARK: FUIMKMapViewDataSource
        self.dataSource = self
        self.delegate = self

        // MARK: FUIMapLegend
        legend.headerTextView.text = mapModel.legendTitle
        legend.items = mapModel.legendModel
        
        // MARK: Search Results
        searchResultsObject = SearchResultsControllerObject(self)
        didSelectBikeStationSearchResult = { [unowned self] station in
            self.pushContent(station)
        }
        detailPanel.searchResults.tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier: FUIObjectTableViewCell.reuseIdentifier)
        detailPanel.searchResults.tableView.dataSource = searchResultsObject
        detailPanel.searchResults.tableView.delegate = searchResultsObject
        detailPanel.searchResults.searchBar.delegate = searchResultsObject
        detailPanel.content.tableView.register(FUIMapDetailTagObjectTableViewCell.self, forCellReuseIdentifier: FUIMapDetailTagObjectTableViewCell.reuseIdentifier)
        detailPanel.content.tableView.register(FUIMapDetailPanel.ButtonTableViewCell.self, forCellReuseIdentifier: FUIMapDetailPanel.ButtonTableViewCell.reuseIdentifier)
    }
    
    internal func pushContent(_ bikeStationAnnotation: BikeStationAnnotation) {
        let region = MKCoordinateRegion(center: bikeStationAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
        mapView.setRegion(region, animated: true)
        contentObject = ContentControllerObject(bikeStationAnnotation)
        detailPanel.content.headlineText = contentObject.headlineText
        detailPanel.content.subheadlineText = contentObject.subheadlineText
        detailPanel.pushChildViewController()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let bikeStationAnnotation = view.annotation as? BikeStationAnnotation else { return }
        pushContent(bikeStationAnnotation)
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
    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        print("✅ \(#function)")
//        guard let fuiOverlay = overlay as? FUIOverlay else {
//            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
//            polylineRenderer.strokeColor = UIColor.red.withAlphaComponent(0.5)
//            polylineRenderer.lineWidth = 5
//            return polylineRenderer
//        }
//        if let lineOverlay = overlay as? MKPolyline {
//            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
//            return polylineRenderer
//        }
//        return MKPolylineRenderer()
//    }
    
    var counter = 0
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        defer {
            counter += 1
        }
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.red.withAlphaComponent(0.5)
        polylineRenderer.lineWidth = 5
        guard let bartOverlay = overlay as? BartLineOverlay else { return polylineRenderer }
        var color: UIColor = UIColor.brown.withAlphaComponent(0.5)
        switch counter {
        case 0:
            color = UIColor.purple.withAlphaComponent(0.5)
        case 1:
            color = UIColor.green.withAlphaComponent(0.5)
        case 2:
            color = UIColor.yellow.withAlphaComponent(0.5)
        case 3:
            color = UIColor.orange.withAlphaComponent(0.5)
        case 4:
            color = UIColor.cyan.withAlphaComponent(0.5)
        default:
            break
        }
        polylineRenderer.strokeColor = color
        return polylineRenderer
    }
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation? {
        didSet {
            mapModel.userLocation = currentLocation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { // ¹
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
    
    override func reloadData() {
        super.reloadData()
        print("🎉 number of overlays: \(mapView.overlays.count)")
    }
}

// MARK: FUIMKMapViewDataSource

extension ViewController: FUIMKMapViewDataSource {
    
    func mapView(_ mapView: MKMapView, geometriesForLayer layer: FUIGeometryLayer) -> [FUIAnnotation] {
        switch layer.displayName {
        case "Bikes":
            return mapModel.stationModel
        case "Bart Line":
            return mapModel.bartLineModel
        default:
            preconditionFailure()
        }
    }
    
    func numberOfLayers(in mapView: MKMapView) -> Int {
        return mapModel.layerModel.count
    }
    
    func mapView(_ mapView: MKMapView, layerAtIndex index: Int) -> FUIGeometryLayer {
        return mapModel.layerModel[index]
    }
}

// ¹: https://stackoverflow.com/questions/25449469/show-current-location-and-update-location-in-mkmapview-in-swift

//public extension MKMultiPoint {
//    var coordinates: [CLLocationCoordinate2D] {
//        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid,
//                                              count: pointCount)
//
//        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
//
//        return coords
//    }
//}
