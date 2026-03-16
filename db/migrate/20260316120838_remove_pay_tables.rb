class RemovePayTables < ActiveRecord::Migration[8.1]
  def up
    remove_foreign_key :pay_charges, :pay_customers, column: :customer_id, if_exists: true
    remove_foreign_key :pay_charges, :pay_subscriptions, column: :subscription_id, if_exists: true
    remove_foreign_key :pay_payment_methods, :pay_customers, column: :customer_id, if_exists: true
    remove_foreign_key :pay_subscriptions, :pay_customers, column: :customer_id, if_exists: true

    drop_table :pay_charges, if_exists: true
    drop_table :pay_payment_methods, if_exists: true
    drop_table :pay_subscriptions, if_exists: true
    drop_table :pay_webhooks, if_exists: true
    drop_table :pay_merchants, if_exists: true
    drop_table :pay_customers, if_exists: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
