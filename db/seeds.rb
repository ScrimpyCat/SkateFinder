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


spot_name = SpotName.create!(:name => 'test')
s = SpotName.create!([{:name => 'one'}, {:name => 'two'}])
SkateSpot.create!(:name => spot_name, :alternative_names => [spot_name])
