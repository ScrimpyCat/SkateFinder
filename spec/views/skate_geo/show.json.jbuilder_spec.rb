require 'rails_helper'

RSpec.shared_examples 'expected GeoJSON' do
    it 'should render' do
        render

        expect(JSON.parse(rendered)).to eql({
            'type' => 'FeatureCollection',
            'features' => (@detailed ? [{
                'type' => 'Feature',
                'id' => 'spot',
                'geometry' => {
                    'type' => 'Point',
                    'coordinates' => [@spot.longitude.to_f, @spot.latitude.to_f]
                },
                'properties' => {
                    'object_id' => @spot.id,
                    'name' => @spot.name.try(:name),
                    'alt_names' => @spot.alt_names.map { |n| n.name },
                    'park' => @spot.park,
                    'style' => @spot.style,
                    'undercover' => @spot.undercover,
                    'cost' => @spot.cost,
                    'currency' => @spot.currency,
                    'lights' => @spot.lights,
                    'private_property' => @spot.private_property
                }
            }] : []) + [{
                'type' => 'Feature',
                'id' => 'spot_bounds',
                'geometry' => {
                    'type' => 'Polygon',
                    'coordinates' => [JSON.parse(@spot.geometry).map { |p| p.map { |c| c.to_f } }]
                },
                'properties' => { 'object_id' => @spot.id }
            }] + @spot.obstacles.map { |obstacle|
                {
                    'type' => 'Feature',
                    'id' => 'obstacle:' + obstacle.type.name.gsub(/ /, '_'),
                    'geometry' => {
                        'type' => 'Polygon',
                        'coordinates' => [JSON.parse(obstacle.geometry).map { |p| p.map { |c| c.to_f } }]
                    },
                    'properties' => {}
                }
            }
        })
    end
end

RSpec.shared_examples 'geo-spatial' do
    context 'when not detailed' do
        before {
            @detailed = false
            assign(:detailed, @detailed)
        }

        it_behaves_like 'GeoJSON'
        it_behaves_like 'expected GeoJSON'
    end

    context 'when detailed' do
        before {
            @detailed = true
            assign(:detailed, @detailed)
        }

        it_behaves_like 'GeoJSON'
        it_behaves_like 'expected GeoJSON'
    end
end

RSpec.describe 'skate_geo/show.json.jbuilder', :type => :view do
    describe 'without names or obstacles' do
        before {
            @spot = FactoryGirl.create(:skate_spot)
            assign(:spot, @spot)
        }

        it_behaves_like 'geo-spatial'
    end

    describe 'with obstacles' do
        before {
            @spot = FactoryGirl.build(:skate_spot)

            @spot.name = FactoryGirl.create(:spot_name, :name => 'one', :spot => @spot)
            FactoryGirl.create(:spot_name, :name => 'two', :spot => @spot)

            o = FactoryGirl.create(:obstacle, :spot => @spot)
            FactoryGirl.create(:obstacle, :type => o.type, :spot => @spot)

            @spot.save

            assign(:spot, @spot)
        }

        it_behaves_like 'geo-spatial'
    end
end
