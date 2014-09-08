class Obstacle < ActiveRecord::Base
    validates :type, :presence => true
    validates :spot, :presence => true

    belongs_to :type, :class_name => 'ObstacleType'
    belongs_to :spot, :class_name => 'SkateSpot'
end
