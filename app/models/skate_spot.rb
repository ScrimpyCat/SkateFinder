class SkateSpot < ActiveRecord::Base
	# validates :currency, :length => { :minimum => 3, :maximum => 3 }

	belongs_to :name, :class_name => 'SpotName'
	has_many :alt_names, :foreign_key => :spot
	has_many :alternative_names, :through => :alt_names, :source => :name
	# has_many :obstacles
end
