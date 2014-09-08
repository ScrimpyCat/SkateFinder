require 'rails_helper'

RSpec.describe SkateSpot, :type => :model do
    before { @skate_spot = FactoryGirl.build(:skate_spot) }
    subject { @skate_spot }

    it { is_expected.to respond_to(:longitude) }
    it { is_expected.to respond_to(:latitude) }
    it { is_expected.to respond_to(:geometry) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:alt_names) }
    it { is_expected.to respond_to(:kind) }
    it { is_expected.to respond_to(:style) }
    it { is_expected.to respond_to(:undercover) }
    it { is_expected.to respond_to(:cost) }
    it { is_expected.to respond_to(:currency) }
    it { is_expected.to respond_to(:lights) }
    it { is_expected.to respond_to(:private_property) }
    it { is_expected.to respond_to(:obstacles) }

    it { is_expected.to be_valid }

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
end
