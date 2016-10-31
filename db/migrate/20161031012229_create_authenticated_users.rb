class CreateAuthenticatedUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :authenticated_users do |t|
      t.belongs_to :fitbit_user, foreign_key: true, null: false
      t.string :access_token, null: false
      t.string :refresh_token, null: false
      t.text :watching, array: true, default: []

      t.timestamps
    end
  end
end
