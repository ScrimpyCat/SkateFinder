require 'rails_helper'


def test_update_boolean(attribute, allows_nil = true)
    describe "set #{attribute.to_s}" do
        describe 'to valid value' do
            context 'true' do
                before { xhr :put, :update, :id => @spot.id, attribute => 'true' }

                it { expect(response).to be_success }
                it { expect(response).to have_http_status(200) }
                it { expect(response.content_type).to eql('application/json') }
                it { expect(response.body).to eql(success) }
                it { expect(SkateSpot.find(@spot).send(attribute)).to be_truthy }
            end

            context 'false' do
                before { xhr :put, :update, :id => @spot.id, attribute => 'false' }

                it { expect(response).to be_success }
                it { expect(response).to have_http_status(200) }
                it { expect(response.content_type).to eql('application/json') }
                it { expect(response.body).to eql(success) }
                it { expect(SkateSpot.find(@spot).send(attribute)).to be_falsey }
            end

            if allows_nil
                context 'nil' do
                    before { xhr :put, :update, :id => @spot.id, attribute => nil }

                    it { expect(response).to be_success }
                    it { expect(response).to have_http_status(200) }
                    it { expect(response.content_type).to eql('application/json') }
                    it { expect(response.body).to eql(success) }
                    it { expect(SkateSpot.find(@spot).send(attribute)).to be_nil }
                end
            end
        end

        # context 'to invalid value' do
        #     let(:original_value) { @spot.send(attribute) }
        #     before { xhr :put, :update, :id => @spot.id, attribute => 'invalid' }

        #     it { expect(response).to be_success }
        #     it { expect(response).to have_http_status(200) }
        #     it { expect(response.content_type).to eql('application/json') }
        #     it { expect(response.body).to eql(failure) }
        #     it { expect(SkateSpot.find(@spot).send(attribute)).to eql(original_value) }
        # end
    end
end

RSpec.describe SkateGeoController, :type => :controller do
    let(:failure) { { 'status' => 'unprocessable_entity' }.to_json }
    let(:success) { { 'status' => 'success' }.to_json }
    before { @spot = FactoryGirl.create(:skate_spot) }

    describe 'GET #index' do
        context 'missing query' do
            before { xhr :get, :index }

            it { expect(response).to be_success }
            it { expect(response).to have_http_status(200) }
            it { expect(response.content_type).to eql('application/json') }
            it { expect(response.body).to eql(failure) }
        end

        context 'query spots in area' do
            before { xhr :get, :index, :longitude => 0, :latitude => 0, :area => 0 }

            it { expect(response).to be_success }
            it { expect(response).to have_http_status(200) }
            it { expect(response.content_type).to eql('application/json') }
            it { expect(response.body).to_not eql(failure) }
        end
    end

    describe 'POST #create' do
        before { xhr :post, :create }
        # it "returns http success" do
        #     get :create
        #     expect(response).to be_success
        # end
    end

    describe 'GET #show' do
        context 'invalid spot' do
            before { xhr :get, :show, :id => 0 }

            it { expect(response).to be_success }
            it { expect(response).to have_http_status(200) }
            it { expect(response.content_type).to eql('application/json') }
            it { expect(response.body).to eql(failure) }
        end

        context 'valid spot' do
            before { xhr :get, :show, :id => @spot.id }

            it { expect(response).to be_success }
            it { expect(response).to have_http_status(200) }
            it { expect(response.content_type).to eql('application/json') }
            it { expect(response.body).to_not eql(failure) }
        end
    end

    describe 'PUT #update' do
        context 'no field' do
            before { xhr :put, :update, :id => @spot.id }

            it { expect(response).to be_success }
            it { expect(response).to have_http_status(200) }
            it { expect(response.content_type).to eql('application/json') }
            it { expect(response.body).to eql(success) }
        end

        context 'invalid field' do
            before { xhr :put, :update, :id => @spot.id, :non_existent_field => 'test' }

            it { expect(response).to be_success }
            it { expect(response).to have_http_status(200) }
            it { expect(response.content_type).to eql('application/json') }
            it { expect(response.body).to eql(success) }
        end

        test_update_boolean(:park)
        test_update_boolean(:undercover)
        test_update_boolean(:lights)
        test_update_boolean(:private_property)
        # describe 'set park' do
        #     describe 'to valid value' do
        #         context 'true' do
        #             before { xhr :put, :update, :id => @spot.id, :park => 'true' }

        #             it { expect(response).to be_success }
        #             it { expect(response).to have_http_status(200) }
        #             it { expect(response.content_type).to eql('application/json') }
        #             it { expect(response.body).to eql(success) }
        #             it { expect(SkateSpot.find(@spot).park).to be_truthy }
        #         end

        #         context 'false' do
        #             before { xhr :put, :update, :id => @spot.id, :park => 'false' }

        #             it { expect(response).to be_success }
        #             it { expect(response).to have_http_status(200) }
        #             it { expect(response.content_type).to eql('application/json') }
        #             it { expect(response.body).to eql(success) }
        #             it { expect(SkateSpot.find(@spot).park).to be_falsey }
        #         end
        #     end

        #     context 'to invalid value' do
        #         let(:park_value) { @spot.park }
        #         before { xhr :put, :update, :id => @spot.id, :park => 'invalid' }

        #         it { expect(response).to be_success }
        #         it { expect(response).to have_http_status(200) }
        #         it { expect(response.content_type).to eql('application/json') }
        #         it { expect(response.body).to eql(failure) }
        #         it { expect(SkateSpot.find(@spot).park).to eql(park_value) }
        #     end
        # end
        
        # it "returns http success" do
        #     get :update
        #     expect(response).to be_success
        # end
    end

    describe 'DELETE #destroy' do
        context 'invalid spot' do
            before { xhr :delete, :destroy, :id => 0 }

            it { expect(response).to be_success }
            it { expect(response).to have_http_status(200) }
            it { expect(response.content_type).to eql('application/json') }
            it { expect(response.body).to eql(failure) }
            it { expect(SkateSpot.all.count).to eql(1) }
        end

        context 'valid spot' do
            before { xhr :delete, :destroy, :id => @spot.id }

            it { expect(response).to be_success }
            it { expect(response).to have_http_status(200) }
            it { expect(response.content_type).to eql('application/json') }
            it { expect(response.body).to eql(success) }
            it { expect(SkateSpot.all.count).to eql(0) }
        end
    end
end
