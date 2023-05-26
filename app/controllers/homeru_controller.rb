class HomeruController < ApplicationController
  def create
    result = {}
    homete = Homete.find_by(id: params[:to])
    if !homete then
      result['message'] = "そのほめてはありません"
    else
      if current_user then
        result['success'] = Homeru.create_or_disable(current_user.id, params[:to], params[:type],
                                                  request.remote_ip)
      else
        result['success'] = Homeru.create_or_disable(0, params[:to], params[:type],
                                                  request.remote_ip)
      end
      if result['success'] then
        result['message'] = "ほめました"
        Notification.notify(2, homete, nil)
        target = User.find_by(id: homete.author)
        if target then
          target.update(homerare_count: target.homerare_count + 1)
        end
        if current_user then
          current_user.update(homeru_count: current_user.homeru_count + 1)
        end
      else
        result['message'] = "すでにほめているか自分のほめてです"
      end
    end

    render :json => result
  end
end
