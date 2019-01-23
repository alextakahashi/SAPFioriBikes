# SAPFioriBikes: Drawing Geospatial Items

> Extending the SAPFioriBikes project by adding custom polylines and polygons. Check out the code [HERE](https://github.wdf.sap.corp/i860364/SAPFioriBikes)

This project follows up with the original [SAPFioriBikes Blog Series](https://github.wdf.sap.corp/i860364/SAPFioriBikes/blob/master/SAPFioriBikesBlog.md) by drawing custom points, polylines, and polygons on the map.  Through this walkthrough we also go over actions including:
* Adding points
* Deleting points
* Editing points
* Branching polylines
* Changing basemaps
* Adding points with suggestions
* Undo/Redo Editing actions
* Reordering points with drag and drop

## Drawing on the map

Drawing on the map allows users to document locations without the technical knowledge of adding them in code.  In this project, I draw polygons for walk zones and bike paths around the UC Berkeley campus using the floorplan's editing feature.  Currently drawing on the map is only supported on the iPad.  Although the SDK is designed for the enterprise use case such as a field worker monitoring an oil pipeline, this feature can be applied to the bikes example as well.  

### Walk Zone Polygons

Around the UC Berkeley campus, riding bikes is one of the main ways of commuting to and from class.  Due to high foot traffic, some locations on campus are designated walk zones for pedestrian safety.  The area between Sproul Hall and the Student Union as a central point in campus are where many students eat, socialize, and study.

![Upper Sproul Image]()

First, let's turn off the `Bikes Layer` and `Bart Layer` in the settings.  This will help declutter the map while we draw.

![Turn off Bikes and Bart Layer]()

Tap the `+` button in the upper right corner to open the popover showing the items that can be created, `Walk Zone`, `Bike Path`, `Brewery`, and `Venue`.

![Open Create Popover]()

Tap on the `Walk Zone` to being creating this polygon.  The editing panel appears on the left.  We will mark the perimeter of our walk zone between Sproul Hall to the ASUC Union from East to West and Sather Gate to Bancroft Way North to South.  Tap on the map to start adding points.

![ASUC Student Union Point]()

![Sather Gate East Point]()

![Sather Gate West Point]()

![Sproul Hall Point]()

It is difficult to see exactly what area we are drawing over because of the base map.  Change the base map in the panel to `hybrid`

![Base Map Selector - Satellite Selected]()

![Satellite View]()

With the basemap change, we can change the `colorScheme` of the map to show lines that appear better on this background.

From the map we can see the high density of students around campus.  Let's extend the points points north from Sather Gate to University Drive.  Press and hold the point then begin dragging to reposition the coordinate to University Drive

![Drag West Point to University Drive]()

![Drag East Point to University Drive]()

Now that we are finished creating the Walk Zone, we tap the Save Button at the bottom of the panel to do additional post processing.  The tableView can be populated with custom fields provided by the developer.  In this example we show the `FUIMapSnapshotFormCell` which shows the added geometry in a `UITableViewCell`.

![SnapshotFormCell Image]()

Tap save in the right corner and the polygon will be saved to the map.

![Saved polygon to map]()

### Bike Path Polylines

To get around this walk zone and to get to the center of campus, we can draw a preferred bike route that avoids too much foot traffic.  Again open the `+` to show the create options.

![Show Create Options Polyline]()  

Tap on the `Bike Path` cell to begin creating a bike path.

Coming from the Telegraph and Bancroft Intersection, I might take this path.  Again we tap on the map to add points.  Below is just a rough path.

![Bancroft Barrow Ln Intersection]()

![Bancroft to Barrow Ln]()

![Barrow Ln to Hearst North Field]()

![Hearst North Field to S Hall Rd]()

![S Hall Rd to Memorial Glade]()

![Memorial Glade to Moffit Library]()

Going straight through Memorial Glade to Moffit Library can be difficult since its practically all grass with many students around.  We can tap the Undo Button on the toolbar to undo the added points.

![Undo Memorial Glade to Moffit Library]()

![Undo S Hall Rd to Memorial Glade]()

If we wanted to add back our points, we can use the Redo Button.

![Redo Memorial Glade to Moffit Library]()

![Redo S Hall Rd to Memorial Glade]()

To delete a point we can toggle the Delete Button and tap the point on the map.  Set the Delete Button on.

![Delete Point ON]()

Then tap a point.

![Delete S Hall Rd to Memorial Glade]()

We can also swipe to delete on the editing panel.

![Swipe to Delete Memorial Glade Point show Red Delete]()

![Swipe to Delete Memorial Glade Point show Red Delete]()

This path needs some cleanup since its not always following the road.  We can press and hold on any line to create a point mid segment

![Create Midpoint segment]()

Another path I take branches out from this route.  By tapping the Branch button in the toolbar we can add a branch off of the path.

First select the point that we want to branch off of

![Branch Point Selected]()

Then, we toggle the Branch Button to on.

![Branch Button ON]()

Next, we tap to another point on the map to continue adding points

![Branch Away point 1]()

![Branch Away point 2]()

![Branch Away point 3]()

Finally, we can save our path by tapping on Save to do additional post processing.

![Postprocessing bike path]()

Tapping the Save in the top right, the path is now added to the map.

![Path added to the map]()

### Brewery Points

After biking around campus, we could get a refreshing beer at a local brewery.

Again open the `+` to show the create options.

![Show Create Options Point]()  

Tap on the `Brewery` cell to begin creating a brewery point.

![Brewery Editing Panel]()

We can type directly into the cell to search for the location.  Tap on the `Add New Point` cell to open the suggestions.

![Suggestions Open]()

Begin typing `FieldWork` to show search results.

![FieldWork Brewing Suggestion]()

Tap on `Fieldwork Brewing Company` and the point will be added.

![FieldWork added editing]()

Tap save to show post processing.

![Create Point postprocessing]()

Tap save to add the point to the map.

![Added Brewery to map]()

### Venue Geospatial Items

After spending the day in Berkeley, you decide to schedule a biking event.  Again open the `+` to show the create options.

![Show Create Options Venue]()  

Tap on the `Venue` cell to begin creating a venue item.

![Show Venue Panel]()

Toggle the geospatial segmented control to polygon to begin drawing a polygon.

![Toggle segmented control to polygon]()

![Draw Venue Polygon1]()

![Draw Venue Polygon2]()

![Draw Venue Polygon3]()

Instead of drawing a polygon, we can switch the geometry type while editing.  Toggle the geospatial segmented control to polyline.

![Toggle segmented control to polyline]()

We can change the order of the points by using drag and drop on the panel.  Switch the point order by dragging the second cell above the first.

![Drag and drop cell reorder]()

Save as usual and the map will show the Venue Item.

![Show final venue item]()

Finally we can toggle the Bike and Bart layers to see the final product.

![Show all layers]()

## Next Steps

Although this is the last post for this release, in a future post I will extend this project to show Bart as an `FUIRoute`.

## Conclusion

The Map Floorplan component provides the foundation to create complex map applications.  Throughout this blog post series, I've documented:

* Map Floorplan Layers
* Map Legend
* Map Detail Panel
* Polylines and Polygons with StellarJay
* Drawing Geospatial Objects

I hope you learned more about SAPFiori iOS SDK's `FUIMapFloorplan`!
