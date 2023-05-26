class Homeru < ApplicationRecord
    def self.create_or_disable(from, to, type, ip_address)
        if Homete.find_by(id: to, author: from) then
            return false
        elsif self.find_by(author: from, to: to, hometype: type) then
            return false
        elsif from == 0 and self.find_by(author: 0, to: to, hometype: type, ip_address: ip_address.to_s) then
           return false
        else
            homeru = self.new(author: from, to: to, hometype: type,
                              ip_address: ip_address.to_s)
            if homeru.save!
                return true
            else
                return false
            end
        end
    end
end
