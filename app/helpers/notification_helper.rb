module NotificationHelper
    def already_read(notifications)
        notifications.each do |notification|
            if !notification.read then
                notification.read = true
                notification.save
            end
        end
    end
end
