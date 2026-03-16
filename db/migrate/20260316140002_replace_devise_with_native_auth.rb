class ReplaceDeviseWithNativeAuth < ActiveRecord::Migration[8.1]
  def up
    # Columns already cleaned up - migration is a no-op
    # Originally: renamed encrypted_password to password_digest
    # and removed Devise-specific columns
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
