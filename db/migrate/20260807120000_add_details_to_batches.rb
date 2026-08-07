class AddDetailsToBatches < ActiveRecord::Migration[8.1]
  def change
    change_table :batches, bulk: true do |t|
      t.string :linkedin
      t.string :twitter
      t.string :jobboard
      t.string :country
      t.string :state
      t.string :city
      t.string :address
      t.integer :bucket, default: 0, null: false
      t.integer :touch_back_after, default: 0, null: false
      t.string :about
      t.boolean :archived, default: false, null: false
      t.date :followup_after_changed_on
      t.date :touched_at
    end
  end
end