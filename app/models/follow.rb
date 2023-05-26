class Follow < ApplicationRecord
    def self.create_or_enable(from, to)
        re_follow = false
        if self.find_by(from: from, to: to, enable: true) then
            return 0
        else
            if follow = self.find_by(from: from, to: to, enable: false)
                follow.enable = true
                re_follow = true
            else
                follow = self.new(from: from, to: to, enable: true)
            end
            if follow.save!
                if re_follow then
                    return 2
                end
                return 1
            else
                return 0
            end
        end
    end

    def self.disable(from, to)
        if self.find_by(from: from, to: to, enable: false) then
            return 0
        else
            if follow = self.find_by(from: from, to: to) then
                follow.enable = false
            else
                # こんなパスは通らないはず
                follow = self.new(from: from, to: to, enable: false)
            end
            if follow.save!
                return 1
            else
                return 0
            end
        end
    end
end
