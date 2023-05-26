class NotificationController < ApplicationController
    before_action :login_only, only: [:show]

    def show
        @notifications = Notification.order(id: "DESC").where(to: current_user.id).page(params[:page]).per(ENV['HOMETES_PER_ONE_PAGE'].to_i)
        @notifications_count = 0
    end
end
