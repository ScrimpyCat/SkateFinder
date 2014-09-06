class ObstacleType < ActiveRecord::Base
    validates :name, :presence => true, :length => { :maximum => 25 }, :uniqueness => { :case_sensitive => false }

    has_many :obstacles, :foreign_key => :type_id
end
