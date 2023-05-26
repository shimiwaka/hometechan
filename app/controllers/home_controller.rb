class HomeController < ApplicationController
  def index
    @hometes = []
    if current_user then
      #recommended_hometes = get_recommend_hometes(100)
      recommended_hometes = []
      @follow = Follow.where(from: current_user.id, enable: true).pluck(:to)
      @follow.append(current_user.id)
      @follower = Follow.where(to: current_user.id)

      if rand(0...10) == 0 || \
        current_user.homeru_count == 0 || !current_user.homeru_count || \
        current_user.homerare_count == 0 || !current_user.homerare_count then
        @homerus = Homeru.where(author: current_user.id)
        homerare_count = 0
        homerares = Homete.where(author: current_user.id)
        homerares.each do |homerare|
          h = Homeru.where(to: homerare.id)
          homerare_count += h.count
        end
        current_user.update(homeru_count: @homerus.count, homerare_count: homerare_count)
      end
      
      recommend_ids = []
      recommended_hometes.each do |homete|
        recommend_ids.append(homete.id)
      end
      
      @pages = false
      if params[:page] then
        @pages = true
      end

      # おすすめほめてが50より少なかったら、最新の投稿も対象に入れる
      if recommend_ids.count < 50 then
        recent_homete_ids = Homete.all.order(id: "DESC").limit(50).pluck(:id)
        @hometes = Homete.order(id: "DESC").where(:author => @follow).\
        or(Homete.where(:id => recommend_ids)).\
        or(Homete.where(:id => recent_homete_ids)).\
        page(params[:page]).per(ENV['HOMETES_PER_ONE_PAGE'].to_i)
      else 
        # おすすめほめてが十分にあれば、フォローしている人と、おすすめほめてだけをTLの対象
        @hometes = Homete.order(id: "DESC").where(:author => @follow).\
        or(Homete.where(:id => recommend_ids)).\
        page(params[:page]).per(ENV['HOMETES_PER_ONE_PAGE'].to_i)
      end

      @homeru_count = current_user.homeru_count
      @homerare_count = current_user.homerare_count
    else
      @hometes = get_recommend_hometes(30)
    end
  end

  private
  def get_recommend_hometes(count)
    recommended_hometes = []
    from = Time.now - ENV['RECOMMEND_HOMETE_LIMIT'].to_i.hour
    to = Time.now
    recent_homerus = Homeru.where(created_at: from..to).pluck(:author)
    most_homeru_users = recent_homerus.group_by(&:itself).transform_values(&:size)
    most_homeru_users = most_homeru_users.sort_by { |_, v| -v }.to_h

    total = 0
    ref_val = {}
    target_users = {}
    most_homeru_users.each do |id, val|
      if Homete.where(author: id).count == 0
        next
      end
      # フォローしている人は除外する
      if current_user then
        if Follow.find_by(from: current_user.id, to: id, enable: true) then
          next
        end
      end
      if id == 0 then
        next
      end
      total += val
      ref_val[id] = total
      target_users[id] = 0
    end

    for i in 1..count do
      r = rand(total)
      ref_val.each do |id, val|
        if val > r then
          target_users[id] += 1
          break
        end
      end
    end

    target_users.each do |id, count|
      user = User.find_by(id: id)
      hometes = Homete.order(id: "DESC").where(author: user.id).limit(count)
      recommended_hometes += hometes
    end

    recommended_hometes = recommended_hometes.sort_by{|x| x.created_at}.reverse
  end
end
