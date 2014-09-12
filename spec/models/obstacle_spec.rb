require 'rails_helper'

RSpec.describe Obstacle, :type => :model do
    before { @obstacle = FactoryGirl.build(:obstacle) }
    subject { @obstacle }

    it { is_expected.to respond_to(:type) }
    it { is_expected.to respond_to(:geometry) }
    it { is_expected.to respond_to(:spot) }

    it { is_expected.to be_valid }

    describe 'without type' do
        before { @obstacle.type = nil }
        it { is_expected.to_not be_valid }
    end 

    describe 'without spot' do
    	before { @obstacle.spot = nil }
    	it { is_expected.to_not be_valid }
    end

    describe 'geometry' do
            context 'has no geometry' do
                before { @obstacle.geometry = nil }
                it { is_expected.to be_valid }
            end

            describe 'has array' do
                context 'valid' do
                    before { @obstacle.geometry = [[0,0],[0,1],[1,1],[0,0]] }
                    it { is_expected.to be_valid }
                end

                context 'invalid' do
                    before { @obstacle.geometry = [[0,0],[0,1],[1,1]] }
                    it { is_expected.to_not be_valid }
                end
            end

            context 'has correct structure' do
                before { @obstacle.geometry = '[[0,0],  [0,    1],    [1,1],[0,0]]' }
                it { is_expected.to be_valid }
            end
            context 'has correct structure' do
                before { @obstacle.geometry = [[0,0],[0,1],[1,1],[0.75,0.75],[0.5,-1],[0.25,0.75],[1,0],[0,0]].to_s }
                it { is_expected.to be_valid }
            end

            context 'has incorrect structure' do
                before { @obstacle.geometry = [[0,0],[0,1],[1,1],[0.75,0.75],[0.5,1],[0.25,0.75],[1,0],[0,0]].to_s[1..-1] }
                it { is_expected.to_not be_valid }
            end

            context 'does not finish with first point' do
                before { @obstacle.geometry = [[0,0],[0,1],[1,1],[0.75,0.75],[0.5,1],[0.25,0.75],[1,0]].to_s }
                it { is_expected.to_not be_valid }
            end

            context 'has less than four points' do
                before { @obstacle.geometry = [[0,0],[0,1],[0,0]].to_s }
                it { is_expected.to_not be_valid }
            end
        end
end
