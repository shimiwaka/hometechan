class Notification < ApplicationRecord
    def self.notify(type, to, from)
        if type == 1 then
            self.create(notitype: 1,
                        content: "<a href=\"/status/#{from.screen_name}\">#{from.name}</a>さんにフォローされました",
                        to: to.id,
                        read: false)
        elsif type == 2 then
            homerus = Homeru.where(to: to.id)
            count = homerus.count

            target_content = to.content

            if target_content.length > 29 then
                target_content.slice!(29, target_content.length)
                target_content += "…"
            end

            content = nil
            if count == 1 then
                content = "<a href=\"/homete/#{to.id}\">" + target_content + "</a>が1回ほめられました"
            elsif count == 3 then
                content = "<a href=\"/homete/#{to.id}\">" + target_content + "</a>が3回ほめられました"
            elsif count == 5 then
                content = "<a href=\"/homete/#{to.id}\">" + target_content + "</a>が5回ほめられました"
            else
                digit = count.to_s.length.to_i
                if digit >= 2 then
                    if count % (10 ** (digit -1)) == 0 then
                        content = "<a href=\"/homete/#{to.id}\">" + target_content + "</a>が#{count}回ほめられました"
                    end
                end
            end

            if content then
                self.create(notitype: 2,
                            content: content,
                            to: to.author,
                            read: false)
            end
        end
    end
end
