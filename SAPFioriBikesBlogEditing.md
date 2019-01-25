# SAPFioriBikes: Drawing Geospatial Items

![Drawing Geospatial Items](ReadMeImages/EditingGeospatialObjects/DrawingGeospatialItems.png)

![Swipe to Delete Memorial Glade Point](ReadMeImages/EditingGeospatialObjects/SwipeToDeleteMemorialGladPoint.png)

> Extending the SAPFioriBikes project by adding custom points, polylines, and polygons. Check out the code [HERE](https://github.wdf.sap.corp/i860364/SAPFioriBikes)

This project follows up with the original [SAPFioriBikes Blog Series](https://github.wdf.sap.corp/i860364/SAPFioriBikes/blob/master/SAPFioriBikesBlog.md) by drawing custom points, polylines, and polygons on the map.  Through this walkthrough we also go over actions including:
* Adding points
* Deleting points
* Editing points
* Branching polylines
* Changing basemaps
* Adding points with suggestions
* Undo/Redo Editing actions
* Reordering points with drag and drop
* Location Snapshot View

## Drawing on the map

Drawing on the map allows users to document locations without the technical knowledge of adding them in code.  In this project, I draw polygons for walk zones and bike paths around the UC Berkeley campus using the floorplan's editing feature.  Currently drawing on the map is only supported on the iPad.  Although the SDK is designed for the enterprise use case such as a field worker monitoring an oil pipeline, this feature can be applied to the bikes example as well.  

### Walk Zone Polygons

Around the UC Berkeley campus, riding bikes is one of the main ways of commuting to and from class.  Due to high foot traffic, some locations on campus are designated walk zones for pedestrian safety.  The area between Sproul Hall and the Student Union as a central point in campus are where many students eat, socialize, and study.

![Upper Sproul Image](ReadMeImages/EditingGeospatialObjects/UpperSproulImage.png)

First, let's turn off the `Bikes Layer` and `Bart Layer` in the settings.  This will help declutter the map while we draw.

![Remove Layers Gif](ReadMeImages/EditingGeospatialObjects/RemoveLayers.gif)

<!-- ![Turn off Bikes and Bart Layer](ReadMeImages/EditingGeospatialObjects/TurnOffBikesAndBartLayer.png)

![Without Bikes and Bart Layer](ReadMeImages/EditingGeospatialObjects/WithoutBikesAndBartLayer.png) -->

Tap the `+` button in the upper right corner to open the popover showing the items that can be created, `Walk Zone`, `Bike Path`, `Brewery`, and `Venue`.  Tap on the `Walk Zone` to begin creating this polygon.  

![Create Walk Zone Gif](ReadMeImages/EditingGeospatialObjects/CreateWalkZoneCropped.gif)

![Open Create Popover](ReadMeImages/EditingGeospatialObjects/OpenCreatePopover.png)



![Walk Zone Panel](ReadMeImages/EditingGeospatialObjects/WalkZonePanel.png)

The editing panel appears on the left.  We will mark the perimeter of our walk zone between Sproul Hall to the ASUC Union from East to West and Sather Gate to Bancroft Way North to South.  Tap on the map to start adding points.

![ASUC Student Union Point](ReadMeImages/EditingGeospatialObjects/ASUCStudentUnionPoint.png)

![Sather Gate East Point](ReadMeImages/EditingGeospatialObjects/SatherGateEastPoint.png)

![Sather Gate West Point](ReadMeImages/EditingGeospatialObjects/SatherGateWestPoint.png)

![Sproul Hall Point](ReadMeImages/EditingGeospatialObjects/SproulHallPoint.png)

It is difficult to see exactly what area we are drawing over because of the base map.  Change the base map in the panel to `Satellite`

![Base Map Selector - Satellite Selected](ReadMeImages/EditingGeospatialObjects/BaseMapSelectorSatelliteSelected.png)

![Satellite View](ReadMeImages/EditingGeospatialObjects/SatelliteView.png)

With the basemap change, we can change the `colorScheme` of the map to show lines that appear better on this background.

From the map we can see the high density of students around campus.  Let's extend the points points north from Sather Gate to University Drive.  Press and hold the point then begin dragging to reposition the coordinate to University Drive

![Drag East Point to University Drive](ReadMeImages/EditingGeospatialObjects/DragEastPointToUniversityDrive.png)

![Drag West Point to University Drive](ReadMeImages/EditingGeospatialObjects/DragWestPointToUniversityDrive.png)

Now that we are finished creating the Walk Zone, we tap the Save Button at the bottom of the panel to do additional post processing.  The tableView can be populated with custom fields provided by the developer.  In this example we show the `FUIMapSnapshotFormCell` which shows the added geometry in a `UITableViewCell`.

![SnapshotFormCell Image](ReadMeImages/EditingGeospatialObjects/SnapshotFormCellImage.png)

Tap save in the right corner and the polygon will be saved to the map.

![Saved polygon to map](ReadMeImages/EditingGeospatialObjects/SavedPolygonToMap.png)

### Bike Path Polylines

To get around this walk zone and to get to the center of campus, we can draw a preferred bike route that avoids too much foot traffic.  Again open the `+` to show the create options.

![Show Create Options Polyline](ReadMeImages/EditingGeospatialObjects/ShowCreateOptionsPolyline.png)  

Tap on the `Bike Path` cell to begin creating a bike path.

![Bike Path Panel](ReadMeImages/EditingGeospatialObjects/BikePathPanel.png)

Coming from the Telegraph and Bancroft Intersection, I might take this path.  Again we tap on the map to add points.  Below is just a rough path.

![Bancroft Barrow Ln Intersection](ReadMeImages/EditingGeospatialObjects/BancroftBarrowLnIntersection.png)

![Bancroft to Barrow Ln](ReadMeImages/EditingGeospatialObjects/BancroftToBarrowLn.png)

![Barrow Ln to Hearst North Field](ReadMeImages/EditingGeospatialObjects/BarrowLnToHearstNorthField.png)

![Hearst North Field to S Hall Rd](ReadMeImages/EditingGeospatialObjects/HearstNorthFieldToSHallRd.png)

![S Hall to Bancroft](ReadMeImages/EditingGeospatialObjects/SHallToBancroft.png)

![Bancroft to Memorial Glade](ReadMeImages/EditingGeospatialObjects/BancroftToMemorialGlade.png)

![Memorial Glade to Moffit Library](ReadMeImages/EditingGeospatialObjects/MemorialGladeToMoffitLibrary.png)

Going straight through Memorial Glade to Moffit Library can be difficult since its practically all grass with many students around.  We can tap the Undo Button on the toolbar to undo the added points.

![Undo Memorial Glade to Moffit Library](ReadMeImages/EditingGeospatialObjects/UndoMemorialGladeToMoffitLibrary.png)

![Undo S Hall Rd to Memorial Glade](ReadMeImages/EditingGeospatialObjects/UndoBancroftToMemorialGlade.png)

If we wanted to add back our points, we can use the Redo Button.

![Redo S Hall Rd to Memorial Glade](ReadMeImages/EditingGeospatialObjects/RedoBancroftToMemorialGlade.png)

![Redo Memorial Glade to Moffit Library](ReadMeImages/EditingGeospatialObjects/RedoMemorialGladToMoffitLibrary.png)

To delete a point we can toggle the Delete Button and tap the point on the map.  Set the Delete Button on.

![Delete Point ON](ReadMeImages/EditingGeospatialObjects/DeletePointON.png)

Then tap a point.

![Delete Memorial Glade to Moffit Library](ReadMeImages/EditingGeospatialObjects/DeleteMemorialGladeToMoffitLibrary.png)

We can also swipe to delete on the editing panel.

![Swipe to Delete Memorial Glade Point](ReadMeImages/EditingGeospatialObjects/SwipeToDeleteMemorialGladPoint.png)

![Swipe to Delete Memorial Glade Point show alert](ReadMeImages/EditingGeospatialObjects/SwipeToDeleteMemorialGladePointShowAlert.png)

This path needs some cleanup since its not always following the road.  

![Does not follow road](ReadMeImages/EditingGeospatialObjects/DoesNotFollowRoad.png)

We can press and hold on any line to create a point mid segment

![Create Midpoint segment](ReadMeImages/EditingGeospatialObjects/CreateMidPointSegment.png)

Another path I take branches out from this route.  By tapping the Branch button in the toolbar we can add a branch off of the path.

First, we toggle the Branch Button to on.

![Branch Button ON](ReadMeImages/EditingGeospatialObjects/BranchPointOn.png)

Next, we tap to another point on the map to continue adding points

![Branch Away point 1](ReadMeImages/EditingGeospatialObjects/BranchAwayPoint1.png)

![Branch Away point 2](ReadMeImages/EditingGeospatialObjects/BranchAwayPoint2.png)

Finally, we can save our path by tapping on Save to do additional post processing.

![Postprocessing bike path](ReadMeImages/EditingGeospatialObjects/PostprocessingBikePath.png)

Tapping the Save in the top right, the path is now added to the map.

![Path added to the map](ReadMeImages/EditingGeospatialObjects/PathAddedToMap.png)

### Brewery Points

After biking around campus, we could get a refreshing beer at a local brewery.

Again open the `+` to show the create options.

![Show Create Options Point](ReadMeImages/EditingGeospatialObjects/ShowCreateOptionsPoint.png)  

Tap on the `Brewery` cell to begin creating a brewery point.

![Brewery Editing Panel](ReadMeImages/EditingGeospatialObjects/BreweryEditingPanel.png)

We can type directly into the cell to search for the location.  Tap on the `Add New Point` cell to open the suggestions.

![Suggestionsf Open](ReadMeImages/EditingGeospatialObjects/SuggestionsOpen.png)

Begin typing `FieldWork` to show search results.

![FieldWork Brewing Suggestion](ReadMeImages/EditingGeospatialObjects/FieldworkBrewingSuggestion.png)

Tap on `Fieldwork Brewing Company` and the point will be added.

![FieldWork added editing](ReadMeImages/EditingGeospatialObjects/FieldworkAddedEditing.png)

Tap save to show post processing.

![Create Point postprocessing](ReadMeImages/EditingGeospatialObjects/CreatePointPostProcessing.png)

Tap save to add the point to the map.

![Added Brewery to map](ReadMeImages/EditingGeospatialObjects/AddedBreweryToMap.png)

### Venue Geospatial Items

After spending the day in Berkeley, you decide to schedule a biking event.  Again open the `+` to show the create options.

![Show Create Options Venue](ReadMeImages/EditingGeospatialObjects/ShowCreateOptionsVenue.png)  

Tap on the `Venue` cell to begin creating a venue item.

![Show Venue Panel](ReadMeImages/EditingGeospatialObjects/ShowVenuePanel.png)

Toggle the geospatial segmented control to polygon to begin drawing a polygon.

![Toggle segmented control to polygon](ReadMeImages/EditingGeospatialObjects/ToggleSegmentedControlToPolygon.png)

![Draw Venue Polygon1](ReadMeImages/EditingGeospatialObjects/DrawVenuePolygon1.png)

![Draw Venue Polygon2](ReadMeImages/EditingGeospatialObjects/DrawVenuePolygon2.png)

![Draw Venue Polygon3](ReadMeImages/EditingGeospatialObjects/DrawVenuePolygon3.png)

Instead of drawing a polygon, we can switch the geometry type while editing.  Toggle the geospatial segmented control to polyline.  An alert will be presented.

![Toggle to polyline alert](ReadMeImages/EditingGeospatialObjects/ToggleToPolylineAlert.png)

![Toggle segmented control to polyline](ReadMeImages/EditingGeospatialObjects/ToggleSegmentedControlToPolyline.png)

We can change the order of the points by using drag and drop on the panel.  Switch the point order by dragging the second cell above the first.

![Drag and drop cell reorder](ReadMeImages/EditingGeospatialObjects/DragAndDropCellReorder.png)

Save as usual and the map will show the Venue Item.

![Show final venue item](ReadMeImages/EditingGeospatialObjects/ShowFinalVenueItem.png)

Finally we can toggle the Bike and Bart layers to see the final product.  Now we can see the station annotations, Bart Line, and all of our custom geospatial items.

![Show all layers](ReadMeImages/EditingGeospatialObjects/ShowAllLayers.png)

## Next Steps

Although this is the last post for this release, in a future post I will extend this project to show Bart as an `FUIRoute`.

## Conclusion

The Map Floorplan component provides the foundation to create complex map applications.  Throughout this blog post series, I've documented:

* Map Floorplan Layers
* Map Legend
* Map Detail Panel
* Polylines and Polygons with StellarJay
* Drawing Geospatial Objects

I hope you learned more about SAPFiori iOS SDK's `FUIMapFloorplan`, and look forward to integrating this map feature into your next project!
