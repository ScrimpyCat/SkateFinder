class Obstacle < ActiveRecord::Base
	before_validation -> {
        if attribute_present?('geometry')
            if self.geometry.kind_of? String
                self.geometry.gsub!(/ /, '')
            else
                self.geometry = self.geometry.to_s.gsub!(/ /, '') 
            end
        end
    }

    validates :geometry, :allow_nil => true, :format => { :with => /\A\[(\[[-\d.]+,[-\d.]+\]),(\[[-\d.]+,[-\d.]+\],){2,}\1\]\z/ }
    validates :type, :presence => true
    validates :spot, :presence => true

    belongs_to :type, :class_name => 'ObstacleType'
    belongs_to :spot, :class_name => 'SkateSpot'
end
