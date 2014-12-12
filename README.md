SkateFinder
===========

A school project for mapping skate spots (displayed using Google Maps), with a publicly accessible JSON API. This is the project as it was when submitted, I do want to get around to finishing off the missing features but I'm unsure when that'll happen.


Missing Features
----------------

 * Expose `add spot` functionality to frontend
 * Expose `add/edit obstacles` functionality to the frontend
 * Style the site
 * Custom 404 page
 * API: Query spots in an area (currently just returns them all)
 * API: Optimize query by caching the spots in a subdivided grid
 * Spot markers should be centroid of their bounds (currently uses first point)



JSON API
--------

The API allows for creation, update, deletion, and queries (multiple spots in an area, or more detailed information in-relation to one spot) of skate spots. It can return ordinary JSON or GeoJSON depending on the type of information being retrieved.

The API calls, all follow this URI scheme: /api/ followed by the version /v1/ followed by the controller managing them /skategeo/


#####Querying all spots in a certain area: GET /api/v1/skategeo  
With parameters:

	required: longitude : float : the longitude the area should revolve around
	required: latitude : float : the latitude the area should revolve around
	required: area : integer : the distance to search

Returns:

	{"status":"success", "data":geojson_data_collection } on successful query
	{"status":"unprocessable_entity"} on failure

Example:

	curl -H "Accept: application/json" -G -d "longitude=0&latitude=0&area=0" http://0.0.0.0:3000/api/v1/skategeo
	{"status":"success","data":{"type":"FeatureCollection","features":[{"type":"Feature","id":"spot","geometry":{"type":"Point","coordinates":[144.973012357,-37.8201508247417]},"properties":{"object_id":1,"name":"Riverslide","alt_names":["Riverslide","Riverside"],"park":true,"style":3,"undercover":false,"cost":0,"currency":null,"lights":true,"private_property":false}}]}}



#####Querying information of a spot: GET /api/v1/skategeo/1/  
With parameters:

	optional: detailed : bool : whether the result should be detailed or not
	optional: geo : bool : whether the result should be about its geospatial qualities or not
	optional: name : bool : whether the name property should be returned or not
	optional: alt_names : bool : whether the alternative names property should be returned or not
	optional: park : bool : whether the park property should be returned or not
	optional: style : bool : whether the style property should be returned or not
	optional: undercover : bool : whether the undercover property should be returned or not
	optional: cost : bool : whether the cost property should be returned or not
	optional: lights : bool : whether the lights property should be returned or not
	optional: private_property : bool : whether the private property property should be returned or not
	optional: obstacles : bool : whether the obstacles property should be returned or not

Returns:

	{"status":"success", "data":geojson_data_or_json_data } on successful query
	{"status":"unprocessable_entity"} on failure

Example:

	curl -H "Accept: application/json" -G -d "geo=false&name=true&alt_names=true" http://0.0.0.0:3000/api/v1/skategeo/1/
	{"status":"success","data":{"object_id":1,"name":"Riverslide","alt_names":["Riverslide","Riverside"]}}



#####Creating a new spot: POST /api/v1/skategeo/  
With parameters:

	required: geometry : polygon array (GeoJSON compliant) : the bounds of the spot
	optional: name : string : the primary name of the spot
	optional: alt_names : string array : the alternative names of the spot
	optional: park : bool : whether it is a park or a street spot
	optional: style : integer (0 - 3) : whether it has stuff that allows for street or vert or both styles of skating
	optional: undercover : bool : whether the spot is undercover (avoids rain)
	optional: cost : integer : the amount the spot costs to visit
	optional: currency : string (3 chars/country currency code) : the currency of for the cost
	optional: lights : bool : whether the spot has lights around it, e.g. allows for night time skating
	optional: private_property : bool : whether the spot is actually only private property, and so likelihood you may get kicked out
	optional: obstacles : obstacle array (obstacle is represented as a named hash with type as a string, and geometry as the bounds) : where the obstacles are at the spot

Returns:

	{"status":"success"} on successful creation
	{"status":"unprocessable_entity"} on failure

Example:

	curl -H "Accept: application/json" -X POST -d "geometry=[[0,0],[1,0],[0,1],[0,0]]" http://0.0.0.0:3000/api/v1/skategeo/
	{"status":"success"}



#####Updating a spot: PUT /api/v1/skategeo/1/  
With parameters:

	optional: geometry : polygon array (GeoJSON compliant) : the bounds of the spot
	optional: name : string : the primary name of the spot
	optional: alt_names : string array : the alternative names of the spot
	optional: park : bool : whether it is a park or a street spot
	optional: style : integer (0 - 3) : whether it has stuff that allows for street or vert or both styles of skating
	optional: undercover : bool : whether the spot is undercover (avoids rain)
	optional: cost : integer : the amount the spot costs to visit
	optional: currency : string (3 chars/country currency code) : the currency of for the cost
	optional: lights : bool : whether the spot has lights around it, e.g. allows for night time skating
	optional: private_property : bool : whether the spot is actually only private property, and so likelihood you may get kicked out
	optional: obstacles : obstacle array (obstacle is represented as a named hash with type as a string, and geometry as the bounds) : where the obstacles are at the spot

Returns:

	{"status":"success"} on successful update
	{"status":"unprocessable_entity"} on failure

Example:

	curl -H "Accept: application/json" -X PUT -d "name=testing" http://0.0.0.0:3000/api/v1/skategeo/1/
	{"status":"success"}



#####Deleting a spot: DELETE /api/v1/skategeo/1/  
No parameters.

Returns:

	{"status":"success"} on successful deletion
	{"status":"unprocessable_entity"} on failure

Example:

	curl -H "Accept: application/json" -X DELETE http://0.0.0.0:3000/api/v1/skategeo/1/
	{"status":"success"}
