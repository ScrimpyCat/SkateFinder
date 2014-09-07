class AltName < ActiveRecord::Base
	validates :spot, :presence => true
	validates :name, :presence => true

	belongs_to :spot, :class_name => 'SkateSpot'
	belongs_to :name, :class_name => 'SpotName'
end
