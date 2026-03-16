class ApplicationController < ActionController::Base
  include Pundit

  include Pagy::Backend

  protect_from_forgery with: :null_session
  protect_from_forgery with: :exception, unless: :json_request?

  skip_before_action :verify_authenticity_token, if: :json_request?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::InvalidAuthenticityToken,
              with: :token_verification
  rescue_from ActionController::InvalidAuthenticityToken, with: :token_verification
  rescue_from Pundit::NotDefinedError, with: :record_not_found
  rescue_from ActiveRecord::InvalidForeignKey, with: :show_referenced_alert
  rescue_from ActsAsTenant::Errors::NoTenantSet, with: :user_not_authorized
  rescue_from ActiveRecord::DeleteRestrictionError, with: :show_referenced_alert
  rescue_from Pagy::OverflowError, with: :record_not_found
  before_action :set_redirect_path, unless: :user_signed_in?

  helper_method :current_user, :user_signed_in?

  etag {
    if Rails.env == "production" or Rails.env == "staging"
      deployment_version
    else
      "development"
    end
  }

  def script_name
    "/#{current_user.account.id}"
  end

  fragment_cache_key do
    "development"
  end

  def deployment_version
    ENV["LATEST_GITHUB_COMMIT"] if Rails.env == "production" or Rails.env == "staging"
  end

  def render_partial(partial, collection:, cached: true)
    respond_to do |format|
      format.html
      format.json {
        render json: { entries: render_to_string(partial: partial, formats: [:html], collection: collection, cached: cached),
                       pagination: render_to_string(partial: "shared/paginator", formats: [:html], locals: { pagy: @pagy }) }
      }
    end
  end

  def set_redirect_path
    @redirect_path = request.path
  end

  def show_referenced_alert(exception)
    respond_to do |format|
      if http_request?
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("modal", partial: "shared/modal", locals: { title: "Unable to Delete Record", message: "This record has been associated with other records in system therefore deleting this might result in unexpected behavior. If you want to delete this please make sure all assosications have been removed first.", main_button_visible: false })
        }
      else
        format.json { render json: { success: false, message: "This record has been associated with other records in system therefore deleting this might result in unexpected behavior. If you want to delete this please make sure all assosications have been removed first." } }
      end
    end
  end

  def show_delete_confirmation_alert
    show_confirmation_alert("Delete Record", "Are you sure you want to delete this record?")
  end

  def show_confirmation_alert(title, message)
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace("modal", partial: "shared/modal", locals: { title: title, message: message, main_button_visible: true })
      }
    end
  end

  def user_not_authorized
    if http_request?
      redirect_to(request.referrer || landing_path)
    else
      render json: { success: false, message: "You are not allowed to access this page." }
    end
  end

  def signed_in_root_path(resource)
    landing_path
  end

  def record_not_found
    if http_request?
      user_not_authorized
    else
      render json: { success: false, message: "Record Not Found" }
    end
  end

  def landing_path
    dashboard_path(script_name: script_name)
  end

  def script_name
    "/#{current_user.account.id}"
  end

  def invalid_token
    reset_session
    cookies.delete(:remember_token)
    redirect_to login_path, alert: "Your session has expired. Please login again."
  end

  def render_timeline(partial, collection:, cached: true)
    respond_to do |format|
      format.html
      format.json {
        render json: { entries: render_to_string(partial: partial, formats: [:html], collection: collection, as: :event, cached: cached),
                       pagination: render_to_string(partial: "shared/paginator", formats: [:html], locals: { pagy: @pagy }) }
      }
    end
  end

  private

  def current_user
    @current_user ||= if session[:user_id]
      User.find_by(id: session[:user_id])
    elsif cookies.signed[:remember_token]
      user = User.find_by(id: cookies.signed[:remember_token])
      if user
        session[:user_id] = user.id
        user
      end
    end
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_user!
    unless user_signed_in?
      if json_request?
        head 401
      else
        redirect_to login_path, alert: "You need to sign in to continue."
      end
    end
  end

  def json_request?
    request.format.json? and request.url.include?("api")
  end

  def http_request?
    !json_request?
  end

  def invalid_auth_token
    respond_to do |format|
      format.html {
        redirect_to login_path,
                    error: "Login invalid or expired"
      }
      format.json { head 401 }
    end
  end

  def token_verification
    json_request? ? invalid_auth_token : invalid_token
  end
end
