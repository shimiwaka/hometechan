class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :get_notification_count
    protected

    def configure_permitted_parameters
      added_attrs = [:screen_name, :email, :password, :password_confirmation, :remember_me]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit :sign_in, keys: [:login, :password]
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end

    def login_only
        if !current_user then
            redirect_to new_user_session_path
        end
    end
    
    def admin_only
        if current_user.screen_name != ENV['ADMIN_SCREEN_NAME'] then
            redirect_to new_user_session_path
        end
    end

    def get_notification_count
        if current_user then
            notifications = Notification.where(to: current_user.id, read: false)
            @notifications_count = notifications.count
        end
    end
end
