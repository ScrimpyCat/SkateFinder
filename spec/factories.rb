FactoryGirl.define do
    factory :obstacle_type do
        name 'obstacle'
    end

    factory :obstacle do
        geometry '"type": "Polygon","coordinates": [[0,0],[1,0],[1,1],[0,1]]'

        after :build do |obstacle, evaluator|
            obstacle.type = FactoryGirl.create(:obstacle_type) if obstacle.type == nil
        end
    end

    factory :spot_name do
        name 'spot'
    end
end
