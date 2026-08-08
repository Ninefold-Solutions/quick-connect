class FollowupsController < BaseController
  def index
    authorize :followup
    @bucket_options = Batch.buckets.except('archive').keys
    @bucket_names = Batch.bucket_names_for(current_user.account)
    @selected_bucket = params[:bucket].presence_in(@bucket_options)
    @first, @second, @third, @fourth, @fifth, @sixth = current_user.follow_ups(bucket: @selected_bucket)
  end
end
