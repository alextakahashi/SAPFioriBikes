//
//  MapModel.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 11/20/18.
//  Copyright © 2018 Takahashi, Alex. All rights reserved.
//

import MapKit
import SAPFiori

class FioriBikeMapModel {
    
    weak var delegate: ViewController? = nil
    
    let title: String = "Ford GoBike Map"
    
    let region: MKCoordinateRegion = {
        let center = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        return MKCoordinateRegion(center: center, span: span)
    }()
    
    let mapType: MKMapType = .mutedStandard
    
    var stationModel: [SAPFioriBikeStation] = []
    
    let layerModel: [FUIGeometryLayer] = [FUIGeometryLayer(displayName: "Bikes")]
    
    var legendTitle: String {
        return title + " Legend"
    }
    
    let legendModel: [FUIMapLegendItem] = {
        let bikeLegendItem: FUIMapLegendItem = {
            var bikeItem = FUIMapLegendItem(title: "Bike")
            bikeItem.backgroundColor = Colors.green
            bikeItem.icon = FUIMapLegendIcon(glyphImage: "")
            return bikeItem
        }()
        
        let eBikeLegendItem: FUIMapLegendItem = {
            var eBikeItem = FUIMapLegendItem(title: "EBike")
            eBikeItem.backgroundColor = Colors.darkBlue
            eBikeItem.icon = FUIMapLegendIcon(glyphImage: "")
            return eBikeItem
        }()
        
        let stationItem: FUIMapLegendItem = {
            var stationItem = FUIMapLegendItem(title: "Station")
            stationItem.backgroundColor = Colors.lightBlue
            stationItem.icon = FUIMapLegendIcon(glyphImage: "")
            return stationItem
        }()
        
        let emptyStationItem: FUIMapLegendItem = {
            var emptyStation = FUIMapLegendItem(title: "Empty Station")
            emptyStation.backgroundColor = Colors.red
            emptyStation.icon = FUIMapLegendIcon(glyphImage: "")
            return emptyStation
        }()
        return [bikeLegendItem, eBikeLegendItem, stationItem, emptyStationItem]
    }()
    
    func loadData(isLiveData: Bool = false) {
        isLiveData ? loadLiveData() : loadLocalData()
    }
    
    // MARK: Private Functions
    
    private var stationInformationModel: [StationInformation] = []
    private var stationStatusModel: [StationStatus] = []
    private var stationDictionary: [String: SAPFioriBikeStation] = [:]
    
    private func loadLocalData() {
        if let path = Bundle.main.path(forResource: "station_information", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let request = try JSONDecoder().decode(StationInformationRequest.self, from: data)
                guard let stations = request.data?.stations else { return }
                self.stationInformationModel = stations.compactMap({return $0})
                for station in self.stationInformationModel {
                    self.merge(station)
                }
                self.stationModel = self.stationDictionary.map({ return $0.value })
                self.delegate?.reloadData()

            } catch let jsonError {
                print("❌ \(jsonError)")
            }
        }
        if let path = Bundle.main.path(forResource: "station_status", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let request = try JSONDecoder().decode(StationStatusRequest.self, from: data)
                guard let stations = request.data?.stations else { return }
                self.stationStatusModel = stations.compactMap({return $0})
                for station in self.stationStatusModel {
                    self.merge(station)
                }
                self.stationModel = self.stationDictionary.map({ return $0.value })
                for station in stationModel {
                    print("🔥 numBikes: \(station.numBikes)")
                }
                self.delegate?.reloadData()
            } catch let jsonError {
                print("❌ \(jsonError)")
            }
        }
    }
    
    private func loadLiveData() {
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
                strongSelf.stationModel = strongSelf.stationDictionary.map({ return $0.value })
                self?.delegate?.reloadData()
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
                strongSelf.stationModel = strongSelf.stationDictionary.map({ return $0.value })
                self?.delegate?.reloadData()
            } catch let jsonError {
                print("❌ \(jsonError)")
            }
            }.resume()
    }
    
    private func merge<T: StationIDProducing>(_ stationDataObject: T) {
        guard let stationID = stationDataObject.station_id else { return }
        guard stationDictionary.contains(where: { return $0.key == stationID }) else {
            let newFioriStation = SAPFioriBikeStation()
            stationIDDataBind(newFioriStation, stationDataObject)
            stationDictionary[stationID] = newFioriStation
            return
        }
        guard let cachedFioriStation = stationDictionary[stationID] else { return }
        stationIDDataBind(cachedFioriStation, stationDataObject)
    }
    
    private func stationIDDataBind<T: StationIDProducing>(_ stationObject: SAPFioriBikeStation, _ stationDataObject: T) {
        if let status = stationDataObject as? StationStatus {
            stationObject.status = status
        } else if let information = stationDataObject as? StationInformation {
            stationObject.information = information
        }
    }
}
