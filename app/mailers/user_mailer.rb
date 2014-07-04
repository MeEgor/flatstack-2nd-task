class UserMailer < ActionMailer::Base
  default from: "calendar@hellyeah.com"

  def welcome_email user
    @user = user
    if Rails.env.development?
      @url  = 'http://localhost:3000'
    elsif Rails.env.production?
      @url = 'http://stark-beyond-6385.herokuapp.com/'
    end

    mail(to: @user.email, subject: 'Добро пожаловать на "Дарим вместе"')
  end

  def verify_email user
    if Rails.env.development?
      @url = 'http://localhost:3000'
    elsif Rails.env.production?
      @url = 'http://stark-beyond-6385.herokuapp.com/'
    end

    @verify_email_url = "#{@url}/#/user/#{user.id}?verify_email_token=#{user.email_confirmation_token}"

    mail(to: user.email, subject: 'Подтверждение e-mail: "Календарь"')
  end
end
