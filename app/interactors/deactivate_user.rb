class DeactivateUser < Patterns::Service
  def initialize(actor, user)
    @actor = actor
    @user = user
  end

  def call
    begin
      deactivate
      add_event
    rescue
      user
    end
    user
  end

  private

  def deactivate
    user.update(permission: "false")
  end

  def add_event
    Event.create(user: actor, action: "deactivated", action_for_context: "deactivated an user", eventable: user)
  end

  attr_reader :actor, :user
end
