json.object_id @spot.id
json.name @spot.name.try(:name) if @use[:name] or @detailed
json.alt_names @spot.alt_names.map { |n| n.name } if @use[:alt_names] or @detailed
json.park @spot.park if @use[:park] or @detailed
json.style @spot.style if @use[:style] or @detailed
json.undercover @spot.undercover if @use[:undercover] or @detailed
json.cost @spot.cost if @use[:cost] or @detailed
json.currency @spot.currency if @use[:cost] or @detailed
json.lights @spot.lights if @use[:lights] or @detailed
json.private_property @spot.private_property if @use[:private_property] or @detailed
json.obstacles @spot.obstacles.map { |o| o.type.name } if @use[:obstacles] or @detailed
