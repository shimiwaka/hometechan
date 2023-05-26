class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  mount_uploader :icon_image, IconImageUploader
  after_initialize :set_default_values
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable ,
         :omniauthable, omniauth_providers: [:twitter]
  validates :name, presence: true
  validates :screen_name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z\d_]+\z/ }

  attr_writer :login

  def login
    @login || self.screen_name || self.email
  end
  
  def update_without_current_password(params, *options)
    params.delete(:current_password) 
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(screen_name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:screen_name) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def self.find_for_oauth(auth)
    user = User.find_by(uid: auth.uid, provider: auth.provider)
    regist_flag = false
   
    default_nickname = auth[:info][:nickname]
    candidate = default_nickname

    if !user then
      if User.find_by(email: auth[:info][:email]) then
        return nil
      end
      i = 0
      while User.find_by(screen_name: candidate) do
        candidate = default_nickname + i.to_s
        i += 1
      end 
      regist_flag = true
    end

    user ||= User.create!(
      uid: auth.uid,
      provider: auth.provider,
      name: auth[:info][:name],
      screen_name: candidate,
      twitter_screen_name: auth[:info][:nickname],
      email: auth[:info][:email],
      password: Devise.friendly_token[0, 20]
    )

    if regist_flag then
      user.remote_icon_image_url = auth[:info][:image]
      user.save
    end
    
    user
  end

  private

  def set_default_values
    self.twitter_screen_name ||= ''
  end
end
