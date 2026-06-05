class FollowupsController < BaseController
  def index
    authorize :followup
    @first, @second, @third, @fourth, @fifth, @sixth = current_user.follow_ups
  end
end
