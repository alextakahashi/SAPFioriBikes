//
//  BartRequest.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 12/28/18.
//  Copyright © 2018 Takahashi, Alex. All rights reserved.
//

import Foundation
import MapKit

struct BartPolylineRequest: Decodable {
    let type: String
    let features: [FeaturesPolylineData]
}

struct FeaturesPolylineData: Decodable {
    let type: String
    let properties: PropertiesPolylineData
    let geometry: GeometryPolylineData
}

struct PropertiesPolylineData: Decodable {
    let name: String
    let color: String?
}

struct GeometryPolylineData: Decodable {
    let type: String
    let coordinates: [[[Double]]]
}
