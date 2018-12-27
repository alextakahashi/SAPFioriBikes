//
//  SearchResults.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 12/27/18.
//  Copyright © 2018 Takahashi, Alex. All rights reserved.
//

import UIKit
import SAPFiori
import CoreLocation
import MapKit

protocol SearchResultsProducing: class {
    var isFiltered: Bool { get set }
    var stationModel: [BikeStationAnnotation] { get }
    var filteredResults: [BikeStationAnnotation] { get set }
    var tableView: UITableView? { get }
}

class SearchResults: NSObject {
    
    weak var model: SearchResultsProducing!
    
    init(_ model: SearchResultsProducing) {
        self.model = model
    }
    
    internal var searchResults: [BikeStationAnnotation] {
        get {
            return model.isFiltered ? model.filteredResults : model.stationModel
        }
    }
    
}

extension SearchResults: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FUIObjectTableViewCell.reuseIdentifier) as? FUIObjectTableViewCell else { return UITableViewCell() }
        let bikeStation = searchResults[indexPath.row]
        cell.detailImage = FUIIconLibrary.map.marker.asset
        cell.headlineText = bikeStation.title
        cell.subheadlineText = bikeStation.distanceToUserString//distance
        cell.descriptionText = "Description"
        cell.statusText = "Status"
        cell.substatusText = "Substatus"
        cell.statusImage = FUIIconLibrary.map.marker.bus
        cell.substatusImage = FUIIconLibrary.map.marker.cafe
        return cell
    }
    
    
}

extension SearchResults: UISearchBarDelegate {
    
    /// :nodoc:
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsBookmarkButton = false
        searchBar.showsCancelButton = true
    }
    
    /// :nodoc:
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async { [unowned self] in
            searchBar.showsCancelButton = false
            self.model.isFiltered = false
            searchBar.endEditing(true)
        }
    }
    
    /// :nodoc:
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchString = searchText
        self.model.isFiltered = !searchString.isEmpty
        self.model.filteredResults = self.model.stationModel.filter({
            guard let title = $0.title else { return false }
            return title.localizedCaseInsensitiveContains(searchString)
        })
        self.model.tableView?.reloadData()
    }
    
}
