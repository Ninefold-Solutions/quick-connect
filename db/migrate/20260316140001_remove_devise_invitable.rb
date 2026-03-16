class RemoveDeviseInvitable < ActiveRecord::Migration[8.1]
  def up
    drop_table :invitations

    remove_index :users, name: "index_users_on_invitation_token", if_exists: true
    remove_index :users, name: "index_users_on_invited_by_id", if_exists: true
    remove_index :users, name: "index_users_on_invited_by", if_exists: true

    remove_column :users, :invitation_accepted_at
    remove_column :users, :invitation_created_at
    remove_column :users, :invitation_limit
    remove_column :users, :invitation_sent_at
    remove_column :users, :invitation_token
    remove_column :users, :invitations_count
    remove_column :users, :invited_by_id
    remove_column :users, :invited_by_type
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
