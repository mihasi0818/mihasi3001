class ChangeColumnNameInTable < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :email, :text, null: false, index: { unique: true }
  end
end
