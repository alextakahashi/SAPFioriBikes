//
//  Model.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 11/14/18.
//  Copyright © 2018 Takahashi, Alex. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import SAPFiori

struct StationInformationRequest: Decodable {
    let last_updated: CGFloat?
    let ttl: Int?
    let data: StationInformationData?
}

struct StationInformationData: Decodable {
    let stations: [StationInformation?]?
}

struct StationInformation: Decodable {
    let station_id: String?
    let external_id: String?
    let name: String?
    let short_name: String?
    let lat: CLLocationDegrees?
    let lon: CLLocationDegrees?
    let region_id: Int?
    let rental_methods: [String?]?
    let capacity: Int?
    let rental_url: String?
    let eightd_has_key_dispenser: Bool?
    let eightd_station_services: [StationInformationServices?]?
    let has_kiosk: Bool?
}

struct StationInformationServices: Decodable {
    let id: String?
    let service_type: String?
    let bikes_availability: String?
    let docks_availability: String?
    let name: String?
    let description: String?
    let schedule_description: String?
    let link_for_more_info: String?
}

struct StationStatusRequest: Decodable {
    let last_updated: CGFloat?
    let ttl: Int?
    let data: StationStatusData?
}

struct StationStatusData: Decodable {
    let stations: [StationStatus?]?
}

struct StationStatus: Decodable {
    let station_id: String?
    let num_bikes_available: Int?
    let num_ebikes_available: Int?
    let num_bikes_disabled: Int?
    let num_docks_available: Int?
    let num_docks_disabled: Int?
    let is_installed: Int?
    let is_renting: Int?
    let is_returning: Int?
    let last_reported: CGFloat?
    let eightd_has_available_keys: Bool?
    let eightd_active_station_services: [StationStatusServices?]?
}

struct StationStatusServices: Decodable {
    let id: String?
}

class SAPFioriBikeStation: NSObject, FUIAnnotation {
    var state: FUIMapFloorplan.State  = .default
    
    var layer: FUIGeometryLayer = FUIGeometryLayer(displayName: "idk")
    
    var indexPath: IndexPath = IndexPath()
    
    var information: StationInformation? = nil
    var status: StationStatus? = nil
    var coordinate: CLLocationCoordinate2D {
        get {
            guard let information = information, let lat = information.lat, let lon = information.lon else { return CLLocationCoordinate2D(latitude: 0, longitude: 0)}
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
    }
    var title: String? {
        get {
            guard let information = information else { return nil }
            return information.name
        }
    }
    
    var numBikes: Int {
        get {
            return status?.num_bikes_available ?? 0
        }
    }
    
    var numEBikes: Int {
        get {
            return status?.num_ebikes_available ?? 0
        }
    }
    
    var numDocsAvailable: Int {
        get {
            return status?.num_docks_available ?? 0
        }
    }
}

