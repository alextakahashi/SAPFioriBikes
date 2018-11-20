//
//  MapModel.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 11/20/18.
//  Copyright © 2018 Takahashi, Alex. All rights reserved.
//

import MapKit
import SAPFiori

struct MapModel {
    var title: String
    var centerCoordinate: CLLocationCoordinate2D
    var centerCoordinateRegion: MKCoordinateRegion
    var mapType: MKMapType
    var legendModel: [FUIMapLegendItem]
    var stationModel: [SAPFioriBikeStation]
    var layerModel: [FUIGeometryLayer]
    init(_ title: String, _ centerCoordinate: CLLocationCoordinate2D, _ centerCoordinateRegion: MKCoordinateRegion, _ mapType: MKMapType, _ legendModel: [FUIMapLegendItem], _ stationModel: [SAPFioriBikeStation], _ layerModel: [FUIGeometryLayer]) {
        self.title = title
        self.centerCoordinate = centerCoordinate
        self.centerCoordinateRegion = centerCoordinateRegion
        self.mapType = mapType
        self.legendModel = legendModel
        self.stationModel = stationModel
        self.layerModel = layerModel
    }
}
