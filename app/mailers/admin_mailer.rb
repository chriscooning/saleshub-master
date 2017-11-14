class AdminMailer < ActionMailer::Base
  def user_signed_up(admin, user)
    @user = user.decorate

    mail :subject => 'User signed up!',
         :to => admin.email
  end
end