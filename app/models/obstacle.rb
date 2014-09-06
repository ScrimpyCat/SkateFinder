class Obstacle < ActiveRecord::Base
	validates :type, :presence => true

    belongs_to :type, :class_name => 'ObstacleType'
end
