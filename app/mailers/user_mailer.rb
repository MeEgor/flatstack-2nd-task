class UserMailer < ActionMailer::Base
  default from: "calendar@hellyeah.com"

  def welcome_email user
    @user = user
    @url  = 'http://localhost:3000'
    mail(to: @user.email, subject: 'Добро пожаловать на "Дарим вместе"')
  end

  def verify_email user
    @url = 'http://localhost:3000'
    @verify_email_url = "http://localhost:3000/users/verify/email/#{user.email_verify_token}"

    mail(to: user.email, subject: 'Подтверждение e-mail: "Дарим вместе"')
  end
end
