class PolygonValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        record.errors.add attribute, 'must have at least 4 points, with the last point the same as the first' unless value =~ /\A\[(\[[-\d.]+,[-\d.]+\]),(\[[-\d.]+,[-\d.]+\],){2,}\1\]\z/
    end
end