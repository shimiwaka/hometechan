module HomeHelper
  def convert_tag(str)
    str = str.gsub("<","&lt;")
    str = str.gsub(">","&gt;")
    str = str.gsub("\n","<br>")
    Rinku.auto_link(str, :all, 'target="_blank"')
  end

  def omit_content(str, id)
    if str.length > ENV['NOT_OMITTED_LIMIT'].to_i then
      str.slice!(ENV['NOT_OMITTED_LIMIT'].to_i, str.length)
      str += "<br /><br /><a href=\"/homete/#{id}\">続きを読む</a>"
    end
    str
  end

  def showIcon(target_user, size=50)
    if target_user.icon_image.to_s.include?(".png") or target_user.icon_image.to_s.include?(".jpg") \
      or target_user.icon_image.to_s.include?(".jpeg") or target_user.icon_image.to_s.include?(".gif") then
      "<img src=\"#{target_user.icon_image}\" width=\"#{size}px\" height=\"#{size}px\">".html_safe
    else
      "<img src=\"/uploads/default_icon.png\" width=\"#{size}px\" height=\"#{size}px\">".html_safe
    end
  end

  def showHomeruCount(to, type)
    if type == 0 then #all
      homerus = Homeru.where(to: to)
    else
      homerus = Homeru.where(to: to, hometype: type)
    end
    "#{homerus.count}"
  end
end