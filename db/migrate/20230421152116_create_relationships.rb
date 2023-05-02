class CreateRelationships < ActiveRecord::Migration[7.0]
  def change
    create_table :relationships do |t|
      t.string  :follower_id, null: false
      t.string :followed_id, null: false

      t.timestamps

      t.index %i[follower_id followed_id], unique: true
      t.foreign_key :users, column: :follower_id, name: 'fk_relationships_follower'
      t.foreign_key :users, column: :followed_id, name: 'fk_relationships_followed'
    end
  end
end
