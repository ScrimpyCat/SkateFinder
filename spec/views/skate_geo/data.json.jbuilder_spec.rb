require 'rails_helper'

RSpec.describe 'api/v1/skate_geo/data.json.jbuilder', :type => :view do
    shared_examples 'expected JSON' do
        it 'should render' do
            render

            expect(JSON.parse(rendered)).to eql({
                'object_id' => @spot.id,
                'name' => @spot.name.try(:name),
                'alt_names' => @spot.alt_names.map { |n| n.name },
                'park' => @spot.park,
                'style' => @spot.style,
                'undercover' => @spot.undercover,
                'cost' => @spot.cost,
                'currency' => @spot.currency,
                'lights' => @spot.lights,
                'private_property' => @spot.private_property,
                'obstacles' => @spot.obstacles.map { |o| o.type.name }
            }.keep_if { |k, v| @detailed || @use[k.to_sym] || k == 'object_id' || (k == 'currency' && @use[:cost]) })
        end
    end

    shared_examples 'data' do
        describe 'when not detailed' do
            before { assign(:detailed, @detailed = false) }

            context 'reuiring no attributes' do
                before { assign(:use, @use = {}) }
                it_behaves_like 'expected JSON'
            end

            context 'reuiring all attributes' do
                before {
                    assign(:use, @use = {
                        :name => true,
                        :alt_names => true,
                        :park => true,
                        :style => true,
                        :undercover => true,
                        :cost => true,
                        :lights => true,
                        :private_property => true,
                        :obstacles => true
                    })
                }

                it_behaves_like 'expected JSON'
            end
        end

        context 'when detailed' do
            before {
                assign(:detailed, @detailed = true)
                assign(:use, @use = {})
            }

            it_behaves_like 'expected JSON'
        end
    end

    describe 'without names or obstacles' do
        before {
            @spot = FactoryGirl.create(:skate_spot)
            assign(:spot, @spot)
        }

        it_behaves_like 'data'
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

        it_behaves_like 'data'
    end
end
