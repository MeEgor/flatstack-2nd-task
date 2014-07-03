class User < ActiveRecord::Base
  has_secure_password :validations => false
  attr_accessor :password_confirmation

  validates :email, presence: true, uniqueness: true

  # Если вконтакте не привязан, то пароль обязателен
  validates :password, {
    presence: true,
    :if => Proc.new { |user| !user.has_vk? },
    :on => :create
  }
  # при создании пароль не обязателен, но если он есть, то должен быть не которким и подтвержденным
  validates :password, {
    length: { minimum: 5 },
    :on => :create,
    :if => Proc.new { |user| !user.password.blank? }
  }
  # если есть пароль, то должно быть подтверждеие
  validates :password_confirmation, {
    presence: true,
    :if => Proc.new { |user| !user.password.blank? },
    :on => :create
  }
  # если есть пароль, то подтверждение должно совпадать.
  validates_confirmation_of :password, :if => Proc.new { |user| !user.password.blank? }

  before_create :create_remember_token
  before_create :create_email_confirmation_token

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.new_email_confirmation_token
    SecureRandom.urlsafe_base64 + SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def has_vk?
    !self.vk_uid.nil?
  end

  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

    def create_email_confirmation_token
      self.email_confirmation_token = User.new_email_confirmation_token
      self.email_confirmation_token_expiration_date = Time.now + 3.days
    end
end
