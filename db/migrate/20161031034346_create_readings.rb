class CreateReadings < ActiveRecord::Migration[5.0]
  def change
    create_table :readings do |t|
      t.belongs_to :fitbit_user, foreign_key: true
      t.integer :lifetime_steps
      t.integer :monthly_steps
      t.integer :average_steps

      t.timestamps
    end
  end
end
