class BaseController < ApplicationController
  protect_from_forgery with: :exception
  before_action :set_user, only: %i[ index show edit update destroy create new contacts events deactivate activate add remove ]
  before_action :authenticate_user!
  before_action :authenticate_account!, if: :http_request?
  after_action :verify_authorized

  include Pagy::Method

  def authenticate_account!
    raise Pundit::NotAuthorizedError unless current_user.account == Current.account
  end

  def pagy_nil_safe(params, collection, vars = {})
    options = vars.to_h.symbolize_keys
    options[:page] = params[:page]
    options[:limit] = options.delete(:items) if options.key?(:items) && !options.key?(:limit)

    pagy(:offset, collection, **options)
  end

  LIMIT = 10

  def set_user
    @user = current_user
  end

  def http_request?
    !request.format.json?
  end
end
