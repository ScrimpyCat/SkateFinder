require 'rails_helper'

RSpec.describe Obstacle, :type => :model do
    before { @obstacle = FactoryGirl.build(:obstacle) }
    subject { @obstacle }

    it { is_expected.to respond_to(:type) }
    it { is_expected.to respond_to(:geometry) }

    it { is_expected.to be_valid }

    describe 'without type' do
        before { @obstacle.type = nil }
        it { is_expected.to_not be_valid }
    end 
end
