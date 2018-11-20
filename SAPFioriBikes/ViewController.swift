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

enum Colors {
    static let lightBlue = UIColor(hexString: "0092D9")
    static let green = UIColor(hexString: "80B030")
    static let red = UIColor(hexString: "D94700")
    static let darkBlue = UIColor(hexString: "002E6D")
}

class ViewController: FUIMKMapFloorplanViewController, MKMapViewDelegate {
    
    var stationInformationModel: [StationInformation] = []
    var stationStatusModel: [StationStatus] = []
    var stationDictionary: [String: SAPFioriBikeStation] = [:]
    var layerModel = [FUIGeometryLayer(displayName: "Bikes")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ford GoBike Map"
        legend.headerTextView.text = "Ford GoBike Map Legend"
        var bikeItem = FUIMapLegendItem(title: "Bike")
        bikeItem.backgroundColor = Colors.green
        bikeItem.icon = FUIMapLegendIcon(glyphImage: "")
        var eBikeItem = FUIMapLegendItem(title: "EBike")
        eBikeItem.backgroundColor = Colors.darkBlue
        eBikeItem.icon = FUIMapLegendIcon(glyphImage: "")
        var stationItem = FUIMapLegendItem(title: "Station")
        stationItem.backgroundColor = Colors.lightBlue
        stationItem.icon = FUIMapLegendIcon(glyphImage: "")
        var emptyStation = FUIMapLegendItem(title: "Empty Station")
        emptyStation.backgroundColor = Colors.red
        emptyStation.icon = FUIMapLegendIcon(glyphImage: "")
        legend.items = [bikeItem, eBikeItem, stationItem, emptyStation]
        mapView.delegate = self
        self.dataSource = self
        mapView.mapType = .mutedStandard
        mapView.register(FUIMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "FUIMarkerAnnotationView")
        mapView.register(BikeStationAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
//        mapView.register(BikeStationAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        detailPanel.isSearchEnabled = false
        
        guard let stationInformationURL: URL = URL(string: "https://gbfs.fordgobike.com/gbfs/en/station_information.json")else { return }
        URLSession.shared.dataTask(with: stationInformationURL) { [weak self] (data, response, err) in
            guard let data = data else { return }
            do {
                guard let strongSelf = self else { return }
                let request = try JSONDecoder().decode(StationInformationRequest.self, from: data)
                guard let stations = request.data?.stations else { return }
                strongSelf.stationInformationModel = stations.compactMap({return $0})
                for station in strongSelf.stationInformationModel {
                    strongSelf.merge(station)
                }
//                print(strongSelf.stationDictionary)
                self?.reloadData()
            } catch let jsonError {
                print("❌ \(jsonError)")
            }
        }.resume()
        
        guard let stationStatusURL: URL = URL(string: "https://gbfs.fordgobike.com/gbfs/en/station_status.json")else { return }
        URLSession.shared.dataTask(with: stationStatusURL) { [weak self] (data, response, err) in
            guard let data = data else { return }
            do {
                guard let strongSelf = self else { return }
                let request = try JSONDecoder().decode(StationStatusRequest.self, from: data)
                guard let stations = request.data?.stations else { return }
                strongSelf.stationStatusModel = stations.compactMap({return $0})
                for station in strongSelf.stationStatusModel {
                    strongSelf.merge(station)
                }
//                print(strongSelf.stationDictionary)
                self?.reloadData()
            } catch let jsonError {
                print("❌ \(jsonError)")
            }
        }.resume()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let centerCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    internal func merge(_ status: StationStatus) {
        guard let stationID = status.station_id else { return }
        guard stationDictionary.contains(where: { return $0.key == stationID }) else {
            let newFioriStation = SAPFioriBikeStation()
            newFioriStation.status = status
            stationDictionary[stationID] = newFioriStation
            return
        }
        guard let cachedFioriStation = stationDictionary[stationID] else { return }
        cachedFioriStation.status = status
    }
    
    internal func merge(_ information: StationInformation) {
        guard let stationID = information.station_id else { return }
        guard stationDictionary.contains(where: { return $0.key == stationID }) else {
            let newFioriStation = SAPFioriBikeStation()
            newFioriStation.information = information
            stationDictionary[stationID] = newFioriStation
            return
        }
        guard let cachedFioriStation = stationDictionary[stationID] else { return }
        cachedFioriStation.information = information
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKClusterAnnotation) else {
            let clusterAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView
            clusterAnnotationView?.displayPriority = .required
            clusterAnnotationView?.markerTintColor = Colors.lightBlue
            clusterAnnotationView?.titleVisibility = .hidden
            clusterAnnotationView?.subtitleVisibility = .hidden
            return clusterAnnotationView
        }
        if let _ = annotation as? MKUserLocation { return nil }
        guard let bikeStationAnnotation = annotation as? SAPFioriBikeStation else { return nil }
        if stationDictionary.contains(where: { return $0.value == bikeStationAnnotation }) {
            guard let bikeStationAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation) as? BikeStationAnnotationView else { return nil }
            bikeStationAnnotationView.clusteringIdentifier = "com.sap.fui.clusterannotationview"
            bikeStationAnnotationView.canShowCallout = true
            bikeStationAnnotationView.displayPriority = .defaultLow
            return bikeStationAnnotationView
        }
        return nil
    }
}

// MARK: FUIMKMapViewDataSource

extension ViewController: FUIMKMapViewDataSource {
    func mapView(_ mapView: MKMapView, geometriesForLayer layer: FUIGeometryLayer) -> [FUIAnnotation] {
        return stationDictionary.map({ (key, value) in
            return value
        })
    }
    
    func numberOfLayers(in mapView: MKMapView) -> Int {
        return layerModel.count
    }
    
    func mapView(_ mapView: MKMapView, layerAtIndex index: Int) -> FUIGeometryLayer {
        return layerModel[index]
    }
    
    func mapView(_ mapView: MKMapView, geometriesForLayer layer: FUIGeometryLayer) -> [MKAnnotation] {
        return stationDictionary.map({ (key, value) in
            return value
        })
    }
}

extension ViewController: FUIMKMapViewDelegate {
 
    func mapView(_ mapView: MKMapView, willRender clusterAnnotationView: MKAnnotationView, for geometryIndexesInLayers: [FUIGeometryLayer : [Int]], in state: FUIMapFloorplan.State) {
        print("👍")
        guard let markerAnnotationView = clusterAnnotationView as? MKMarkerAnnotationView else { return }
        print("change color pls")
        markerAnnotationView.markerTintColor = Colors.lightBlue
        markerAnnotationView.clusteringIdentifier = "com.sap.fui.clusterannotationview"
    }
    
}
