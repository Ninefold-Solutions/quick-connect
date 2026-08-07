class BackfillBatchDetails < ActiveRecord::Migration[8.1]
  def up
    Batch.reset_column_information

    ActsAsTenant.without_tenant do
      Batch.find_each do |batch|
        batch.update_columns(
          linkedin: batch.linkedin || "",
          twitter: batch.twitter || "",
          jobboard: batch.jobboard || "",
          country: batch.country || "",
          state: batch.state || "",
          city: batch.city || "",
          address: batch.address || "",
          bucket: batch.bucket_before_type_cast || 0,
          touch_back_after: batch.touch_back_after || 0,
          about: batch.about || "",
          archived: batch.archived.nil? ? false : batch.archived,
          followup_after_changed_on: batch.followup_after_changed_on,
          touched_at: batch.touched_at
        )
      end
    end
  end

  def down
  end
end