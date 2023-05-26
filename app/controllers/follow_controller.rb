class FollowController < ApplicationController
  before_action :login_only, only: [:create, :disable, :followers_list, :follows_list]

  def create
    result = {}
    target_user = User.find_by(screen_name: params[:screen_name])
    result['refollow'] = false
    if target_user then
      if ret = Follow.create_or_enable(current_user.id, target_user.id) then
        result['success'] = true
        result['message'] = "フォローしました"
        if ret == 2 then
          result['refollow'] = true
        else
          Notification.notify(1, target_user, current_user)
        end
      else
        result['success'] = false
        result['message'] = "フォロー失敗しました"
      end
    else
      result['success'] = false
      result['message'] = "そんなユーザーいません"
    end

    render :json => result
  end

  def disable
    result = {}
    target_user = User.find_by(screen_name: params[:screen_name])

    if target_user then
      if ret = Follow.disable(current_user.id, target_user.id) then
        result['success'] = true
        result['message'] = "フォローを解除しました"
      else
        result['success'] = false
        result['message'] = "フォロー解除に失敗しました"
      end
    else
      result['success'] = false
      result['message'] = "そんなユーザーいません"
    end
    render :json => result
  end

  def follows_list
    follows = Follow.where(from: current_user.id)
    @users = []
    follows.each do |follow|
      if user = User.find_by(id: follow.to) then
        @users.append(user)
      end
    end
    @users = Kaminari.paginate_array(@users).page(params[:page]).per(30)
  end

  def followers_list
    followers = Follow.where(to: current_user.id)
    @users = []
    followers.each do |follower|
      if user = User.find_by(id: follower.from) then
        @users.append(user)
      end
    end
    @users = Kaminari.paginate_array(@users).page(params[:page]).per(30)
  end
end
