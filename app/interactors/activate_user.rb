class ActivateUser < Patterns::Service
  def initialize(actor, user)
    @actor = actor
    @user = user
  end

  def call
    begin
      activate
      add_event
    rescue
      user
    end
    user
  end

  private

  def activate
    user.update(permission: "true")
  end

  def add_event
    Event.create(user: actor, action: "activated", action_for_context: "activated a user", eventable: user)
  end

  attr_reader :actor, :user
end
