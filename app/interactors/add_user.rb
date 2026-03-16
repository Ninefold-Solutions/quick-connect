class AddUser < Patterns::Service
  def initialize(params, actor)
    @params = params
    @actor = actor
  end

  def call
    begin
      create_user
      add_event
    rescue
      user
    end
    user
  end

  private

  def create_user
    @user = User.new(
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      password: params[:password],
      account: actor.account,
      permission: "true"
    )
    user.skip_confirmation! if user.respond_to?(:skip_confirmation!)
    user.save!
  end

  def add_event
    Event.create(user: actor, action: "added_user", action_for_context: "added new user", eventable: user)
  end

  attr_reader :params, :actor, :user
end
