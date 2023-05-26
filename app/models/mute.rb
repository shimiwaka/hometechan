class Mute < ApplicationRecord
    def self.is_mute(from, to)
        if self.find_by(from: from, to:to) then
            true
        else
            false
        end
    end
end
