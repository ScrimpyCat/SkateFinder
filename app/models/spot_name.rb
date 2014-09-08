class SpotName < ActiveRecord::Base
    validates :name, :presence => true, :length => { :maximum => 80 }, :uniqueness => { :case_sensitive => false }
    validates :spot, :presence => true

    belongs_to :spot, :class_name => 'SkateSpot'
end
