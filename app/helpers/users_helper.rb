module UsersHelper
  require 'time'
  def conv_date(time_str)
    time = Time.strptime(time_str,'%Y-%m-%d %H:%M:%S %z')
    time.strftime("%Y-%m-%d %H:%M:%S")
  end
  
  def is_follow(target_id)
    if Follow.find_by(from: current_user.id, to: target_id, enable: true) then
      return true
    else
      return false
    end
  end

  def is_mute(target_id)
    if !current_user
      return false
    elsif Mute.find_by(from: current_user.id, to: target_id) then
      return true
    else
      return false
    end
  end

  def is_admin(target_user)
    if target_user.screen_name == ENV['ADMIN_SCREEN_NAME'] then
      return true
    else
      return false
    end
  end
end
