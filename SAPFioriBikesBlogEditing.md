# SAPFioriBikes: Drawing Geospatial Items

> Extending the SAPFioriBikes project by adding custom polylines and polygons. Check out the code [HERE](https://github.wdf.sap.corp/i860364/SAPFioriBikes)

This project follows up with the original [SAPFioriBikes Blog Series](https://github.wdf.sap.corp/i860364/SAPFioriBikes/blob/master/SAPFioriBikesBlog.md) by drawing custom points, polylines, and polygons on the map.

## Drawing on the map

Drawing on the map allows users to document locations without the technical knowledge of adding them in code.  In this project, I draw polygons for walk zones and bike paths around the UC Berkeley campus using the floorplan's editing feature.  Currently drawing on the map is only supported on the iPad.

Although the SDK is designed for the enterprise use case such as a field worker monitoring an oil pipeline, this feature can be applied to the bikes example as well.  Around the UC Berkeley campus, riding bikes are one of the main ways of commuting to and from class.  Due to high foot traffic, some locations on campus are designated walk zones for pedestrian safety.  The area between Sproul Hall and the Student Union as a central point in campus are where many students eat, socialize, and study.



This app is most useful when you can easily find the closest station.  Getting the device location allows us to sort and show the distance between the user and each station. Showing the user's location on an MKMapView is well documented online.  Once the user location is displayed, we can use the [FUIMapToolbar.UserLocationButton](https://help.sap.com/doc/978e4f6c968c4cc5a30f9d324aa4b1d7/3.0/en-US/Documents/Frameworks/SAPFiori/Classes/FUIMapToolbar/UserLocationButton.html) to zoom and center on the annotation.  Conveniently, the user location button is already built in to the floorplan toolbar.

![User Location](ReadMeImages/UserLocation.png)

## Detail Panel Functionality

The [FUIMapDetailPanel](https://help.sap.com/doc/978e4f6c968c4cc5a30f9d324aa4b1d7/3.0/en-US/Documents/Frameworks/SAPFiori/Classes/FUIMapDetailPanel.html) is a controller similar to Apple Map's panel.

![Apple Maps](ReadMeImages/AppleMaps.png)

Our custom panel maintains the functionalities of Apple's panel allowing for displaying a minimum, intermediate, and maximum state.

![Panel Minimum State](ReadMeImages/Panel_Min.png)

![Panel Intermediate State](ReadMeImages/Panel_Intermediate.png)

![Panel Maximum State](ReadMeImages/Panel_Max.png)

Additionally, the internal tableView of the panels allow for scrolling of its content.

![Panel Scroll](ReadMeImages/Panel_Scroll.png)

The panel can show additional details by calling the `detailPanel.pushChildViewController()` method.  See `pushContent(_ : BikeStationAnnotation)` for an example implementation.

## Configuring the Search Results View Controller

If the user cannot conveniently see the closest station, he can also swipe up on the panel to display the stations sorted by distance.

![Search Results View Controller](ReadMeImages/SearchResults.png)

Configuration is done during `viewDidLoad`

```swift
detailPanel.searchResults.tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier: FUIObjectTableViewCell.reuseIdentifier)
detailPanel.searchResults.tableView.dataSource = searchResultsObject
detailPanel.searchResults.tableView.delegate = searchResultsObject
detailPanel.searchResults.searchBar.delegate = searchResultsObject
```
The developer adds their own implementation for the `tableView` and `searchBar`by implementing the `UITableViewDataSource`, `UITableViewDelegate`, and `UISearchBarDelegate`.  See the `SearchResultsControllerObject` for the implementation.  In this example, the stations are sorted by distance away from the user.  The bicycle and lightning icons show if there are bikes or EBikes at the designated station based off of the color.

Now with the searchbar, it is possible to search for all the stations near BART!

![Detail Panel Search Results Bart](ReadMeImages/DetailPanel_SearchBart.png)

## Configuring the Content View Controller

![Content View Controller](ReadMeImages/ContentViewController.png)

Similar to the Search Results, the Content View Controller is setup in `viewDidLoad`

```swift
detailPanel.content.tableView.dataSource = contentObject
detailPanel.content.headlineText = contentObject.headlineText
detailPanel.content.subheadlineText = contentObject.subheadlineText
```

Again, the developer is responsible for their own implementation of the `tableView`'s `UITableViewDataSource` and `UITableViewDelegate`.  Additionally, the Content View Controller has a `headlineText` and `subheadlineText` as the header of the tableView.  See the `ContentControllerObject` for the implementation.  More details are shown by showing tags with the number of bikes, EBikes, and docs available.  There is an additional button to launch the Ford GoBike App to reserve at this station.

![Rent a Bike](ReadMeImages/Download_FordGoBike.png)

To dismiss the content view controller, the user can tap the close button in the top right corner of the panel.

## iPad Support

The Detail Panel has similar functionality on the iPad, but takes advantage of extra screen realestate.

![Detail Panel iPad Search Results](ReadMeImages/DetailPanel_iPad.png)

![Detail Panel iPad Content View Controller](ReadMeImages/DetailPanel_iPadContent.png)

## Next Steps

In a future post I will extend this project to show other GeoSpatial objects including [`FUIPolyline`](https://help.sap.com/doc/978e4f6c968c4cc5a30f9d324aa4b1d7/3.0/en-US/Documents/Frameworks/SAPFiori/Map%20view.html#/s:8SAPFiori11FUIPolylineP) and [`FUIPolygon`](https://help.sap.com/doc/978e4f6c968c4cc5a30f9d324aa4b1d7/3.0/en-US/Documents/Frameworks/SAPFiori/Map%20view.html#/s:8SAPFiori10FUIPolygonP).

## Conclusion

The FUIMapDetailPanel provides a convenient way to search for stations and display additional details directly on top of the mapView similar to Apple Maps.  Developers simply need to set their own `UITableViewDataSource`, `UITableViewDelegate`, and `UISearchBarDelegate` to add their own custom implementation.  Despite the smaller screen sizes on the iPhone compared to the iPad, the DetailPanel can show scrollable content as needed.
