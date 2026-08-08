class Preference < ApplicationRecord
  acts_as_tenant :account
  GROUP_BUCKET_NAMES_KEY = 'group_bucket_names'.freeze

  validates_presence_of :key, :value

  def self.group_bucket_names(account)
    preference = find_by(account: account, key: GROUP_BUCKET_NAMES_KEY)
    return {} unless preference&.value.present?

    parsed = JSON.parse(preference.value)
    return {} unless parsed.is_a?(Hash)

    parsed.stringify_keys
  rescue JSON::ParserError
    {}
  end

  def self.set_group_bucket_names(account, bucket_names)
    preference = find_or_initialize_by(account: account, key: GROUP_BUCKET_NAMES_KEY)
    preference.value = bucket_names.stringify_keys.to_json
    preference.save!
  end

  def options_for(key)
    if key == 'delete_timesheets_after_x_days'
      [['1 week', '7'], ['1 month', '30'], ['3 months', '90'], ['1 year', '365'], ['Never', '-1']]
    elsif key == 'delete_deactivated_users_after_x_days'
      [['1 year', '365'], ['2 years', '730'], ['3 years', '1095'], ['Never', '-1']]
    elsif key == 'delete_archived_projects_after_x_days'
      [['1 year', '365'], ['2 years', '730'], ['3 years', '1095'], ['Never', '-1']]
    elsif key == 'consider_overall_kpi_score'
      [['Consider previous KPIs score', 'true'], ['Consider only current KPIs Score', 'false']]
    elsif key == 'transfer_data_to_admin'
      User.where(account: account, permission: :admin).map { |u| [u.decorate.display_name, u.id] }
    end
  end

  def self.transfer_data_to_admin(account)
    admin_id = Preference.where(account: account, key: 'transfer_data_to_admin').first.value.to_i
    User.find(admin_id)
  end

  def self.consider_overall_kpi_score(account)
    Preference.where(account: account, key: 'consider_overall_kpi_score').first.value == 'true'
  end
end
