class SessionsController < ApplicationController
  layout "auth"

  def new
  end

  def create
    @user = User.find_by(email: params[:user][:email]&.downcase&.strip)

    if @user.nil?
      flash[:alert] = "Invalid email or password."
      redirect_to login_path and return
    end

    if @user.permission == "false"
      flash[:alert] = "Your account is deactivated."
      redirect_to login_path and return
    end

    if @user.authenticate(params[:user][:password])
      start_session(@user, remember: params[:user][:remember_me] == "1")
      flash[:notice] = "Signed in successfully."
      redirect_to after_sign_in_path
    else
      flash[:alert] = "Invalid email or password."
      redirect_to login_path
    end
  end

  def destroy
    reset_session
    cookies.delete(:remember_token)
    redirect_to login_path, notice: "Signed out successfully."
  end

  private

  def after_sign_in_path
    if params[:redirect_to].present?
      params[:redirect_to]
    else
      landing_path_for(@user)
    end
  end

  def landing_path_for(user)
    dashboard_path(script_name: "/#{user.account.id}")
  end

  def start_session(user, remember: false)
    reset_session
    session[:user_id] = user.id
    if remember
      cookies.signed[:remember_token] = {
        value: user.id,
        expires: 5.days.from_now,
        httponly: true,
        same_site: :lax
      }
    end
  end
end
