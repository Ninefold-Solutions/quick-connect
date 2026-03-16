class RemoveEmailEnabledFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :email_enabled, :boolean, default: true
  end
end
