require 'rails_helper'

RSpec.describe SpotName, :type => :model do
	before { @spot_name = FactoryGirl.build(:spot_name) }
	subject { @spot_name }

	it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:spot) }

	it { is_expected.to be_valid }

	describe 'name' do
        context 'is empty' do
            before { @spot_name.name = '' }
            it { is_expected.to_not be_valid }
        end

        context 'is nil' do
            before { @spot_name.name = nil }
            it { is_expected.to_not be_valid }
        end

        context 'is too long' do
            before { @spot_name.name = 'a'*81 }
            it { is_expected.to_not be_valid }
        end

        context 'already taken' do
            before {
                spot_name_with_same_name = @spot_name.dup
                spot_name_with_same_name.save
            }

            it { is_expected.to_not be_valid }
        end
    end

    describe 'spot is missing' do
        before { @spot_name.spot = nil }
        it { is_expected.to_not be_valid }
    end
end
