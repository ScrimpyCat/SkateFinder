class SkateSpot < ActiveRecord::Base
	Style = {
		:unknown => 0,
		:street => 1 << 0,
		:vert => 1 << 1
	}

	validates :geometry, :presence => true
    validates :currency, :allow_blank => true, :length => { :is => 3 }

    belongs_to :name, :class_name => 'SpotName'
    has_many :alt_names, :class_name => 'SpotName', :foreign_key => :spot_id, :dependent => :destroy
    has_many :obstacles, :foreign_key => :spot_id, :dependent => :destroy
end
