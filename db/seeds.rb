ObstacleType.create([
    { :name => 'quarter pipe' },
    { :name => 'half-pipe' },
    { :name => 'bowl' },
    { :name => 'deck' },
    { :name => 'spine' },
    { :name => 'flat' },
    { :name => 'vert wall' },
    { :name => 'bank' },
    { :name => 'hip' },
    { :name => 'funbox' },
    { :name => 'pyramid' },
    { :name => 'kicker' },
    { :name => 'roll-in' },
    { :name => 'step-up' },
    { :name => 'wall-box' },
    { :name => 'pool' },
    { :name => 'foam pit' },
    { :name => 'flat rail' },
    { :name => 'sloped rail' },
    { :name => 'kinked rail' },
    { :name => 'stairs' },
    { :name => 'hand rail' },
    { :name => 'kidney bowl' },
    { :name => 'egg bowl' },
    { :name => 'cradle' },
    { :name => 'jersey barrier' },
    { :name => 'hubba' },
    { :name => 'ledge' }
])

riverslide_park = SkateSpot.new({
    :longitude => 144.97301369905472, #remove later
    :latitude => -37.82018578464621, #remove later
    :geometry => [
            [144.9730123579502, -37.82015082474169],
            [144.97278034687042, -37.820784867709634],
            [144.97302174568176, -37.820840485254],
            [144.97328460216522, -37.82020644276382],
            [144.9730123579502, -37.82015082474169]
        ].to_s,
    :park => true,
    :style => SkateSpot::Style[:street] | SkateSpot::Style[:vert],
    :undercover => false,
    :cost => 0,
    :lights => true,
    :private_property => false
})

Obstacle.create!([
    { :type => ObstacleType.where(:name => 'quarter pipe').first, :spot => riverslide_park },
    { :type => ObstacleType.where(:name => 'hubba').first, :spot => riverslide_park },
    {
        :type => ObstacleType.where(:name => 'hip').first,
        :spot => riverslide_park,
        :geometry => [
            [144.9727776646614, -37.82078645678291],
            [144.97285544872284, -37.820802877204784],
            [144.97287556529045, -37.820745670557955],
            [144.9728024750948, -37.820728190740354],
            [144.9727776646614, -37.82078645678291]
        ]
    },
    {
        :type => ObstacleType.where(:name => 'hip').first,
        :spot => riverslide_park,
        :geometry => [
            [144.97296676039696, -37.82082936174848],
            [144.9730183929205, -37.820841014944705],
            [144.9730385094881, -37.820788045856155],
            [144.97298687696457, -37.820770566048594],
            [144.97296676039696, -37.82082936174848]
        ]
    },
    { :type => ObstacleType.where(:name => 'flat rail').first, :spot => riverslide_park },
    {
        :type => ObstacleType.where(:name => 'funbox').first,
        :spot => riverslide_park,
        :geometry => [
            [144.9729587137699, -37.82070170616035],
            [144.97293390333652, -37.82065403389239],
            [144.9729935824871, -37.820633375900044],
            [144.97301369905472, -37.82067787003022],
            [144.9729587137699, -37.82070170616035]
        ] 
    },
    { :type => ObstacleType.where(:name => 'sloped rail').first, :spot => riverslide_park },
    { :type => ObstacleType.where(:name => 'stairs').first, :spot => riverslide_park },
    { :type => ObstacleType.where(:name => 'kicker').first, :spot => riverslide_park },
    {
        :type => ObstacleType.where(:name => 'ledge').first,
        :spot => riverslide_park,
        :geometry => [
            [144.97306264936924, -37.82071653752632],
            [144.9730720371008, -37.820719185984224],
            [144.97310757637024, -37.82063390559224],
            [144.97309885919094, -37.82063125713128],
            [144.97306264936924, -37.82071653752632]
        ]
    }
])

names = SpotName.create!([
    { :name => 'Riverslide', :spot => riverslide_park },
    { :name => 'Riverside', :spot => riverslide_park }
])

riverslide_park.name = names[0]
riverslide_park.save
