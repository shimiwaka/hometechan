class AdminController < ApplicationController
    before_action :login_only
    before_action :admin_only

    def top
        @users = User.all.order(id: "ASC").page(params[:page]).per(ENV['HOMETES_PER_ONE_PAGE'].to_i)
        @homete_total = Homete.all.count
        @homeru_total = Homeru.all.count
    end

    def all
        @hometes = Homete.all.order(id: "DESC").page(params[:page]).per(ENV['HOMETES_PER_ONE_PAGE'].to_i)
    end

    def destroy_user
        target_user = User.find_by(id: params[:id])
        if target_user then
            # [TODO] 投稿やいいね、フォローはとりあえず消さない。後で復活の可能性もあるので
            target_user.destroy
        else 
            flash[:notice] = "ユーザーの指定が不正です"
        end
        redirect_to admin_path
    end

    def lock
        target_user = User.find_by(id: params[:id])
        if target_user then
            target_user.update(locked: true)
            flash[:notice] = "ロックしました"
        else 
            flash[:notice] = "ユーザーの指定が不正です"
        end
        redirect_to admin_path
    end

    def unlock
        target_user = User.find_by(id: params[:id])
        if target_user then
            target_user.update(locked: false)
            flash[:notice] = "アンロックしました"
        else 
            flash[:notice] = "ユーザーの指定が不正です"
        end
        redirect_to admin_path
    end
end
