class AddLastSyncedAtToReadings < ActiveRecord::Migration[5.0]
  def change
    add_column :readings, :last_synced_at, :datetime
  end
end
