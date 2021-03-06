class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.activate.page(params[:page]).per Settings.USER_LIST_PER_PAGE
  end

  def show
    @microposts = @user.microposts.page(params[:page]).per Settings.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "users.new.please"
    else
      flash[:danger] = t "users.new.fail"
    end
    redirect_to root_url
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "users.new.profile"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.new.user"
    else
      flash[:danger] = t "users.new.delete"
    end

    redirect_to users_url
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.new.notfound"
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
                                 :password_confirmation
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "users.new.login"
    redirect_to login_url
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
