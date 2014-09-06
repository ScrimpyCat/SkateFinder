require 'rails_helper'

RSpec.describe ObstacleType, :type => :model do
    before { @obstacle_type = FactoryGirl.build(:obstacle_type) }
    subject { @obstacle_type }

    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:obstacles) }

    it { is_expected.to be_valid }

    describe 'name' do
        context 'is empty' do
            before { @obstacle_type.name = '' }
            it { is_expected.to_not be_valid }
        end

        context 'is nil' do
            before { @obstacle_type.name = nil }
            it { is_expected.to_not be_valid }
        end

        context 'is too long' do
            before { @obstacle_type.name = 'a'*26 }
            it { is_expected.to_not be_valid }
        end

        context 'already taken' do
            before {
                obstacle_type_with_same_name = @obstacle_type.dup
                obstacle_type_with_same_name.save
            }

            it { is_expected.to_not be_valid }
        end
    end

    describe 'obstacles' do
        context 'has no references' do
            before { @obstacle_type.save }
            it { expect(@obstacle_type.obstacles).to be_empty }
        end

        context 'has references' do
            before {
                @obstacle_type.save
                FactoryGirl.create(:obstacle, :type => @obstacle_type)
            }
            
            it { expect(@obstacle_type.obstacles).to_not be_empty }
            it { expect(@obstacle_type.obstacles.count).to eql(1) }
        end
    end
end
