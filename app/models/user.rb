class User < ActiveRecord::Base
  has_secure_password :validations => false
  attr_accessor :password_confirmation, :email_was, :current_password, :skip_password_validation

  has_many :events, :dependent => :destroy

  # Если вконтакте не привязан, то e-mail обязателен
  validates :email, {
    presence: true,
    uniqueness: true,
    :unless => :skip_password_validation
  }

  # Если вконтакте не привязан, то пароль обязателен
  validates :password, {
    presence: true,
    :if => Proc.new { |user| !user.has_vk? },
    :on => :create
  }
  # при создании пароль не обязателен, но если он есть, то должен быть не которким и подтвержденным
  validates :password, {
    length: { minimum: 5 },
    # :on => :create,
    :if => Proc.new { |user| !user.password.blank? }
  }
  # если есть пароль, то должно быть подтверждеие
  validates :password_confirmation, {
    presence: true,
    :if => Proc.new { |user| !user.password.blank? },
    # :on => :create
  }
  # если есть пароль, то подтверждение должно совпадать.
  validates_confirmation_of :password, :if => Proc.new { |user| !user.password.blank? }

  # если email есть, то dfowncase
  before_save { self.email = email.downcase if !email.nil? }
  before_create :create_remember_token
  before_create :create_email_confirmation_token, :if => 'has_email?'

  before_update :create_email_confirmation_token, :if => 'email_changed?'

  after_initialize { self.email_was = self.email }

  def events_at_day date
    events = self.events.where 'events.started_at = ? OR (events.started_at <= ? AND events.period != 0)', date, date
    events.to_a.delete_if{ |e| !e.filter date }
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
    !self.vk_uid.nil?
  end

  def has_email?
    !self.email.nil?
  end

  def email_confirmed?
    !self.email.nil? && self.email_confirmation_token.nil? && self.email_confirmation_token_expiration_date.nil?
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
