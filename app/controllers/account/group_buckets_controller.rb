class Account::GroupBucketsController < Account::BaseController
  def show
    authorize :account
    @bucket_keys = Batch.buckets.keys
    @bucket_names = Batch.bucket_names_for(current_user.account)
  end

  def update
    authorize :account

    bucket_names = Batch.default_bucket_names.merge(bucket_names_params)
    bucket_names.each do |bucket_key, bucket_name|
      bucket_names[bucket_key] = Batch.default_bucket_names[bucket_key] if bucket_name.blank?
    end

    Preference.set_group_bucket_names(current_user.account, bucket_names)

    redirect_to account_group_buckets_path, notice: 'Group buckets were updated successfully.'
  end

  private

  def bucket_names_params
    params.fetch(:bucket_names, {}).permit(*Batch.buckets.keys).to_h.transform_values { |name| name.to_s.strip }
  end
end
