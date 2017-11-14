class UserMailer < ActionMailer::Base
  def account_created(email, password)
    @email = email
    @password = password

    mail :subject => 'Account was created',
         :to => @email
  end
end
