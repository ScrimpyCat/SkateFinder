class ObstacleName < ActiveRecord::Base
    validates :name, :presence => true, :length => { :maximum => 25 }, :uniqueness => { :case_sensitive => false }
end
