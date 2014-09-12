ObstacleType.create([
    { :name => 'quarter pipe' },
    { :name => 'half-pipe' },
    { :name => 'bowl' },
    { :name => 'deck' },
    { :name => 'spine' },
    { :name => 'extension' },
    { :name => 'escalator' },
    { :name => 'flat' },
    { :name => 'vert wall' },
    { :name => 'bank' },
    { :name => 'hip' },
    { :name => 'funbox' },
    { :name => 'pyramid' },
    { :name => 'launcher/kicker' },
    { :name => 'roll-in' },
    { :name => 'step-up/eurobox' },
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
    :longitude => 0.5, #remove later
    :latitude => 0.5, #remove later
    :geometry => [
            [144.97301369905472, -37.82018578464621],
            [144.97276961803436, -37.820827772676125],
            [144.97300565242767, -37.82087650421276],
            [144.9732604622841, -37.82025782318512],
            [144.97301369905472, -37.82018578464621]
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
    { :type => ObstacleType.where(:name => 'hip').first, :spot => riverslide_park },
    { :type => ObstacleType.where(:name => 'flat rail').first, :spot => riverslide_park },
    { :type => ObstacleType.where(:name => 'funbox').first, :spot => riverslide_park },
    { :type => ObstacleType.where(:name => 'sloped rail').first, :spot => riverslide_park },
    { :type => ObstacleType.where(:name => 'step-up/eurobox').first, :spot => riverslide_park },
    { :type => ObstacleType.where(:name => 'stairs').first, :spot => riverslide_park },
    { :type => ObstacleType.where(:name => 'launcher/kicker').first, :spot => riverslide_park },
    { :type => ObstacleType.where(:name => 'ledge').first, :spot => riverslide_park }
])

names = SpotName.create!([
    { :name => 'Riverslide', :spot => riverslide_park },
    { :name => 'Riverside', :spot => riverslide_park }
])

riverslide_park.name = names[0]
riverslide_park.save
