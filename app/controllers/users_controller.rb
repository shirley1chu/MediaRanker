require "pry"

class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    user_id = params[:id]
    @user = user.find_by(id: user_id)
    unless @user
      head :not_found
    end
  end

  def login_form
    @user = User.new
  end

  def login
    username = params[:user][:username]
    user = User.find_by(username: username)
    if user
      session[:user_id] = user.id
      flash[:success] = "Successfully logged in as returning user #{username}"
    else
      user = User.create(username: username)
      session[:user_id] = user.id
      flash[:success] = "Successfully logged in as new user #{username}"
    end

    binding.pry

    redirect_to root_path
  end

  def logout
    session[:user_id] = nil
    flash[:success] = "Successfully logged out"
    redirect_to root_path
  end

  def current
    @current_user = User.find_by(id: session[:user_id])
    unless @current_user
      flash[:error] = "You must be logged in to see this page"
      redirect_to root_path
    end
  end

  private

  def user_params
    return params.require(:user).permit(:username)
  end
end
