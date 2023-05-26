module HometeHelper
    def shortHomete(str, author)
        if str.length > 49 then
            str.slice!(49, str.length)
        end
        user = User.find_by(id: author)
        str + " | " + user.name + "のほめてちゃん\n"
    end

    def isPushed(pushed_table, id, type)
        if current_user then
            if pushed_table.has_key?("#{id}-#{type}")
                "is-pushed"
            else
                ""
            end
        else
            ""
        end
    end

    def isHometed(pushed_table, id)
        if current_user then
            if pushed_table.has_key?("#{id}")
                "is-hometed"
            else
                ""
            end
        else
            ""
        end
    end
end
