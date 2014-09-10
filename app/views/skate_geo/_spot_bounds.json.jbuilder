json.type 'Feature'
json.id 'spot_bounds'

json.geometry do
	json.type 'Polygon'
	json.coordinates [spot.geometry[1..-1].gsub(/ /,'').split(',[').map! { |p| p[0..-2].split(',').map! { |c| c.to_f  } }]
end

json.properties do
	json.object_id spot.id
end
