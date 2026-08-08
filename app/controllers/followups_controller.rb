class FollowupsController < BaseController
  def index
    authorize :followup
    @bucket_options = Batch.buckets.except('archive').keys
    @selected_bucket = params[:bucket].presence_in(@bucket_options)
    @first, @second, @third, @fourth, @fifth, @sixth = current_user.follow_ups(bucket: @selected_bucket)
  end
end
