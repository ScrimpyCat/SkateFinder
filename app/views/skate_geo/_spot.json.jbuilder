json.type 'Feature'
json.id 'spot'

json.geometry do
	json.type 'Point'
	json.coordinates do
		json.array! [spot.longitude.to_f, spot.latitude.to_f]
	end
end

json.properties do
	json.object_id spot.id
	json.name spot.name.try(:name)
	json.alt_names spot.alt_names.map { |n| n.name }
	json.park spot.park
	json.style spot.style #convert to name
	json.undercover spot.undercover
	json.cost spot.cost
	json.currency spot.currency
	json.lights spot.lights
	json.private_property spot.private_property
	# json.obstacles spot.obstacles.map { |o| o.type.name }
end
