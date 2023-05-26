class HometeController < ApplicationController
  before_action :login_only, only: [:create, :edit, :update, :destroy, :destroy_ajax, :popular, :search]

  def create
    if current_user.locked then
      flash[:notice] = "あなたのアカウントはロックされています"
      redirect_to root_path
      return
    end

    if params[:images] then
      if ENV['IMAGE_LIMIT'].to_i < params[:images].size then
        flash[:notice] = "画像数の上限を超えています（最大5枚）"
        redirect_to root_path
        return
      end
    end

    if params[:content].length > ENV['CONTENT_MAX_LENGTH'].to_i then
      flash[:notice] = "文字数の上限を超えています（最大#{ENV['CONTENT_MAX_LENGTH']}文字）"
      redirect_to root_path
      return
    end

    f = Homete.create( homete_create_params )
    if f then
      if f.id then
        flash[:notice] = "投稿に成功しました"
      else
        flash[:notice] = "投稿に失敗しました"
      end
    else
      flash[:notice] = "投稿に失敗しました"
    end

    redirect_to root_path
  end

  def edit
    @homete = Homete.find_by(id: params[:id])
    if @homete.author != current_user.id then
      flash[:notice] = "自分のほめて以外は編集できません"
      redirect_to "/homete/#{params[:id]}"
      return
    end
  end

  def update
    @homete = Homete.find_by(id: params[:id])
    if @homete.author != current_user.id then
      flash[:notice] = "自分のほめて以外は編集できません"
      redirect_to "/homete/#{params[:id]}"
      return
    end

    @homete.update(homete_update_params)
    redirect_to "/homete/#{params[:id]}"
  end

  def destroy
    @homete = Homete.find_by(id: params[:id])
    if @homete.author != current_user.id && current_user.screen_name != ENV["ADMIN_SCREEN_NAME"] then
      flash[:notice] = "自分のほめて以外は削除できません"
      redirect_to "/homete/#{params[:id]}"
      return
    end

    if @homete.destroy then
      flash[:notice] = "削除に成功しました"
      homerus = Homeru.where(to: params[:id])
      homerus.each do |homeru|
        homeru.destroy
      end
    else
      flash[:notice] = "削除に失敗しました"
    end
    redirect_to root_path
  end

  def destroy_ajax
    result = {}

    @homete = Homete.find_by(id: params[:id])
    if @homete.author != current_user.id && current_user.screen_name != ENV["ADMIN_SCREEN_NAME"] then
      result['success'] = false
      render :json => result
      return
    end

    if @homete.destroy then
      result['success'] = true
      homerus = Homeru.where(to: params[:id])
      homerus.each do |homeru|
        homeru.destroy
      end
    else
      result['success'] = false
    end
    render :json => result
  end

  def popular
    @popular_hometes = []
    from = Time.now - ENV['POPULAR_HOMETE_LIMIT'].to_i.hour
    to = Time.now
    recent_homerus = Homeru.where(created_at: from..to).pluck(:to)
    most_homerare_hometes = recent_homerus.group_by(&:itself).transform_values(&:size)
    most_homerare_hometes = most_homerare_hometes.sort_by { |_, v| -v }.to_h
   
    most_homerare_hometes.each do |id, val|
      homete = Homete.find_by(id: id)
      if homete then
        user = User.find_by(id: homete.author)
        if user then
          if !user.locked then
            @popular_hometes.append(homete)
          end
        end
      end
    end
    @popular_hometes = Kaminari.paginate_array(@popular_hometes).page(params[:page]).per(ENV['HOMETES_PER_ONE_PAGE'].to_i)

    # TODO おすすめ投稿が15人に満たない場合は最新の投稿を表示
    if @popular_hometes.count < 15 then
      @popular_hometes = Homete.all.order(id: "DESC").page(params[:page]).per(ENV['HOMETES_PER_ONE_PAGE'].to_i)
    end
  end
  
  def show
    @homete = Homete.find_by(id: params[:id])
  end

  def search
    @query = params[:query]
    if params[:query] then
      @hometes = Homete.order(id: "DESC").where('content like ?', '%' + params[:query] + '%').page(params[:page]).per(ENV['HOMETES_PER_ONE_PAGE'].to_i)
    else
      @hometes = []
    end
  end

  private
  def homete_create_params
    params[:author] = current_user.id
    params.permit(:author, :content, { images: [] })
  end
  
  def homete_update_params
    params[:author] = current_user.id
    if params[:not_change_image] == "1" then
      params.permit(:author, :content)
    else
      if !params[:images] then
        params[:images] = []
      end
      params.permit(:author, :content, { images: [] })
    end
  end
end
