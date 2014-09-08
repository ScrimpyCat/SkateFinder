FactoryGirl.define do
    factory :obstacle_type do
        name 'obstacle'
    end

    factory :obstacle do
        geometry '"type": "Polygon","coordinates": [[0,0],[1,0],[1,1],[0,1]]'

        after :build do |obstacle, evaluator|
            obstacle.type ||= FactoryGirl.create(:obstacle_type)
            obstacle.spot ||= FactoryGirl.create(:skate_spot)
        end
    end

    factory :spot_name do
        name 'spot'

        after :build do |spot_name, evaluator|
            spot_name.spot ||= FactoryGirl.create(:skate_spot)
        end
    end

    factory :skate_spot do
        longitude 0.5
        latitude 0.5
        geometry '"type": "Polygon","coordinates": [[0,0],[1,0],[1,1],[0,1]]'
        park false
        style SkateSpot::Style[:unknown]
        undercover false
        cost 0
        currency 'AUD'
        lights false
        private_property false
    end
end
