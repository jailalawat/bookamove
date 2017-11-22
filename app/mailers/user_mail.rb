class UserMail < ActionMailer::Base
  default from: "operations@oomovers.com"
  include ReviewsHelper, ApplicationHelper

  def send_email_password(name, email, subject, tmp_password, account)
    @name = name
    @email = email
    @tmp_password = tmp_password

    @account = account
    @logo = get_logo_by_account(account)
    @tel = account.toll_free_phone

    mail(to: email, :from => @account.email, subject: "Your #{@account.name} account")
  end

  def send_email_forgot_password(name, email, subject, tmp_password, account)
    @name = name
    @email = email
    @tmp_password = tmp_password

    @account = account
    @logo = get_logo_by_account(account)
    @tel = account.toll_free_phone

    mail(to: email, :from => @account.email, subject: subject)
  end
end