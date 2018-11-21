//
//  StationStatusRequest.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 11/20/18.
//  Copyright © 2018 Takahashi, Alex. All rights reserved.
//

import UIKit
import MapKit

protocol StationIDProducing {
    var station_id: String? { get }
}

struct StationStatusRequest: Decodable {
    let last_updated: CGFloat?
    let ttl: Int?
    let data: StationStatusData?
}

struct StationStatusData: Decodable {
    let stations: [StationStatus?]?
}

struct StationStatus: Decodable, StationIDProducing {
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
