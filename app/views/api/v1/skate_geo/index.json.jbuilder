json.type "FeatureCollection"
json.features @spots do |spot|
	json.partial! 'spot', :spot => spot
end
