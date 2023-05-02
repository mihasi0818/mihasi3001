class AddActivationSentAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :activation_sent_at, :datetime
  end
end
