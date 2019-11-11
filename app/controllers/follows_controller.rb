class FollowsController < ApplicationController
  before_action :load_user

  def following
    @title = t "following"
    @users = @user.following.page(params[:page]).per Settings.per_page
    render "users/show_follow"
  end

  def followers
    @title = t "follower"
    @users = @user.followers.page(params[:page]).per Settings.per_page
    render "users/show_follow"
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "user_not_found"
    redirect_to root_url
  end
end
