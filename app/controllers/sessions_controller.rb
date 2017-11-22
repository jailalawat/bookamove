class SessionsController < ApplicationController
  layout 'sessions'
  require 'securerandom'

  def index
    if (session[:user_id] != nil)
      redirect_to '/home'
    end
  end

  def create
    params[:account] ||= request.subdomain

    @account = Account.where(subdomain: params[:account]).first if params[:account]

    user = User.authenticate(params[:email], params[:password], @account.id) if @account

    if user
      if user.active != true
        flash[:error] = 'Your user account is inactive'
        redirect_to '/' and return
      end
      if @account.active != true
        flash[:error] = 'Your account is inactive'
        redirect_to '/' and return
      end
      session[:user_id] = user.id
      port = ""
      if request.port != 80 and request.port != 443
        port = ":#{request.port.to_s}"
      end
      redirect_to "http://#{@account.subdomain}.#{request.domain}#{port}/home"
    else
      flash[:error] = 'Invalid email or password'
      render 'index'
    end
  end

  def destroy
    Rails.cache.delete("user/#{session[:user_id]}")
    Rails.cache.delete("user_action_role/#{session[:user_id]}")
    Rails.cache.delete("user_action_by_role/#{session[:user_id]}")
    Rails.cache.delete("all_user_actions/#{session[:user_id]}")
    Rails.cache.delete("all_action_by_user/#{session[:user_id]}")
    Rails.cache.delete("role_level/#{session[:user_id]}")
    session[:user_id] = nil
    session.clear
    redirect_to root_url
  end

  def send_password_email
    if params[:email] && params[:email].size > 0
      if user = User.where('email = ?', params[:email]).first
        new_password = SecureRandom.urlsafe_base64(5)
        user.password = new_password
        user.save
        UserMail.send_email_forgot_password(user.name, user.email, 'Your temporary password', new_password, user.account).deliver_later
        flash[:success] = 'An email with your new password has been sent.'
        redirect_to '/'
      else
        flash[:error] = 'No record found'
        render template: "sessions/forgot_password"
      end
    end
  end
end