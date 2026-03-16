class RegistrationsController < ApplicationController
  layout "auth"

  before_action :build_form

  def new
  end

  def create
    resource = @form.submit(registration_params)
    if resource.nil? || !resource.persisted?
      show_errors
    else
      reset_session
      session[:user_id] = resource.id
      flash[:notice] = "Welcome! You have signed up successfully."
      redirect_to root_path
    end
  end

  def show_errors
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("sign_up_form", partial: "registrations/form", locals: { resource: @form }) }
    end
  end

  private

  def registration_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def build_form
    @form ||= SignUpForm.new
  end
end
