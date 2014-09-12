require 'rails_helper'


def it_has_expected_response_header
    it { expect(response).to be_success }
    it { expect(response).to have_http_status(200) }
    it { expect(response.content_type).to eql('application/json') }
end

def test_update_boolean(attribute, allows_nil = true)
    describe "set #{attribute.to_s}" do
        describe 'to valid value' do
            context 'true' do
                before { xhr :put, :update, :id => @spot.id, attribute => 'true' }

                it_has_expected_response_header
                it { expect(response.body).to eql(success) }
                it { expect(SkateSpot.find(@spot).send(attribute)).to be_truthy }
            end

            context 'false' do
                before { xhr :put, :update, :id => @spot.id, attribute => 'false' }

                it_has_expected_response_header
                it { expect(response.body).to eql(success) }
                it { expect(SkateSpot.find(@spot).send(attribute)).to be_falsey }
            end

            if allows_nil
                context 'nil' do
                    before { xhr :put, :update, :id => @spot.id, attribute => nil }

                    it_has_expected_response_header
                    it { expect(response.body).to eql(success) }
                    it { expect(SkateSpot.find(@spot).send(attribute)).to be_nil }
                end
            end
        end

        context 'to invalid value' do
            let(:original_value) { @spot.send(attribute) }
            before { xhr :put, :update, :id => @spot.id, attribute => 'invalid' }

            it_has_expected_response_header
            it { expect(response.body).to eql(failure) }
            it { expect(SkateSpot.find(@spot).send(attribute)).to eql(original_value) }
        end
    end
end

