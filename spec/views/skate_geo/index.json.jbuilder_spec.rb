require 'rails_helper'

RSpec.describe 'api/v1/skate_geo/index.json.jbuilder', :type => :view do
    shared_examples 'expected GeoJSON' do
        it 'should render' do
            render

            expect(JSON.parse(rendered)).to eql({
                'type' => 'FeatureCollection',
                'features' => @spots.map { |spot|
                    {
                        'type' => 'Feature',
                        'id' => 'spot',
                        'geometry' => {
                            'type' => 'Point',
                            'coordinates' => [spot.longitude.to_f, spot.latitude.to_f]
                        },
                        'properties' => {
                            'object_id' => spot.id,
                            'name' => spot.name.try(:name),
                            'alt_names' => spot.alt_names.map { |n| n.name },
                            'park' => spot.park,
                            'style' => spot.style,
                            'undercover' => spot.undercover,
                            'cost' => spot.cost,
                            'currency' => spot.currency,
                            'lights' => spot.lights,
                            'private_property' => spot.private_property
                        }
                    }
                }
            })
        end
    end

    context 'with no skate spots' do
        before {
            @spots = []
            assign(:spots, SkateSpot.all)
        }

        it_behaves_like 'GeoJSON'
        it_behaves_like 'expected GeoJSON'
    end

    context 'with a single skate spot' do
        before {
            @spots = [FactoryGirl.build(:skate_spot)]
            
            @spots[0].name = FactoryGirl.create(:spot_name, :name => 'one', :spot => @spots[0])
            FactoryGirl.create(:spot_name, :name => 'two', :spot => @spots[0])
            
            FactoryGirl.create(:obstacle, :spot => @spots[0])
            
            @spots[0].save

            assign(:spots, SkateSpot.all)
        }

        it_behaves_like 'GeoJSON'
        it_behaves_like 'expected GeoJSON'
    end

    context 'with multiple skate spots' do
        before {
            @spots = [FactoryGirl.build(:skate_spot), FactoryGirl.build(:skate_spot)]
            
            @spots[0].name = FactoryGirl.create(:spot_name, :name => 'one', :spot => @spots[0])
            FactoryGirl.create(:spot_name, :name => 'two', :spot => @spots[0])
            @spots[1].name = FactoryGirl.create(:spot_name, :name => 'three', :spot => @spots[1])
            FactoryGirl.create(:spot_name, :name => 'four', :spot => @spots[1])

            o = FactoryGirl.create(:obstacle, :spot => @spots[0])
            FactoryGirl.create(:obstacle, :type => o.type, :spot => @spots[1])

            @spots[0].save
            @spots[1].save

            assign(:spots, SkateSpot.all)
        }

        it_behaves_like 'GeoJSON'
        it_behaves_like 'expected GeoJSON'
    end
end
