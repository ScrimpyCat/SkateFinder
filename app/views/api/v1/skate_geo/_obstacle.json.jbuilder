json.type 'Feature'
json.id 'obstacle:' + obstacle.type.name.gsub(/ /, '_')

json.geometry do
	if obstacle.geometry.nil?
		json.null!
	else
		json.type 'Polygon'
		json.coordinates [obstacle.geometry[1..-1].gsub(/ /,'').split(',[').map! { |p| p[0..-2].split(',').map! { |c| c.to_f  } }]
	end
end

json.properties do
end