RSpec.describe SkateGeoController, :type => :controller do
    let(:failure) { { 'status' => 'unprocessable_entity' }.to_json }
    let(:success) { { 'status' => 'success' }.to_json }
    before { @spot = FactoryGirl.create(:skate_spot) }

    describe 'GET #index' do
        context 'missing query' do
            before { xhr :get, :index }

            it_has_expected_response_header
            it { expect(response.body).to eql(failure) }
        end

        context 'query spots in area' do
            before { xhr :get, :index, :longitude => 0, :latitude => 0, :area => 0 }

            it_has_expected_response_header
            it { expect(response.body).to_not eql(failure) }
        end
    end

    describe 'POST #create' do
        context 'minimum initialized' do
            let(:value) { [[0,0],[0,1],[1,1],[0,0]].to_s }
            before { xhr :post, :create, :geometry => value }

            it_has_expected_response_header
            it { expect(response.body).to eql(success) }
            it { expect(SkateSpot.all.count).to eql(2) }

            it { expect(SkateSpot.last.geometry).to eql(value) }

            it { expect(SkateSpot.last.name).to be_nil }
            it { expect(SkateSpot.last.alt_names).to be_empty }
            it { expect(SkateSpot.last.park).to be_nil }
            it { expect(SkateSpot.last.style).to be_nil }
            it { expect(SkateSpot.last.undercover).to be_nil }
            it { expect(SkateSpot.last.cost).to be_nil }
            it { expect(SkateSpot.last.currency).to be_nil }
            it { expect(SkateSpot.last.lights).to be_nil }
            it { expect(SkateSpot.last.private_property).to be_nil }
            it { expect(SkateSpot.last.obstacles).to be_empty }
        end

        context 'completely initialized' do
            let(:geometry) { [[0,0],[0,1],[1,1],[0,0]].to_s }
            let(:name) { 'example' }
            let(:alt_names) { ['sample', 'template'] }
            let(:park) { true }
            let(:style) { SkateSpot::Style[:street] }
            let(:undercover) { true }
            let(:cost) { 100 }
            let(:currency) { 'AUD' }
            let(:lights) { true }
            let(:private_property) { true }
            let(:obstacles) {
                FactoryGirl.create(:obstacle_type, :name => 'obstacle')
                { :type => 'obstacle', :geometry => geometry }
            }
            before {
                xhr :post, :create, {
                    :geometry => geometry,
                    :name => name,
                    :alt_names => alt_names,
                    :park => park,
                    :style => style,
                    :undercover => undercover,
                    :cost => cost,
                    :currency => currency,
                    :lights => lights,
                    :private_property => private_property,
                    :obstacles => obstacles
                }
            }

            it_has_expected_response_header
            it { expect(response.body).to eql(success) }
            it { expect(SkateSpot.all.count).to eql(2) }

            it { expect(SkateSpot.last.geometry).to eql(geometry) }
            it { expect(SkateSpot.last.name.name).to eql(name) }
            it { expect(SkateSpot.last.alt_names.count).to eql(3) }
            it { expect(SkateSpot.last.alt_names.all? { |n| alt_names.include?(n.name) or n.name == name }).to be_truthy }
            it { expect(SkateSpot.last.park).to eql(park) }
            it { expect(SkateSpot.last.style).to eql(style) }
            it { expect(SkateSpot.last.undercover).to eql(undercover) }
            it { expect(SkateSpot.last.cost).to eql(cost) }
            it { expect(SkateSpot.last.currency).to eql(currency) }
            it { expect(SkateSpot.last.lights).to eql(lights) }
            it { expect(SkateSpot.last.private_property).to eql(private_property) }
            it { expect(SkateSpot.last.obstacles.count).to eql(1) }
            it { expect(SkateSpot.last.obstacles.all? { |o| o.type.name == obstacles[:type] and o.geometry == obstacles[:geometry] }).to be_truthy }
        end

        context 'nothing initialized' do
            before { xhr :post, :create }

            it_has_expected_response_header
            it { expect(response.body).to eql(failure) }
        end

        describe 'invalid' do
            let(:geometry) { [[0,0],[0,1],[1,1],[0,0]].to_s }

            context 'geometry' do
                before { xhr :post, :create, :geometry => 'invalid' }
                
                it_has_expected_response_header
                it { expect(response.body).to eql(failure) }
            end

            context 'name' do
                before { xhr :post, :create, :geometry => geometry, :name => [] }
                
                it_has_expected_response_header
                it { expect(response.body).to eql(failure) }
            end

            context 'alt_names' do
                before { xhr :post, :create, :geometry => geometry, :alt_names => {} }
                
                it_has_expected_response_header
                it { expect(response.body).to eql(failure) }
            end

            context 'park' do
                before { xhr :post, :create, :geometry => geometry, :park => 'invalid' }
                
                it_has_expected_response_header
                it { expect(response.body).to eql(failure) }
            end

            context 'style' do
                before { xhr :post, :create, :geometry => geometry, :style => 'invalid' }
                
                it_has_expected_response_header
                it { expect(response.body).to eql(failure) }
            end

            context 'undercover' do
                before { xhr :post, :create, :geometry => geometry, :undercover => 'invalid' }
                
                it_has_expected_response_header
                it { expect(response.body).to eql(failure) }
            end

            context 'cost' do
                before { xhr :post, :create, :geometry => geometry, :cost => 'invalid' }
                
                it_has_expected_response_header
                it { expect(response.body).to eql(failure) }
            end

            context 'currency' do
                before { xhr :post, :create, :geometry => geometry, :currency => 'invalid' }
                
                it_has_expected_response_header
                it { expect(response.body).to eql(failure) }
            end

            context 'lights' do
                before { xhr :post, :create, :geometry => geometry, :lights => 'invalid' }
                
                it_has_expected_response_header
                it { expect(response.body).to eql(failure) }
            end

            context 'private_property' do
                before { xhr :post, :create, :geometry => geometry, :private_property => 'invalid' }
                
                it_has_expected_response_header
                it { expect(response.body).to eql(failure) }
            end

            context 'obstacles' do
                before { xhr :post, :create, :geometry => geometry, :obstacles => 'invalid' }
                
                it_has_expected_response_header
                it { expect(response.body).to eql(failure) }
            end
        end
    end

    describe 'GET #show' do
        context 'invalid spot' do
            before { xhr :get, :show, :id => 0 }

            it_has_expected_response_header
            it { expect(response.body).to eql(failure) }
        end

        context 'valid spot' do
            before { xhr :get, :show, :id => @spot.id }

            it_has_expected_response_header
            it { expect(response.body).to_not eql(failure) }
        end
    end

    describe 'PUT #update' do
        context 'invalid spot' do
            before { xhr :put, :update, :id => 0 }

            it_has_expected_response_header
            it { expect(response.body).to eql(failure) }
        end

        context 'no field' do
            before { xhr :put, :update, :id => @spot.id }

            it_has_expected_response_header
            it { expect(response.body).to eql(success) }
        end

        context 'invalid field' do
            before { xhr :put, :update, :id => @spot.id, :non_existent_field => 'test' }

            it_has_expected_response_header
            it { expect(response.body).to eql(success) }
        end

        describe 'set geometry' do
            describe 'to valid value' do
                context 'string' do
                    let(:value) { [[0,0],[0,1],[1,1],[0,0]].to_s }
                    before { xhr :put, :update, :id => @spot.id, :geometry => value }

                    it_has_expected_response_header
                    it { expect(response.body).to eql(success) }
                    it { expect(SkateSpot.find(@spot).geometry).to eql(value) }
                end
            end

            describe 'to invalid value' do
                context 'nil' do
                    let(:original_value) { @spot.geometry }
                    before { xhr :put, :update, :id => @spot.id, :geometry => nil }

                    it_has_expected_response_header
                    it { expect(response.body).to eql(failure) }
                    it { expect(SkateSpot.find(@spot).geometry).to eql(original_value) }
                end
            end
        end

        describe 'set name' do
            describe 'to valid value' do
                context 'string' do
                    before { xhr :put, :update, :id => @spot.id, :name => 'test_string' }

                    it_has_expected_response_header
                    it { expect(response.body).to eql(success) }
                    it { expect(SkateSpot.find(@spot).name.name).to eql('test_string') }
                end

                context 'nil' do
                    before { xhr :put, :update, :id => @spot.id, :name => nil }

                    it_has_expected_response_header
                    it { expect(response.body).to eql(success) }
                    it { expect(SkateSpot.find(@spot).name).to be_nil }
                end
            end

            describe 'through alt_names' do
                before {
                    xhr :put, :update, :id => @spot.id, :name => 'test_string'
                    xhr :put, :update, :id => @spot.id, :alt_names => []
                }

                it_has_expected_response_header
                it { expect(response.body).to eql(success) }
                it { expect(SkateSpot.find(@spot).name).to be_nil }
            end
        end

        describe 'set alt_names' do
            describe 'to valid value' do
                context 'multiple strings' do
                    before { xhr :put, :update, :id => @spot.id, :alt_names => ['one', 'two'] }

                    it_has_expected_response_header
                    it { expect(response.body).to eql(success) }
                    it { expect(SkateSpot.find(@spot).alt_names.count).to eql(2) }
                    it { expect(SkateSpot.find(@spot).alt_names[0].name).to eql('one') }
                    it { expect(SkateSpot.find(@spot).alt_names[1].name).to eql('two') }
                end

                context 'string' do
                    before { xhr :put, :update, :id => @spot.id, :alt_names => 'test_string' }

                    it_has_expected_response_header
                    it { expect(response.body).to eql(success) }
                    it { expect(SkateSpot.find(@spot).alt_names.count).to eql(1) }
                    it { expect(SkateSpot.find(@spot).alt_names[0].name).to eql('test_string') }
                end

                context 'nil' do
                    before { xhr :put, :update, :id => @spot.id, :alt_names => nil }

                    it_has_expected_response_header
                    it { expect(response.body).to eql(success) }
                    it { expect(SkateSpot.find(@spot).alt_names.count).to eql(0) }
                end
            end
        end

        test_update_boolean(:park)

        describe 'set style' do
            describe 'to valid value' do
                context 'number' do
                    before { xhr :put, :update, :id => @spot.id, :style => SkateSpot::Style[:street] }

                    it_has_expected_response_header
                    it { expect(response.body).to eql(success) }
                    it { expect(SkateSpot.find(@spot).style).to eql(SkateSpot::Style[:street]) }
                end

                context 'nil' do
                    before { xhr :put, :update, :id => @spot.id, :style => nil }

                    it_has_expected_response_header
                    it { expect(response.body).to eql(success) }
                    it { expect(SkateSpot.find(@spot).style).to be_nil }
                end
            end
        end

        test_update_boolean(:undercover)
        
        describe 'set cost' do
            describe 'to valid value' do
                context 'number' do
                    before { xhr :put, :update, :id => @spot.id, :cost => 100 }

                    it_has_expected_response_header
                    it { expect(response.body).to eql(success) }
                    it { expect(SkateSpot.find(@spot).cost).to eql(100) }
                end

                context 'nil' do
                    before { xhr :put, :update, :id => @spot.id, :cost => nil }

                    it_has_expected_response_header
                    it { expect(response.body).to eql(success) }
                    it { expect(SkateSpot.find(@spot).cost).to be_nil }
                end
            end
        end

        describe 'set currency' do
            describe 'to valid value' do
                context 'string' do
                    before { xhr :put, :update, :id => @spot.id, :currency => 'ZZZ' }

                    it_has_expected_response_header
                    it { expect(response.body).to eql(success) }
                    it { expect(SkateSpot.find(@spot).currency).to eql('ZZZ') }
                end

                context 'nil' do
                    before { xhr :put, :update, :id => @spot.id, :currency => nil }

                    it_has_expected_response_header
                    it { expect(response.body).to eql(success) }
                    it { expect(SkateSpot.find(@spot).currency).to be_nil }
                end
            end
        end

        test_update_boolean(:lights)
        test_update_boolean(:private_property)

        describe 'set obstacles' do
            describe 'to valid value' do
                before {
                    FactoryGirl.create(:obstacle_type, :name => 'one')
                    FactoryGirl.create(:obstacle_type, :name => 'two')
                }

                context 'multiple obstacles' do
                    before { xhr :put, :update, :id => @spot.id, :obstacles => [{ :type => 'one', :geometry => [[0,0],[0,1],[1,1],[0,0]].to_s }, { :type => 'two', :geometry => [[2,0],[2,1],[1,1.5],[1.5,2],[2,0]].to_s }] }

                    it_has_expected_response_header
                    it { expect(response.body).to eql(success) }
                    it { expect(SkateSpot.find(@spot).obstacles.count).to eql(2) }
                    it { expect(SkateSpot.find(@spot).obstacles[0].type.name).to eql('one') }
                    it { expect(SkateSpot.find(@spot).obstacles[1].type.name).to eql('two') }
                end

                context 'obstacle' do
                    before { xhr :put, :update, :id => @spot.id, :obstacles => { :type => 'one', :geometry => [[0,0],[0,1],[1,1],[0,0]].to_s } }

                    it_has_expected_response_header
                    it { expect(response.body).to eql(success) }
                    it { expect(SkateSpot.find(@spot).obstacles.count).to eql(1) }
                    it { expect(SkateSpot.find(@spot).obstacles[0].type.name).to eql('one') }
                end

                context 'nil' do
                    before { xhr :put, :update, :id => @spot.id, :obstacles => nil }

                    it_has_expected_response_header
                    it { expect(response.body).to eql(success) }
                    it { expect(SkateSpot.find(@spot).obstacles.count).to eql(0) }
                end
            end

            describe 'to invalid value' do
                context 'non-existent type' do
                    before { xhr :put, :update, :id => @spot.id, :obstacles => { :type => 'missing' } }

                    it_has_expected_response_header
                    it { expect(response.body).to eql(failure) }
                end
            end
        end
    end

    describe 'DELETE #destroy' do
        context 'invalid spot' do
            before { xhr :delete, :destroy, :id => 0 }

            it_has_expected_response_header
            it { expect(response.body).to eql(failure) }
            it { expect(SkateSpot.all.count).to eql(1) }
        end

        context 'valid spot' do
            before { xhr :delete, :destroy, :id => @spot.id }

            it_has_expected_response_header
            it { expect(response.body).to eql(success) }
            it { expect(SkateSpot.all.count).to eql(0) }
        end
    end
end
