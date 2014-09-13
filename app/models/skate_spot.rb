class SkateSpot < ActiveRecord::Base
    Style = {
        :unknown => 0,
        :street => 1 << 0,
        :vert => 1 << 1
    }

    validates :geometry, :presence => true, :polygon => true #:format => { :with => /\A\[(\[[-\d.]+,[-\d.]+\]),(\[[-\d.]+,[-\d.]+\],){2,}\1\]\z/ }
    before_validation -> {
        if attribute_present?('geometry')
            if self.geometry.kind_of? String
                self.geometry.gsub!(/ /, '')
            else
                self.geometry = self.geometry.to_s.gsub!(/ /, '') 
            end
        end
    }

    validates :style, :allow_nil => true, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => Style.values.inject(:|) }
    validates :cost, :allow_nil => true, :numericality => { :only_integer => true }
    validates :currency, :allow_blank => true, :length => { :is => 3 }

    belongs_to :name, :class_name => 'SpotName'
    has_many :alt_names, :class_name => 'SpotName', :foreign_key => :spot_id, :dependent => :destroy
    has_many :obstacles, :foreign_key => :spot_id, :dependent => :destroy
end
