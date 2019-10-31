class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by email: params[:session][:email].downcase
    if @user&.authenticate(params[:session][:password])
      if @user.activated?
        login_with_activate
      else
        flash[:warning] = t "acount_activate"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "sessions.notification"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def login_with_activate
    log_in @user
    if params[:session][:remember_me] == Settings.number
      remember @user
    else
      forget @user
    end
    redirect_back_or @user
  end
end
