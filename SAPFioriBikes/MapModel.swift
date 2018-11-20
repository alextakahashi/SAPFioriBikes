//
//  MapModel.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 11/20/18.
//  Copyright © 2018 Takahashi, Alex. All rights reserved.
//

import MapKit
import SAPFiori

protocol StationModelConsuming {
    var stationMap: MKMapView { get }
}

class FioriBikeMapModel {
    
    struct MapModel {
        var title: String
        var region: MKCoordinateRegion
        var mapType: MKMapType
        var legendModel: [FUIMapLegendItem]
        var stationModel: [SAPFioriBikeStation]
        var layerModel: [FUIGeometryLayer]
        init(title modelTitle: String, region modelRegion: MKCoordinateRegion, mapType modelType: MKMapType, legendModel modelLegendModel: [FUIMapLegendItem], stationModel modelStationModel: [SAPFioriBikeStation], layerModel modelLayerModel: [FUIGeometryLayer]) {
            self.title = modelTitle
            self.region = modelRegion
            self.mapType = modelType
            self.legendModel = modelLegendModel
            self.stationModel = modelStationModel
            self.layerModel = modelLayerModel
        }
    }
    
    weak var delegate: ViewController? = nil
    
//    let model = MapModel(title: "Ford GoBike Map",
//                         region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)),
//                         mapType: .mutedStandard,
//                         legendModel: <#T##[FUIMapLegendItem]#>,
//                         stationModel: <#T##[SAPFioriBikeStation]#>,
//                         layerModel: <#T##[FUIGeometryLayer]#>)
    
    func requestData(isLiveData: Bool = false, completion: ([FUIAnnotation]) -> Void) {
//        completion(stationmo)
    }
    
    var stationInformationModel: [StationInformation] = []
    var stationStatusModel: [StationStatus] = []
    var stationDictionary: [String: SAPFioriBikeStation] = [:]
    var layerModel = [FUIGeometryLayer(displayName: "Bikes")]
    
    internal func loadInitialData() {
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
                self?.delegate?.reloadData()
            } catch let jsonError {
                print("❌ \(jsonError)")
            }
            }.resume()
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
    
    internal func merge<T: StationIDProducing>(_ stationDataObject: T) {
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
    
    internal func stationIDDataBind<T: StationIDProducing>(_ stationObject: SAPFioriBikeStation, _ stationDataObject: T) {
        if let status = stationDataObject as? StationStatus {
            stationObject.status = status
        } else if let information = stationDataObject as? StationInformation {
            stationObject.information = information
        }
    }
}
