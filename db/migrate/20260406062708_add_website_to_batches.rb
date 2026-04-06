class AddWebsiteToBatches < ActiveRecord::Migration[8.1]
  def change
    add_column :batches, :website, :string
  end
end
