//
//  Model.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 11/14/18.
//  Copyright © 2018 Takahashi, Alex. All rights reserved.
//

import Foundation
import UIKit

struct APIRequest: Decodable {
    let last_updated: CGFloat?
    let ttl: Int?
    let data: Data?
}

struct Data: Decodable {
    let stations: [Station?]?
}

struct Station: Decodable {
    let station_id: String?
    let external_id: String?
    let name: String?
    let short_name: String?
    let lat: CGFloat?
    let lon: CGFloat?
    let region_id: Int?
    let rental_methods: [String?]?
    let capacity: Int?
    let rental_url: String?
    let eightd_has_key_dispenser: Bool?
    let eightd_station_services: [StationServices?]?
    let has_kiosk: Bool?
}

struct StationServices: Decodable {
    let id: String?
    let service_type: String?
    let bikes_availability: String?
    let docks_availability: String?
    let name: String?
    let description: String?
    let schedule_description: String?
    let link_for_more_info: String?
}
