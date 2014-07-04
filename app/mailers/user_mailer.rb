class UserMailer < ActionMailer::Base
  default from: "calendar@hellyeah.com"

  def welcome_email user
    @user = user
    @url  = 'http://localhost:3000'
    mail(to: @user.email, subject: 'Добро пожаловать на "Дарим вместе"')
  end

  def verify_email user
    @url = 'http://localhost:3000'
    @verify_email_url = "#{@url}/#/profile?verify_email_token=#{user.email_confirmation_token}"

    mail(to: user.email, subject: 'Подтверждение e-mail: "Календарь"')
  end
end
