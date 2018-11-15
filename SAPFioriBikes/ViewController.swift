//
//  ViewController.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 11/14/18.
//  Copyright © 2018 Takahashi, Alex. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var stationInformationModel: [StationInformation] = []
    var stationStatusModel: [StationStatus] = []
    var stationDictionary: [String: SAPFioriBikeStation] = [:]
    var mapView: MKMapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                print(strongSelf.stationDictionary)
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
                print(strongSelf.stationDictionary)
            } catch let jsonError {
                print("❌ \(jsonError)")
            }
        }.resume()
        
        mapView.delegate = self
        self.view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
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
        mapView.addAnnotation(cachedFioriStation)
        print("💥 added: \(cachedFioriStation.coordinate)")
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
        mapView.addAnnotation(cachedFioriStation)
        print("💥 added: \(cachedFioriStation.coordinate)")
    }
}

extension ViewController: MKMapViewDelegate {
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        return MKAnnotationView(annotation: annotation, reuseIdentifier: "abc")
//    }
    
//    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
//        for view in views {
//            print("🍏 \(view.annotation?.coordinate)")
//        }
//    }
    
}
