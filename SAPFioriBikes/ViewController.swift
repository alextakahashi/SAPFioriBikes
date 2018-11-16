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

class ViewController: FUIMKMapFloorplanViewController, MKMapViewDelegate {
    
    var stationInformationModel: [StationInformation] = []
    var stationStatusModel: [StationStatus] = []
    var stationDictionary: [String: SAPFioriBikeStation] = [:]
    var layerModel = [FUIGeometryLayer(displayName: "Bikes")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.dataSource = self
        self.delegate = self
        mapView.mapType = .mutedStandard
        mapView.register(FUIMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "FUIMarkerAnnotationView")
        mapView.register(BikeClusterAnnotation.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
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
    
    var dummyAnnotation = MKPointAnnotation()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let centerCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
        dummyAnnotation.coordinate = centerCoordinate
        mapView.addAnnotation(dummyAnnotation)
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
        guard !(annotation is MKClusterAnnotation) else { return nil }
        if let _ = annotation as? MKUserLocation { return nil }
        guard let fuiannotation = annotation as? SAPFioriBikeStation else { return nil }
        if stationDictionary.contains(where: { return $0.value == fuiannotation }) {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation) as! BikeClusterAnnotation
//            view.markerTintColor = fuiannotation.state == .default ? UIColor.preferredFioriColor(forStyle: .map1) : UIColor.preferredFioriColor(forStyle: .map2)
//            view.glyphImage = FUIIconLibrary.map.marker.bus
            view.clusteringIdentifier = "com.sap.fui.clusterannotationview"
            view.canShowCallout = true
            view.isEnabled = true
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, willRender clusterAnnotationView: MKAnnotationView, for geometryIndexesInLayers: [FUIGeometryLayer : [Int]], in state: FUIMapFloorplan.State) {
        guard let markerAnnotationView = clusterAnnotationView as? MKMarkerAnnotationView else { return }
        if state == .default, geometryIndexesInLayers.count == 1, let layer = geometryIndexesInLayers.first?.key {
            markerAnnotationView.markerTintColor = UIColor(hexString: "0092D9")//UIColor.preferredFioriColor(forStyle: .map3)
            markerAnnotationView.displayPriority = .defaultHigh
        }
    }
}

extension ViewController: FUIMKMapViewDataSource {
    func mapView(_ mapView: MKMapView, geometriesForLayer layer: FUIGeometryLayer) -> [FUIAnnotation] {
        print(stationDictionary.count)
        return stationDictionary.map({ (key, value) in
            return value
        })
    }
    
    
    // MARK: FUIMKMapViewDataSource
    
    func numberOfLayers(in mapView: MKMapView) -> Int {
        return layerModel.count
    }
    
    func mapView(_ mapView: MKMapView, layerAtIndex index: Int) -> FUIGeometryLayer {
        return layerModel[index]
    }
    
    func mapView(_ mapView: MKMapView, geometriesForLayer layer: FUIGeometryLayer) -> [MKAnnotation] {
        print(stationDictionary.count)
        return stationDictionary.map({ (key, value) in
            return value
        })
    }
}

extension ViewController: FUIMKMapViewDelegate {
    

    
}
