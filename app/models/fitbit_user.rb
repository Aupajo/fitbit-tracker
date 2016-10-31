class FitbitUser < ApplicationRecord
  has_one :authenticated_user
  has_many :readings

  def latest_reading
    readings.last
  end

  def last_synced_at
    latest_reading&.last_synced_at
  end
end
