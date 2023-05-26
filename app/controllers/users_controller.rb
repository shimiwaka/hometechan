class UsersController < ApplicationController
  def status
    @target_user = User.find_by(screen_name: params[:screen_name])
    if @target_user then
      @hometes = Homete.where(author: @target_user.id).order(id: "DESC").page(params[:page]).per(ENV['HOMETES_PER_ONE_PAGE'].to_i)
      @follow = Follow.where(from: @target_user.id).pluck
      @follow.append(@target_user.id)
      @follower = Follow.where(to: @target_user.id)
    end
  end

  def lost_mail
  end

  def resend
    @target_user = User.find_by(email: params[:email])
    if @target_user then
      if !@target_user.confirmed? then
        @target_user.send_confirmation_instructions 
        flash[:notice] = "確認メールを再送しました"
      else
        flash[:notice] = "そのアカウントはすでに認証済みです"
      end
    end
    redirect_to root_path
  end
end
