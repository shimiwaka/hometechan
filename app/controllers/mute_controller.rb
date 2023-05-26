class MuteController < ApplicationController
    before_action :login_only

    def enable
        result = {}
        target_user = User.find_by(screen_name: params[:screen_name])
        if target_user then
            if Mute.create(from: current_user.id, to: target_user.id) then
                result['success'] = true
                result['message'] = "ミュートしました"
            else
                result['success'] = false
                result['message'] = "エラーが発生しました"
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
            mute = Mute.find_by(from: current_user.id, to: target_user.id)
            if !mute then
                result['success'] = false
                result['message'] = "その人をミュートしていません"
            else
                if mute.destroy then
                    result['success'] = true
                    result['message'] = "ミュート解除しました"
                else
                    result['success'] = false
                    result['message'] = "エラーが発生しました"
                end
            end
        else
            result['success'] = false
            result['message'] = "そんなユーザーいません"
        end
        render :json => result

    end

    def mutes_list
        mutes = Mute.where(from: current_user.id)
        @users = []
        mutes.each do |mute|
          @users.append(User.find_by(id: mute.to))
        end
    end
end
