# SAPFioriBikes: Visualization of GoBike Stations with the SAP Fiori iOS SDK

![SAPFioriBikes iPhone](./ReadMeImages/No_Legend_iPhone.png?raw=true)

[//]: # (Needs a public github link)
> An implementation of the Ford GoBike map using the SAP Fiori iOS SDK.  Check out the code [HERE](https://github.wdf.sap.corp/i860364/SAPFioriBikes)

# Inspiration

If you are a Bay Area resident, you are sure to have come across the [Ford GoBike](https://www.fordgobike.com/) Stations.  Members of the service can pick up a bike and ride to any other station to redock.  This service provides a cheaper alternative to driving a car or using ride-share/carpooling and can be more convenient than waiting for public transit BART or Metro.  On top of that, since bikes must be docked, our streets are cleaner and more accessible rather than an obstacle course with scattered bikes and scooters ([Lime and Bike pushed out of SF](https://www.sfchronicle.com/business/article/Shut-out-of-San-Francisco-Lime-and-Bird-look-13242319.php)).  Especially with the [BART Transbay Tube Retrofit](https://www.bart.gov/about/projects/eqs/retrofit) starting February 2019, commuters are going to need as many options to get from one place to the other!

Looking at the Ford GoBike map, I noticed that it was cluttered with stations.  

![Ford GoBike Map Cluttered Station](./ReadMeImages/Ford_Bikes_Unclustered.jpg?raw=true)

Thankfully during WWDC 2017, MapKit introduced the [`MKClusterAnnotation`](https://developer.apple.com/documentation/mapkit/mkclusterannotation) which will consolidate annotations together.

The [TANDm](https://developer.apple.com/documentation/mapkit/mkannotationview/decluttering_a_map_with_mapkit_annotation_clustering) app showed clusters of annotations (bicycle, tricycle, and unicycle) annotations that translated nicely to the Ford GoBike bikes and eBikes.

![TANDm Cluster Annotation Screen shot](./ReadMeImages/Tandm.png?raw=true)

I used features from the [SAP Fiori iOS SDK](https://developer.apple.com/sap/) [Map Floorplan](https://experience.sap.com/fiori-design-ios/article/map/), to provide the foundation of my application.  I make use of the `FUIMapToolbar` and `FUIMapLegend` to display annotations and what they mean.

# Implementation

[//]: # (Needs a public github link)
Follow along using the code [HERE](https://github.wdf.sap.corp/i860364/SAPFioriBikes).  

## Map View Controller

```swift
class ViewController: FUIMKMapFloorplanViewController, MKMapViewDelegate {

    override func viewDidLoad() { ... }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? { ... }
}
```

Subclassing the `FUIMKMapFloorplanViewController` gives the `MKMapView`, `FUIMapToolbar` (Vertical stack on the right), and `FUIMapDetailPanel` (Bottom panel) for free.  We implement the `MKMapViewDelegate` to show the custom `BikeStationAnnotationView`.  Nothing should look out of the ordinary until we reach the `FUIMKMapViewDataSource` and `FUIMapLegend` implementations.

## Layers & Geometries

Annotations in the `FUIMKMapFloorplanViewController` are shown in the map as geometries (`FUIAnnotation`) in geometry layers (`FUIGeometryLayer`).  Geometries include `MKAnnotation`s, `MKPolyline`s, and `MKPolygon`s. Organizing geometries by layer is convenient way to filter and organize data.

For the purpose of this example, we work with a simple model with a single layer.  We set the delegate in `viewDidLoad()` by setting

```swift
self.dataSource = self
```

and extend the `ViewController` by implementing the `FUIMKMapViewDataSource`.  

```swift
extension ViewController: FUIMKMapViewDataSource {

    func mapView(_ mapView: MKMapView, geometriesForLayer layer: FUIGeometryLayer) -> [FUIAnnotation] {
        return mapModel.stationModel
    }

    func numberOfLayers(in mapView: MKMapView) -> Int {
        return mapModel.layerModel.count
    }

    func mapView(_ mapView: MKMapView, layerAtIndex index: Int) -> FUIGeometryLayer {
        return mapModel.layerModel[index]
    }
}
```

## Map Model

The `FioriBikeMapModel` owns map business objects used in the `ViewController`.  The standard map business objects `title`, `region`, and `mapType` are set at the top.  In the `layerModel` there is a single layer, the `"Bikes"` layer.  The `stationModel` will contain all Ford GoBike Stations after it is populated by calling `loadData()`.  Optionally we can query real time data by setting the `isLiveData` to true within the function.  Private functions are located at the bottom, but the most important part is the call to the delegate at the very end.

```swift
self.delegate?.reloadData()
```

This function call reloads the geometries and layers on the map.  At this point all the station information is loaded.

## BikeStationAnnotation

A `BikeStationAnnotation`s are constructed while loading the `stationModel`.  Use in the `FUIMKMapFloorplanViewController` requires the annotation implement the `FUIAnnotation` protocol which requires a `state`, `layer`, and `indexPath`.  For simplicity's sake, we set them to a few default values.  We also store information we want to display on the map including the `coordinate`, `title`, `numBikes`, `numEBikes`, and `numDocsAvailable`.

## BikeStationAnnotationView

![Annotation Image](./ReadMeImages/Bike_Annotation_View.png?raw=true)

The `BikeStationAnnotationView` takes inspiration from TANDm with their cluster annotation.  With a few minor changes to the original source code, I am able to display the number of bikes and eBikes at each station.  Tap the legend button to show the meaning of each color.  

![Clustered Annotations](./ReadMeImages/Zoom_Extent_Cluster.png?raw=true)

Optionally, we can also get the total number of bikes and eBikes from all the clusters under this view by getting the `memberAnnotations`.  Tap the [Zoom Extent Button](https://help.sap.com/doc/978e4f6c968c4cc5a30f9d324aa4b1d7/3.0/en-US/Documents/Frameworks/SAPFiori/Classes/FUIMapToolbar/ZoomExtentButton.html) to show all the annotations in the map.  Looks like there are not any eBikes outside of San Francisco!  

## iPad Support

The floorplan also supports an iPad layout.

![No Legend iPad](./ReadMeImages/No_Legend_iPad.png?raw=true)

![Show_Legend_iPad](./ReadMeImages/Show_Legend_iPad.png?raw=true)

## Next Steps

This project implements a few features of the Map Floorplan including:
* Adding map annotations and cluster annotations
* Zooming to show all annotations
* Implementing the map legend

In a future post I will extend this project to implement:
* [Search Results View Controller](https://help.sap.com/doc/978e4f6c968c4cc5a30f9d324aa4b1d7/3.0/en-US/Documents/Frameworks/SAPFiori/Classes/FUIMapDetailPanelSearchResultsViewController.html) to filter annotations
* [Content View Controller](https://help.sap.com/doc/978e4f6c968c4cc5a30f9d324aa4b1d7/3.0/en-US/Documents/Frameworks/SAPFiori/Classes/FUIMapDetailPanelContentViewController.html) to show additional details of an annotation

## Conclusion

Maps at first glance can feel quite overwhelming! Maps can display an overwhelming amount of information and it is important to keep the user focus on the most relevant information.  The Map Floorplan provides the foundation for a robust map with a minimal amount of code on the developer's end.  
