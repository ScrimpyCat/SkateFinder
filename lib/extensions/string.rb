class String
    def to_bool
        return true if self =~ /^(true|1)$/i
        return false if self =~ /^(false|0)$/i

        nil
    end
end
