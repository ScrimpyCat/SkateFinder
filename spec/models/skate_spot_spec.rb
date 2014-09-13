require 'rails_helper'

RSpec.describe SkateSpot, :type => :model do
    before { @skate_spot = FactoryGirl.build(:skate_spot) }
    subject { @skate_spot }

    it { is_expected.to respond_to(:longitude) }
    it { is_expected.to respond_to(:latitude) }
    it { is_expected.to respond_to(:geometry) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:alt_names) }
    it { is_expected.to respond_to(:park) }
    it { is_expected.to respond_to(:style) }
    it { is_expected.to respond_to(:undercover) }
    it { is_expected.to respond_to(:cost) }
    it { is_expected.to respond_to(:currency) }
    it { is_expected.to respond_to(:lights) }
    it { is_expected.to respond_to(:private_property) }
    it { is_expected.to respond_to(:obstacles) }

    it { is_expected.to be_valid }

    describe 'destroying' do
        before {
            FactoryGirl.create(:spot_name, :spot => @skate_spot)
            FactoryGirl.create(:obstacle, :spot => @skate_spot)
            @skate_spot.destroy
        }

        it { is_expected.to be_destroyed }
        it { expect(SpotName.all.count).to eql(0) }
        it { expect(Obstacle.all.count).to eql(0) }
    end

    describe 'name' do
        context 'is missing' do
            before { @skate_spot.name = nil }
            it { is_expected.to be_valid }
        end

        context 'has one' do
            before {
                @skate_spot.name = FactoryGirl.create(:spot_name, :spot => @skate_spot)
            }

            it { is_expected.to be_valid }
            it { expect(subject.name).to_not be_nil }
        end
    end

    describe 'alt_names' do
        context 'are missing' do
            before { @skate_spot.alt_names = [] }

            it { is_expected.to be_valid }
            it { expect(subject.alt_names).to be_empty }
        end

        context 'have multiple' do
            before {
                FactoryGirl.create(:spot_name, :name => 'one', :spot => @skate_spot)
                FactoryGirl.create(:spot_name, :name => 'two', :spot => @skate_spot)
            }

            it { is_expected.to be_valid }
            it { expect(subject.alt_names.count).to eql(2) }
        end

        context 'removed' do
            before {
                FactoryGirl.create(:spot_name, :spot => @skate_spot)
                @skate_spot.alt_names = []
            }

            it { is_expected.to be_valid }
            it { expect(subject.alt_names).to be_empty }
        end
    end

    describe 'style' do
        describe 'valid' do
            context 'integer' do
                let(:value){ SkateSpot::Style[:street] }
                before { @skate_spot.style = value }

                it { is_expected.to be_valid }
                it { expect(subject.style).to eql(value) }
            end

            context 'string' do
                let(:value){ SkateSpot::Style[:street] }
                before { @skate_spot.style = value.to_s }

                it { is_expected.to be_valid }
                it { expect(subject.style).to eql(value) }
            end

            context 'nil' do
                before { @skate_spot.style = nil }

                it { is_expected.to be_valid }
                it { expect(subject.style).to be_nil }
            end

            context 'minimum' do
                let(:value){ SkateSpot::Style[:unknown] }
                before { @skate_spot.style = value }

                it { is_expected.to be_valid }
                it { expect(subject.style).to eql(value) }
            end

            context 'maximum' do
                let(:value){ SkateSpot::Style.values.inject(:|) }
                before { @skate_spot.style = value }

                it { is_expected.to be_valid }
                it { expect(subject.style).to eql(value) }
            end
        end

        describe 'invalid' do
            context 'non-existent flag' do
                before { @skate_spot.style = SkateSpot::Style.values.inject(:|) + 1 }
                it { is_expected.to_not be_valid }
            end
        end
    end

    describe 'cost' do
        describe 'valid' do
            context 'integer' do
                before { @skate_spot.cost = 123 }

                it { is_expected.to be_valid }
                it { expect(subject.cost).to eql(123) }
            end

            context 'string' do
                before { @skate_spot.cost = '123' }

                it { is_expected.to be_valid }
                it { expect(subject.cost).to eql(123) }
            end

            context 'nil' do
                before { @skate_spot.cost = nil }

                it { is_expected.to be_valid }
                it { expect(subject.cost).to be_nil }
            end
        end

        describe 'invalid' do
            context 'float' do
                before { @skate_spot.cost = 1.50 }
                it { is_expected.to_not be_valid }
            end

            context 'non-integer string' do
                before { @skate_spot.cost = 'test' }
                it { is_expected.to_not be_valid }
            end
        end
    end

    describe 'obstacles' do
        context 'are missing' do
            before { @skate_spot.obstacles = [] }

            it { is_expected.to be_valid }
            it { expect(subject.obstacles).to be_empty }
        end

        context 'have multiple' do
            before { FactoryGirl.create(:obstacle, :spot => @skate_spot).dup.save }

            it { is_expected.to be_valid }
            it { expect(subject.obstacles.count).to eql(2) }
        end

        context 'removed' do
            before {
                FactoryGirl.create(:obstacle, :spot => @skate_spot)
                @skate_spot.obstacles = []
            }

            it { is_expected.to be_valid }
            it { expect(subject.obstacles).to be_empty }
        end
    end

    describe 'location' do
        describe 'geometry' do
            context 'has no geometry' do
                before { @skate_spot.geometry = nil }
                it { is_expected.to_not be_valid }
            end

            describe 'has array' do
                context 'valid' do
                    before { @skate_spot.geometry = [[0,0],[0,1],[1,1],[0,0]] }
                    it { is_expected.to be_valid }
                end

                context 'invalid' do
                    before { @skate_spot.geometry = [[0,0],[0,1],[1,1]] }
                    it { is_expected.to_not be_valid }
                end
            end

            context 'has correct structure' do
                before { @skate_spot.geometry = '[[0,0],  [0,    1],    [1,1],[0,0]]' }
                it { is_expected.to be_valid }
            end
            context 'has correct structure' do
                before { @skate_spot.geometry = [[0,0],[0,1],[1,1],[0.75,0.75],[0.5,-1],[0.25,0.75],[1,0],[0,0]].to_s }
                it { is_expected.to be_valid }
            end

            context 'has incorrect structure' do
                before { @skate_spot.geometry = [[0,0],[0,1],[1,1],[0.75,0.75],[0.5,1],[0.25,0.75],[1,0],[0,0]].to_s[1..-1] }
                it { is_expected.to_not be_valid }
            end

            context 'does not finish with first point' do
                before { @skate_spot.geometry = [[0,0],[0,1],[1,1],[0.75,0.75],[0.5,1],[0.25,0.75],[1,0]].to_s }
                it { is_expected.to_not be_valid }
            end

            context 'has less than four points' do
                before { @skate_spot.geometry = [[0,0],[0,1],[0,0]].to_s }
                it { is_expected.to_not be_valid }
            end
        end

        pending 'test longitude and latitude (make sure centroid of geometry)'
    end
end
