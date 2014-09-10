json.type "FeatureCollection"
json.features (@detailed == true ? [@spot, @spot] : [@spot]) + @spot.obstacles do |geo|
	if @detailed
		@detailed = false
		json.partial! 'spot', :spot => geo
	elsif geo.class == SkateSpot
		json.partial! 'spot_bounds', :spot => geo 
	else
		json.partial! 'obstacle', :obstacle => geo
	end
end
