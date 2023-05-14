class CreateCountdowns < ActiveRecord::Migration[7.0]
  def change
    create_table :countdowns do |t|
      t.date :countdown

      t.timestamps
    end
  end
end
