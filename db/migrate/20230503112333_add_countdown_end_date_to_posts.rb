class AddCountdownEndDateToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :countdown_end_date, :datetime
  end
end
