class Account::UsersController < Account::BaseController
  before_action :set_user, only: %i[activate deactivate]

  def index
    authorize :account, :users?
    @users = User.where(account: current_user.account).where.not(id: current_user.id).order(created_at: :desc)
    @user = User.new
  end

  def create
    authorize :account, :users?
    @user = AddUser.call(user_params, current_user).result
    respond_to do |format|
      if @user.errors.empty?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:users, partial: "account/users/user", locals: { user: @user }) +
                               turbo_stream.replace(User.new, partial: "account/users/form", locals: { user: User.new, message: "User created successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(User.new, partial: "account/users/form", locals: { user: @user }) }
      end
    end
  end

  def deactivate
    authorize :account, :users?
    if DeactivateUser.call(current_user, @user)
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(@user, partial: "account/users/user", locals: { user: @user })
        }
      end
    end
  end

  def activate
    authorize :account, :users?
    if ActivateUser.call(current_user, @user)
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(@user, partial: "account/users/user", locals: { user: @user })
        }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
