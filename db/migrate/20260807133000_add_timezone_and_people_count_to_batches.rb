class AddTimezoneAndPeopleCountToBatches < ActiveRecord::Migration[8.1]
  def change
    add_column :batches, :timezone, :string
    add_column :batches, :people_count, :integer

    add_check_constraint :batches,
                         'people_count IS NULL OR people_count > 0',
                         name: 'batches_people_count_positive'
  end
end