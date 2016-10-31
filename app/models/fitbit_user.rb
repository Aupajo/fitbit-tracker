class FitbitUser < ApplicationRecord
  has_one :authenticated_user
  has_many :readings
end
