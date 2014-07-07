class User < ActiveRecord::Base
  has_secure_password :validations => false
  attr_accessor :password_confirmation, :email_was, :current_password, :skip_password_validation, :skip_email_validation

  has_many :events, :dependent => :destroy

  # e-mail не обязателен, если привязана учетка ВК
  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :email, {
    presence: true,
    uniqueness: true,
    :unless => lambda { |user| user.has_vk? || user.skip_email_validation }
  }
  validates :email, :format => {:with => VALID_EMAIL_REGEX}, :if => lambda { |user| user.has_email? }

  validates :password,  presence: true, length: { minimum: 5 }, :unless => :skip_password_validation
  validates :password_confirmation, presence: true, :unless => :skip_password_validation
  validates_confirmation_of :password, :unless => :skip_password_validation

  # если email есть, то dfowncase
  before_save { self.email = email.downcase if !email.nil? }
  before_save { self.vk_uid.to_s }
  before_create :create_remember_token
  before_create :create_email_confirmation_token

  before_update :create_email_confirmation_token, :if => 'email_changed?'

  after_initialize { self.email_was = self.email }

  def events_at_day date
    events = self.events.where 'events.started_at = ? OR (events.started_at <= ? AND events.period != 0)', date, date
    events.to_a.delete_if{ |e| !e.filter date }
  end

  def has_password?
    !self.password_digest.blank?
  end

  def events_at_month date
    from = date.beginning_of_month
    to   = date.end_of_month

    events = self.events.where '(events.started_at >= ? AND events.started_at <= ?) OR (events.started_at <= ? AND events.period != 0)',from, to, from
  end

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
    !self.vk_uid.blank?
  end

  def remove_vk
    if !self.has_email? || !self.email_confirmed?
      errors.add(:vk_uid, "Чтобы отвязать учетную запись вам нужен подтвержденный e-mail.")
      return false
    end

    if !has_password?
      errors.add(:vk_uid, "Чтобы отвязать учетную запись вам нужно сначала создать пароль.")
      return false
    end

    self.update_attribute :vk_uid, nil
  end

  def has_email?
    !self.email.blank?
  end

  def email_confirmed?
    !self.email.blank? && self.email_confirmation_token.blank? && self.email_confirmation_token_expiration_date.blank?
  end

  def send_confirm_email
    if !self.email_confirmed?
      self.update_attribute :email_confirmation_token_expiration_date, Time.now + 3.days
      UserMailer.verify_email(self).deliver
    else
      errors.add(:email, "E-mail уже подтвержден.")
      return false
    end
  end

  def confirm_email token
    if !self.email_confirmed?
      if self.email_confirmation_token != token
        errors.add(:email, "Не верный токен подтверждения.")
        return false
      end

      if self.email_confirmation_token_expiration_date < Time.now
        errors.add(:email, "Вышел срок годности токена.")
        return false
      end

      self.update_attribute :email_confirmation_token, nil
      self.update_attribute :email_confirmation_token_expiration_date, nil
    else
      errors.add(:email, "E-mail уже подтвержден.")
        return false
    end
  end

  def email_changed?
    self.email != self.email_was
  end

  def create_password params
    self.password = params[:password]
    self.password_confirmation = params[:password_confirmation]
    self.save
  end

  def change_password params
    if !self.authenticate params[:current_password]
      errors.add(:current_password, "Пароль не верный.")
      return false
    end

    if params[:current_password] == params[:password]
      errors.add :password, "Текущий пароль совпадает с новым."
      return false
    end

    self.password = params[:password]
    self.password_confirmation = params[:password_confirmation]
    self.save
  end

  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

    def create_email_confirmation_token
      self.email_confirmation_token = User.new_email_confirmation_token
    end
end
