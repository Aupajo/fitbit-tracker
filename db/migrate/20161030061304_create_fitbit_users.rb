class CreateFitbitUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :fitbit_users do |t|
      t.string :remote_id, null: false
      t.string :display_name, null: false
      t.string :full_name
      t.jsonb :avatars, default: '{}', null: false
      t.string :timezone, null: false

      t.timestamps
    end

    add_index :fitbit_users, :remote_id, unique: true
  end
end
